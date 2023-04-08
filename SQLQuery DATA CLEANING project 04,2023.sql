--BELOW WE ARE GOING TO PERFORM DATA CLEANING USING THE NASHVILLE HOUSING DATE 

SELECT*
  FROM Portifolio_project..NashvilleHousingdata


  SELECT a.ParcelID, b.PropertyAddress, b.ParcelID, a.PropertyAddress, ISNULL( a.PropertyAddress, b.PropertyAddress)   
   FROM Portifolio_project..NashvilleHousingData a
   JOIN Portifolio_project..NashvilleHousingData b
   ON a.ParcelID = b.ParcelID  AND a.[uniqueid]<> b.[uniqueid]
   WHERE a.PropertyAddress is null


   UPDATE a
   SET propertyAddress = ISNULL( a.PropertyAddress, b.PropertyAddress)   
   FROM Portifolio_project..NashvilleHousingData a
   JOIN Portifolio_project..NashvilleHousingData b
   ON a.ParcelID = b.ParcelID  AND a.[uniqueid]<> b.[uniqueid]
   WHERE a.PropertyAddress is null

   --WE SHALL HAVE TO POPULATE THE TABLE UISNG INNER JOINS

   --SPLITING ADRESS INTO IDIBIDUAL COLUMNS (ADRESS, CITY, STATE)
   SELECT PropertyAddress 
  
   FROM Portifolio_project..NashvilleHousingData

   SELECT 
    SUBSTRING (PropertyAddress, 1, CHARINDEX (',', propertyaddress)-1)as address
	, SUBSTRING (Propertyaddress, CHARINDEX (',', propertyaddress) +1, LEN(propertyaddress) )as address
 
   from Portifolio_project..NashvilleHousingData

ALTER TABLE Portifolio_project..NashvilleHousingData
ADD propertysplitaddress Nvarchar(255);

update Portifolio_project..NashvilleHousingData 
set PropertysplitAddress =  SUBSTRING (PropertyAddress, 1, CHARINDEX (',', propertyaddress)-1)

ALTER TABLE Portifolio_project..NashvilleHousingData
ADD propertysplitcity Nvarchar(255);

update Portifolio_project..NashvilleHousingData 
set Propertysplitcity = SUBSTRING (Propertyaddress, CHARINDEX (',', propertyaddress) +1, LEN(propertyaddress) )

SELECT*
  FROM Portifolio_project..NashvilleHousingData

   --ALTERNATIVELY WE CAN USE THE PERSENAME FUNCTION 

   SELECT
   PARSENAME (REPLACE(Owneraddress, ',', '.'),3)
   ,PARSENAME(REPLACE(Owneraddress, ',', '.'), 2)
   ,PARSENAME(REPLACE (Owneraddress, ',', '.'), 1)
   FROM Portifolio_project..NashvilleHousingData 
 

 ALTER TABLE Portifolio_project..NashvilleHousingData
 ADD ownersplitAdress Nvarchar(255);

 UPDATE Portifolio_project..NashvilleHousingData
 SET ownersplitAdress = PARSENAME (REPLACE(Owneraddress, ',', '.'),3)

  ALTER TABLE Portifolio_project..NashvilleHousingData
 ADD ownersplitcity Nvarchar(255);

  UPDATE Portifolio_project..NashvilleHousingData
 SET ownersplitcity = PARSENAME(REPLACE(Owneraddress, ',', '.'), 2)

 ALTER TABLE Portifolio_project..NashvilleHousingData
 ADD ownersplitstate Nvarchar(255);
   
   UPDATE Portifolio_project..NashvilleHousingData
 SET ownersplitstate = PARSENAME(REPLACE (Owneraddress, ',', '.'), 1)


 SELECT*
  FROM Portifolio_project..NashvilleHousingdata

  --CHANGE Y AND N TO YYES AND NO IN SOLDASVACANT FIELD

  SELECT DISTINCT (soldasvacant), COUNT( SoldAsVacant )
  FROM Portifolio_project..NashvilleHousingdata
  GROUP BY SoldAsVacant 
  ORDER BY 2

  SELECT SoldAsVacant 
  , CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' 
		WHEN SoldAsVacant = 'N'  THEN 'NO'
		ELSE SoldAsVacant 
		END
  FROM Portifolio_project..NashvilleHousingData 


  UPDATE Portifolio_project..NashvilleHousingData 
  SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' 
		WHEN SoldAsVacant = 'N'  THEN 'NO'
		ELSE SoldAsVacant 
		END

		SELECT SoldAsVacant 
		  FROM Portifolio_project..NashvilleHousingData 

--REMOVE DUPLICATES

WITH [Row_numCTE] AS (
SELECT *, 
			ROW_NUMBER () OVER (PARTITION BY parcelID,
			propertyaddress,
			saleprice,
			saledate,
			legalreference
			ORDER BY
			UniqueID) as  row_num

			  FROM Portifolio_project..NashvilleHousingData )
			  SELECT * 
			  FROM Row_NUMCTE
			  WHERE row_num > 1


--DELETING UNUSED COLUMNS though deleting is not advised before your authorised by your seniors to do so


SELECT *
		  FROM Portifolio_project..NashvilleHousingData 

ALTER TABLE Portifolio_project..NashvilleHousingData
DROP COLUMN owneraddress, taxdistrict, propertyaddress, saledate