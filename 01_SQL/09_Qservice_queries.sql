--Queries for Quality Service: 

--CASE 1: Enter Product Serialnumber
--1 Fetch BAtch & Component Info
SELECT
    C.ComponentID,
    C.SourceMaterialNumber AS Materialnumber,
    C.Name AS ComponentName,
    B.BatchID,
    B.ProductionBatchID,
    B.SupplierBatchID,
    B.RevisionLevel AS BatchRevisionLevel,
    B.ProductionDate AS DateProduced,
    B.ExpectedDeliveryDate AS  DateDelivered
FROM
    Component C
LEFT JOIN
    Batch B ON C.BatchID = B.BatchID
WHERE
    C.SerialNumber = 44551;

--2 Fetch Serialnumber range
SELECT
    PS.SerializationID,
    PS.RangeStart,
    PS.RangeEnd,
    PS.Assemblytime AS CreatedOn
FROM
    ProductSerialization PS
WHERE
    PS.SerializationID = (
        SELECT ProductSerializationID
        FROM Product
        WHERE SerialNumber = 44551
    );

--2 Fetch Serialnumber range and related products
SELECT
    PS.SerializationID,
    PS.RangeStart,
    PS.RangeEnd,
    PS.Assemblytime AS CreatedOn
FROM
    ProductSerialization PS
WHERE
    PS.SerializationID = (
        SELECT ProductSerializationID
        FROM Product
        WHERE SerialNumber = 44551
    );

--3.  Fetch all products related to the same ProductSerialization
SELECT
    P.SerialNumber,
    P.ProductName,
    P.RevisionLevel,
    P.ProductType,
    P.ProductSerializationID,
    P.OEMID
FROM
    Product P
WHERE
    P.ProductSerializationID = (
        SELECT ProductSerializationID
        FROM Product
        WHERE SerialNumber = 44551
    );

--CASE 2: Enter SupplierOrder ID
-- Fetch 

-- Fetch ProductSerialization information using SupplierOrderID from Batch
-- Fetch BatchID values that match the entered SupplierBatchID
SELECT DISTINCT
    B.BatchID
FROM
    Batch B
WHERE
    B.SupplierBatchID = 1;

-- Fetch Product information using the retrieved BatchID values
--Returns all proucts associated with a supplier batch
SELECT DISTINCT
    P.SerialNumber,
    P.ProductName,
    P.RevisionLevel,
    P.ProductType,
    P.ProductSerializationID,
    P.OEMID
FROM
    Product P
INNER JOIN
    Component C ON P.SerialNumber = C.SerialNumber
WHERE
    C.BatchID IN (
        SELECT BatchID
        FROM Batch
        WHERE SupplierBatchID = 1
    );

-- Fetch information associated with a given SupplierBatchID

SELECT DISTINCT
    C.ComponentID,
    C.SourceMaterialNumber,
    C.Name AS ComponentName,
    C.Description AS ComponentDescription,
    C.MaterialWeight AS ComponentMaterialWeight,
    C.AggregatedMaterialWeight AS ComponentAggregatedMaterialWeight
FROM
    Component C
WHERE
    C.BatchID IN (
        SELECT BatchID
        FROM Batch
        WHERE SupplierBatchID = 1
    );

--Same for ProductionBatchID
-- Fetch product information associated with a given ProductionBatchID
SELECT DISTINCT
    P.SerialNumber,
    P.ProductName,
    P.RevisionLevel,
    P.ProductType,
    P.ProductSerializationID,
    P.OEMID
FROM
    Product P
INNER JOIN
    Component C ON P.SerialNumber = C.SerialNumber
INNER JOIN
    Batch B ON C.BatchID = B.BatchID
WHERE
    B.ProductionBatchID = 1;

-- Fetch component information associated with a given ProductionBatchID
SELECT DISTINCT
    C.ComponentID,
    C.SourceMaterialNumber,
    C.Name AS ComponentName,
    C.Description AS ComponentDescription,
    C.MaterialWeight AS ComponentMaterialWeight,
    C.AggregatedMaterialWeight AS ComponentAggregatedMaterialWeight
FROM
    Component C
INNER JOIN
    Batch B ON C.BatchID = B.BatchID
WHERE
    B.ProductionBatchID = 1;

	Select * from Component;
	Select * from Batch;


--Fetch component info based on Materialnumber
-- Retrieve all components associated with a given SourceMaterialNumber
SELECT
    C.ComponentID,
    C.SourceMaterialNumber,
    C.Name AS ComponentName,
    C.Description AS ComponentDescription,
    C.MaterialWeight AS ComponentMaterialWeight,
    C.AggregatedMaterialWeight AS ComponentAggregatedMaterialWeight,
    C.BatchID,
    C.ParentComponentID,
    C.SerialNumber AS ComponentSerialNumber
FROM
    Component C
WHERE
    C.SourceMaterialNumber = 1234;

-- Find all products associated with components having a given SourceMaterialNumber
SELECT DISTINCT
    P.SerialNumber,
    P.ProductName,
    P.RevisionLevel,
    P.ProductType,
    P.ProductSerializationID,
    P.OEMID
FROM
    Product P
INNER JOIN
    Component C ON P.SerialNumber = C.SerialNumber
WHERE
    C.SourceMaterialNumber = 1234;
