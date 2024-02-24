
select SaleDate
from NashvilleHousing;

ALTER TABLE NashvilleHousing
alter column SaleDate Date;
-------------------------------------
/* Populate property Address */

Select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID

------------------------

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	--------------------------------------------------------------------

/* Breaking out PropertyAddress into individula columns */

select PropertyAddress
from NashvilleHousing

alter table NashvilleHousing
add 
PropertySplitAddress Nvarchar(255),
PropertySplitCity Nvarchar(255)

update NashvilleHousing
set 
PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) ,
PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

select PropertyAddress, PropertySplitAddress, PropertySplitCity
from NashvilleHousing

/* Breaking out OwnerAddress into individula columns */

select OwnerAddress
from NashvilleHousing

alter table NashvilleHousing
add 
OwnerSplitAddress nvarchar(255),
OwnerSplitCity nvarchar(255),
OwnerSplitState nvarchar(255)

update NashvilleHousing
Set 
OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3),
OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2),
OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select OwnerAddress, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
from NashvilleHousing

/* change Y and N to Yes and No in "Sold as vacant" field */

select distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2 


Update NashvilleHousing
Set SoldAsVacant = 
	case 
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	End 

/* Remove duplicates */

with RowNumberCte as (
select *, 
	ROW_NUMBER() over (
	partition by 
	ParcelID,  
	propertyAddress,
	SaleDate,
	SalePrice,
	LegalReference
	order by UniqueID
	) row_num
	from NashvilleHousing 
	)
	
	/*
	delete 
	from RowNumberCte
	where row_num > 1
	*/

	select *
	from RowNumberCte
	where row_num > 1
	order by PropertyAddress

	/* Delete unused columns */

	select *
	from NashvilleHousing


