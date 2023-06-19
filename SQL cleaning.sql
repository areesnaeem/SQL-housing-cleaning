SELECT * FROM nashville;

-- Data cleaning project

-- 1st need to rename column name as it changed while importing data into mysql. 

alter table nashville rename column ï»¿UniqueID to UniqueID;

/* Changing saledate column to date only format

select saledate, convert(saledate, date)
from nashville;

SELECT saledate, STR_TO_DATE(saledate, '%m/%d/%Y')
FROM nashville;
SELECT saledate, STR_TO_DATE(DATE_FORMAT(saledate, '%m/%d/%Y'), '%m/%d/%Y')
FROM nashville;

SELECT saledate, DATE(saledate)
FROM nashville;

SELECT saledate, 
FROM nashville;
*/

-- Finding null values in propertyaddress and filling them

-- self joining the table

select *
from nashville
where PropertyAddress = '';

select a.ParcelID,a.PropertyAddress, b.ParcelID,b.PropertyAddress
from nashville a
join nashville b
	on a.ParcelID= b.ParcelID
	and a.uniqueID != b.uniqueID
where a.PropertyAddress = '';

-- updating table to remove null values

update nashville a
join nashville b
	on a.ParcelID= b.ParcelID
	and a.uniqueID != b.uniqueID
set a.propertyaddress = b.propertyaddress
where a.PropertyAddress = '';

-- Again checking if any null value exists?

select a.ParcelID,a.PropertyAddress, b.ParcelID,b.PropertyAddress
from nashville a
join nashville b
	on a.ParcelID= b.ParcelID
	and a.uniqueID != b.uniqueID
where a.PropertyAddress = '';

select propertyaddress
from nashville;


SELECT 
  SUBSTRING(propertyaddress, 1, POSITION(',' IN propertyaddress) -1) AS address, -- -1 means skipping last chracter as we dont want comma at the end of address.
  SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress) +1) AS city
FROM nashville;


-- Now creating new columns to put seperate address, city into them

alter table nashville
add paddress varchar(255);

alter table nashville
add pcity varchar(255);

-- Updating record in newly formed columns based on address and city

update nashville
set paddress = SUBSTRING(propertyaddress, 1, POSITION(',' IN propertyaddress) -1);

update nashville
set pcity = SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress) +1);


select paddress, pcity
from nashville;

-- Now similar case with owneradress

select owneraddress
from nashville;

-- Now we can use TRIM and substring_index functions to seperate them
-- Nested substring function
SELECT 
    TRIM(SUBSTRING_INDEX(owneraddress, ',', 1)) AS address,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(owneraddress, ',', 2), ',', -1)) AS city,
    TRIM(SUBSTRING_INDEX(owneraddress, ',', -1)) AS state
FROM nashville;

-- and by this way we can again assign new columns to our parametres as did with propertyaddress with alter, update and set.

-- distinct count in soldasvacant

select distinct(soldasvacant)
from nashville;

-- in this we are having 4 options, yes,y,no,n. so it needs to be on same format rather than 2 seperate.


select distinct(soldasvacant), count(SoldAsVacant)
from nashville
group by SoldAsVacant;

SELECT soldasvacant,
	CASE 
		WHEN soldasvacant = 'y' THEN 'yes'
		WHEN soldasvacant = 'n' THEN 'no'
		ELSE soldasvacant
	END AS sold_as_vacant
FROM nashville;

update nashville
set soldasvacant = CASE 
		WHEN soldasvacant = 'y' THEN 'yes'
		WHEN soldasvacant = 'n' THEN 'no'
		ELSE soldasvacant
	END ;

-- Now check if it is updated 

select distinct(soldasvacant), count(SoldAsVacant)
from nashville
group by SoldAsVacant; -- Resolved

-- Dealing with duplicates

with rownum as (
select *,
row_number() over (partition by
							parcelid,
                            propertyaddress,
                            saleprice,
                            saledate,
                            legalreference
                            order by uniqueid
                            ) row_num
from nashville
-- where row_num > 1
-- order by ParcelID
)
select * 
from rownum
where row_num >2;

-- on the basis of findings, we can delete duplicates with cte as repalcing select * with delete from.

-- Deleting unused columns


select *
from nashville;

/*
ALTER TABLE nashville
DROP COLUMN propertyaddress taxdistrict;
*/ -- This code didntwork in mysql

ALTER TABLE nashville
DROP COLUMN propertyaddress,
DROP COLUMN taxdistrict;

-- Make sure to drop columns at the end as we may need to work on differnt columns to extract data e.g as we seperated address into city,state etc
































