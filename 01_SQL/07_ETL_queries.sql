--This information needs to go into Product
Select * from Product;
Select * from AssemblyOrder;
Select * from SerialNumberRange;

--query to retrieve all product info: 
SELECT 
    Product.SerialNumber,
    Product.ProductName,
    AssemblyOrder.RevisionLevel,
    Product.ProductType,
    SerialNumberRange.RangeID AS ProductSerializationID,
	OEM.OEMID
FROM 
Product
INNER JOIN
    SerialNumberRange ON Product.RangeID = SerialNumberRange.RangeID
INNER JOIN
    AssemblyOrder ON SerialNumberRange.RangeID = AssemblyOrder.RangeID
JOIN OEM ON Product.OEMID = OEM.OEMID;


--this information needs to go into ProductSerialization
Select * from SerialNumberRange;
--query as is ok

--this information needs to go into LifecycleEvent
Select * from SerialNumberHistory;
Select * from Event;
--Query to join information together:
Select 
     SerialNumberHistory.HistoryID,
	 Event.EventID,
	 SerialNumberHistory.SerialNumber, 
	 Event.EventType, 
	 SerialNumberHistory.Timestamp,
	 SerialNumberHistory.Description,
	 Event.Description
from 
SerialNumberHistory
JOIN Event ON SerialNumberHistory.EventID = Event.EventID;

--this information nneeds to go into OEM as is
Select * from OEM;

--this information needs to go into Supplier as is
Select * from Supplier;

--this information needs to go into component but serialized with batches
Select * from BillOfMaterials;

--query to populate the components based on BillsofMaterials, Batch, HandlingUnit, Assemblyorder, Serialnumberange and Product

Select 
     ROW_NUMBER() OVER (ORDER BY BillOfMaterials.MaterialNumber) AS ComponentID,--create random component id
	 BillOfMaterials.MaterialNumber, 
	 BillOfMaterials.Name,
	 BillOfMaterials.Description,  
	 BillOfMaterials.MaterialWeight,
	 BillOfMaterials.AggregatedWeight,
	 Batch.BatchID, 
	 BillOfMaterials.ParentMaterialNumber

from BillOfMaterials

LEFT JOIN Batch on BillOfMaterials.MaterialNumber = Batch.MaterialNumber

LEFT JOIN HandlingUnit ON Batch.BatchID  = HandlingUnit.BatchID

LEFT JOIN AssemblyOrder ON HandlingUnit.AssemblyOrderID = AssemblyOrder.AssemblyOrderID

LEFT JOIN SerialNumberRange ON AssemblyOrder.RangeID = SerialNumberRange.RangeID

LEFT JOIN Product ON SerialNumberRange.RangeID = Product.RangeID

WHERE BillOfMaterials.ParentMaterialNumber IS NOT NULL;

;

--this information needs to go into Batches
Select * from Batch;
Select * from HandlingUnit;

--Query for Batch: 
SELECT 
     Batch.BatchID,
	 Batch.ProductionOrderID,
	 Batch.SupplierOrderID,
	 Batch.MaterialOrigin,
	 Batch.Quantity, 
	 Batch.RevisionLevel,
	 Batch.ProductionDate,
	 SupplierOrder.OrderDate,
	 SupplierOrder.ExpectedDeliveryDate,  
	 Batch.BatchChildReference,  
	 SupplierOrder.SupplierID
FROM Batch 
LEFT JOIN SupplierOrder ON Batch.SupplierOrderID = SupplierOrder.SupplierOrderID;

--fetch SupplierBatchRelation
SELECT 
    Batch.BatchID,
    SupplierOrder.SupplierID
FROM Batch 
LEFT JOIN SupplierOrder ON Batch.SupplierOrderID = SupplierOrder.SupplierOrderID
WHERE SupplierOrder.SupplierID IS NOT NULL;




WITH RecursiveMaterials AS (
    SELECT 
        b.MaterialNumber, 
        b.ParentMaterialNumber,
        b.MaterialNumber AS RootMaterialNumber -- Root material is itself for top level items
    FROM 
        BillOfMaterials b
    WHERE 
        b.ParentMaterialNumber IS NULL

    UNION ALL

    -- For child materials, carry forward the RootMaterialNumber from their parent
    SELECT 
        b.MaterialNumber, 
        b.ParentMaterialNumber,
        rm.RootMaterialNumber
    FROM 
        BillOfMaterials b
    INNER JOIN 
        RecursiveMaterials rm ON b.ParentMaterialNumber = rm.MaterialNumber
)

SELECT 
    ROW_NUMBER() OVER (ORDER BY rm.MaterialNumber) AS ComponentID,
    rm.MaterialNumber, 
    b.Name,
    b.Description,  
    b.MaterialWeight,
    b.AggregatedWeight,
    bt.BatchID, 
    b.ParentMaterialNumber,
    -- Fetch the SerialNumber for each material
    CASE 
        WHEN b.ParentMaterialNumber IS NULL THEN 
            (SELECT MIN(p.SerialNumber) FROM Product p WHERE p.BomMaterialNumber = b.MaterialNumber)
        ELSE 
            (SELECT MIN(p.SerialNumber) FROM Product p WHERE p.BomMaterialNumber = rm.RootMaterialNumber)
    END AS SerialNumber
FROM 
    RecursiveMaterials rm
JOIN 
    BillOfMaterials b ON rm.MaterialNumber = b.MaterialNumber
LEFT JOIN 
    Batch bt ON b.MaterialNumber = bt.MaterialNumber
WHERE 
    b.ParentMaterialNumber IS NOT NULL; -- Exclude topmost BillOfMaterials nodes



WITH RecursiveMaterials AS (
    SELECT 
        b.MaterialNumber, 
        b.ParentMaterialNumber,
        b.MaterialNumber AS RootMaterialNumber -- Root material is itself for top level items
    FROM 
        BillOfMaterials b
    WHERE 
        b.ParentMaterialNumber IS NULL

    UNION ALL

    -- For child materials, carry forward the RootMaterialNumber from their parent
    SELECT 
        b.MaterialNumber, 
        b.ParentMaterialNumber,
        rm.RootMaterialNumber
    FROM 
        BillOfMaterials b
    INNER JOIN 
        RecursiveMaterials rm ON b.ParentMaterialNumber = rm.MaterialNumber
)

SELECT 
    ROW_NUMBER() OVER (ORDER BY rm.MaterialNumber) AS ComponentID,
    rm.MaterialNumber, 
    b.Name,
    b.Description,  
    b.MaterialWeight,
    b.AggregatedWeight,
    bt.BatchID, 
    b.ParentMaterialNumber,
    -- Fetch the SerialNumber for each material
    CASE 
        WHEN b.ParentMaterialNumber IS NULL THEN 
            (SELECT MIN(p.SerialNumber) FROM Product p WHERE p.BomMaterialNumber = b.MaterialNumber)
        ELSE 
            (SELECT MIN(p.SerialNumber) FROM Product p WHERE p.BomMaterialNumber = rm.RootMaterialNumber)
    END AS SerialNumber
FROM 
    RecursiveMaterials rm
JOIN 
    BillOfMaterials b ON rm.MaterialNumber = b.MaterialNumber
LEFT JOIN 
    Batch bt ON b.MaterialNumber = bt.MaterialNumber
WHERE 
    b.ParentMaterialNumber IS NOT NULL; -- Exclude topmost BillOfMaterials nodes




	--query for the created view: 
	SELECT * 
FROM IndividualizedBillOfMaterialsView
WHERE ParentMaterialNumber IS NOT NULL 
  AND SerialNumber IS NOT NULL;


