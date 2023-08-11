/*

Cleaning Data in SQL Queries

*/


SELECT *
FROM PortfolioProject1..NashvilleHousing


--Standardize Date Format

SELECT SaleDate, Convert(Date,SaleDate)
FROM PortfolioProject1..NashvilleHousing

Update NashvilleHousing
SET SaleDate = Convert(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = Convert(Date,SaleDate)

-- Populate Property Address data. Look at ParcelID and PropertyAddress to see if the PropertyAddress is the same with the ParcelID

SELECT *
FROM PortfolioProject1..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

SELECT x.ParcelID, x.PropertyAddress, y.ParcelID, y.PropertyAddress, ISNULL(x.PropertyAddress, y.PropertyAddress)
FROM PortfolioProject1..NashvilleHousing x
JOIN PortfolioProject1..NashvilleHousing y
  ON x.ParcelID = y.ParcelID
  AND x.[UniqueID ] <> y.[UniqueID ]
where x.PropertyAddress is null 

Update x
SET PropertyAddress = ISNULL(x.PropertyAddress, y.PropertyAddress)
FROM PortfolioProject1..NashvilleHousing x
JOIN PortfolioProject1..NashvilleHousing y
  ON x.ParcelID = y.ParcelID
  AND x.[UniqueID ] <> y.[UniqueID ]
where x.PropertyAddress is null 

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject1..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address

FROM PortfolioProject1..NashvilleHousing

ALTER TABLE PortfolioProject1..NashvilleHousing
Add PropertySpiltAddress Nvarchar(255);

Update PortfolioProject1..NashvilleHousing
SET PropertySpiltAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE PortfolioProject1..NashvilleHousing
Add PropertySpiltCity Nvarchar(255);

Update PortfolioProject1..NashvilleHousing
SET PropertySpiltCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
FROM PortfolioProject1..NashvilleHousing





SELECT OwnerAddress
FROM PortfolioProject1..NashvilleHousing

/* Parsename - useful for getting rid of delinear stuff */

SELECT
PARSENAME(REPLACE(OwnerAddress,',', '.'), 3) as Address
,PARSENAME(REPLACE(OwnerAddress,',', '.'), 2) as City
,PARSENAME(REPLACE(OwnerAddress,',', '.'), 1) as State
FROM PortfolioProject1..NashvilleHousing


ALTER TABLE PortfolioProject1..NashvilleHousing
Add OwnerSpiltAddress Nvarchar(255);

Update PortfolioProject1..NashvilleHousing
SET OwnerSpiltAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)


ALTER TABLE PortfolioProject1..NashvilleHousing
Add OwnerSpiltCity Nvarchar(255);

Update PortfolioProject1..NashvilleHousing
SET OwnerSpiltCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)



ALTER TABLE PortfolioProject1..NashvilleHousing
Add OwnerSpiltState Nvarchar(255);

Update PortfolioProject1..NashvilleHousing
SET OwnerSpiltState = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)


SELECT *
FROM PortfolioProject1..NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), count(SoldAsVacant)
FROM PortfolioProject1..NashvilleHousing
Group by SoldAsVacant
Order by 2




SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject1..NashvilleHousing

UPDATE PortfolioProject1..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END





-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
    ROW_NUMBER() OVER (
	PARTITION By ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
				  UniqueID
				  ) row_num

FROM PortfolioProject1..NashvilleHousing
--order by ParcelID
)
SELECT *
FROM RowNumCTE
where row_num > 1
--order by PropertyAddress


SELECT *
FROM PortfolioProject1..NashvilleHousing 

-- Delete Unused Columns

SELECT *
FROM PortfolioProject1..NashvilleHousing

ALTER TABLE PortfolioProject1..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject1..NashvilleHousing
DROP COLUMN SaleDate
