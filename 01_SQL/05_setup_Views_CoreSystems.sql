CREATE VIEW IndividualizedBillOfMaterialsView AS
WITH RecursiveMaterials AS (
    SELECT 
        MaterialNumber, 
        ParentMaterialNumber,
        CASE 
            WHEN ParentMaterialNumber IS NULL THEN MaterialNumber
            ELSE NULL
        END AS RootMaterialNumber
    FROM 
        BillOfMaterials
    WHERE 
        ParentMaterialNumber IS NULL

    UNION ALL

    SELECT 
        b.MaterialNumber, 
        b.ParentMaterialNumber,
        COALESCE(rm.RootMaterialNumber, b.MaterialNumber)
    FROM 
        BillOfMaterials b
    INNER JOIN 
        RecursiveMaterials rm ON b.ParentMaterialNumber = rm.MaterialNumber
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY rm.MaterialNumber) AS UniqueID,
    rm.MaterialNumber, 
    b.Name,
    b.Description,  
    b.MaterialWeight,
    b.AggregatedWeight,
    bt.BatchID, 
    b.ParentMaterialNumber,
    p.SerialNumber
FROM 
    RecursiveMaterials rm
JOIN 
    BillOfMaterials b ON rm.MaterialNumber = b.MaterialNumber
LEFT JOIN 
    Batch bt ON b.MaterialNumber = bt.MaterialNumber
LEFT JOIN 
    HandlingUnit hu ON bt.BatchID = hu.BatchID
LEFT JOIN 
    AssemblyOrder ao ON hu.AssemblyOrderID = ao.AssemblyOrderID
LEFT JOIN 
    SerialNumberRange snr ON ao.RangeID = snr.RangeID
LEFT JOIN 
    Product p ON snr.RangeID = p.RangeID OR p.BomMaterialNumber = rm.RootMaterialNumber;



SELECT * 
FROM IndividualizedBillOfMaterialsView
WHERE ParentMaterialNumber IS NOT NULL 
  AND SerialNumber IS NOT NULL;
