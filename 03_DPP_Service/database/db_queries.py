# queries.py

# SQL query to retrieve product information with supplier name
FETCH_PRODUCT_DATA = '''
SELECT 
    p.SerialNumber,
    p.ProductName,
    p.RevisionLevel,
    p.ProductType,
    ps.RangeStart,
    ps.RangeEnd,
    ps.Assemblytime,
    o.Name AS OEMName,
    o.Address AS OEMAddress,
    o.ContactInfo AS OEMContactInfo,
	ps.SerializationID
FROM 
    Product p
    JOIN ProductSerialization ps ON p.ProductSerializationID = ps.SerializationID
    JOIN OEM o ON p.OEMID = o.OEMID
WHERE 
    p.SerialNumber = ?
'''

FETCH_MATERIAL_DATA = '''SELECT 
    c.ComponentID,
    c.SourceMaterialNumber,
    c.Name,
    c.Description,
    c.MaterialWeight,
    c.AggregatedMaterialWeight,
    c.BatchID,
    c.ParentComponentID,
    c.SerialNumber,
    CASE 
        WHEN bs.SupplierID IS NULL THEN 'Inhouse Production at OEM 1'
        ELSE b.MaterialOrigin
    END AS MaterialOrigin,
    b.MaterialQuantity,
    b.RevisionLevel,
    COALESCE(b.ExpectedDeliveryDate, b.ProductionDate) AS DateSupplied,
    COALESCE(s.Name, o.Name) AS SupplierOrOEMName,
    COALESCE(s.Address, o.Address) AS SupplierOrOEMAddress,
    COALESCE(s.ContactInfo, o.ContactInfo) AS SupplierOrOEMContactInfo
FROM 
    Component c
    JOIN Batch b ON c.BatchID = b.BatchID
    LEFT JOIN BatchSupplierRelation bs ON b.BatchID = bs.BatchID
    LEFT JOIN Supplier s ON bs.SupplierID = s.SupplierID
    JOIN Product p ON c.SerialNumber = p.SerialNumber
    JOIN OEM o ON p.OEMID = o.OEMID
WHERE 
    c.SerialNumber = ?
'''

FETCH_EVENT_DATA = '''SELECT 
    le.EventID,
    le.SourceEventID,
    le.ProductSerialNumber,
    le.EventType,
    le.Timestamp,
    le.Description,
    le.EventDescription
FROM 
    LifecycleEvent le
WHERE 
    le.ProductSerialNumber = ?
'''




##OLD STUFF

FETCH_PRODUCT_DATA2 = '''
SELECT
    p.Serialnumber,
    p.ProductName,
    p.RevisionLevel,
    p.ModelName,
	p.ProductCreation,
    vca.ActorName AS SupplierName
FROM
    Product p
JOIN
    ActorProductRelationship apr ON p.Serialnumber = apr.ProductID
JOIN
    ValueChainActor vca ON apr.ActorID = vca.ActorID
WHERE
    p.Serialnumber = ?
'''

FETCH_MATERIAL_DATA2 = '''DECLARE @SerialNumber INT = ? ; -- Replace 'x' with the desired serial number

-- Common Table Expression (CTE) to recursively retrieve components and subcomponents
WITH RecursiveComponents AS (
    SELECT
        pcr.ComponentID,
        c.ParentComponentID,
        c.ComponentName,
        c.ProductionBatchNumber,
		c.BatchTimestamp,
        c.RevisionLevel,
        m.MaterialID,
        m.MaterialNumber,
        m.MaterialName,
        m.MaterialWeight,
        m.MaterialHazardous,
        m.MaterialOrigin
    FROM
        ProductComponentRelationship pcr
    JOIN
        Component c ON pcr.ComponentID = c.ComponentID
    LEFT JOIN
        Material m ON c.ComponentID = m.ComponentID
    WHERE
        pcr.ProductID = @SerialNumber
    
    UNION ALL
    
    SELECT
        c.ComponentID,
        c.ParentComponentID,
        c.ComponentName,
        c.ProductionBatchNumber,
		c.BatchTimestamp,
        c.RevisionLevel,
        m.MaterialID,
        m.MaterialNumber,
        m.MaterialName,
        m.MaterialWeight,
        m.MaterialHazardous,
        m.MaterialOrigin
    FROM
        Component c
    JOIN
        Material m ON c.ComponentID = m.ComponentID
    JOIN
        RecursiveComponents rc ON c.ParentComponentID = rc.ComponentID
)
-- Main query to select components and materials from the recursive CTE
SELECT
    ComponentID,
    ParentComponentID,
    ComponentName,
    ProductionBatchNumber,
	BatchTimestamp,
    RevisionLevel,
    MaterialID,
    MaterialNumber,
    MaterialName,
    MaterialWeight,
    MaterialHazardous,
    MaterialOrigin,
    -- Calculate total weight of the product
    SUM(MaterialWeight) OVER () AS TotalProductWeight
FROM
    RecursiveComponents;
'''


FETCH_EVENT_DATA2 = '''SELECT *
FROM LifecycleEvent
WHERE AssetID = ?;'''





# DB 1 Define your SQL queries here
FETCH_PRODUCT_DATA2 = '''
WITH RecursiveCTE AS (
    -- Anchor member: Fetch Materialnumbers based on Product Serialnumber
    SELECT
        P.Serialnumber,
        BM.Materialnumber,
        BM.Parent_Materialnumber,
        BM.Material_Weight
    FROM
        Product AS P
        JOIN Bills_of_Materials AS BM ON P.Bills_of_Materials_Materialnumber = BM.Materialnumber
    WHERE
        P.Serialnumber = 101

    UNION ALL

    -- Recursive member: Fetch children based on Parent_Materialnumber
    SELECT
        RC.Serialnumber,
        BM.Materialnumber,
        BM.Parent_Materialnumber,
        BM.Material_Weight
    FROM
        RecursiveCTE AS RC
        JOIN Bills_of_Materials AS BM ON RC.Materialnumber = BM.Parent_Materialnumber
)
-- Final SELECT statement to aggregate children weights based on Parent_Materialnumber
SELECT
    P.Serialnumber AS Product_Serialnumber,
    P.Name AS Product_Name,
    P.Timestamp_Creation,
    COALESCE(SUM(R.Material_Weight), 0) AS Children_Weight
FROM
    RecursiveCTE AS R
    JOIN Product AS P ON R.Serialnumber = P.Serialnumber
WHERE
    R.Parent_Materialnumber IS NOT NULL -- Exclude root nodes
GROUP BY
    P.Serialnumber, P.Name, P.Timestamp_Creation;
'''


FETCH_MATERIAL_DATA2 = '''
	WITH RecursiveCTE AS (
    SELECT
        BM.Materialnumber,
        BM.Parent_Materialnumber
    FROM
        Product AS P
        JOIN Bills_of_Materials AS BM ON P.Bills_of_Materials_Materialnumber = BM.Materialnumber
    WHERE
        P.Serialnumber = 101

    UNION ALL

    SELECT
        BM.Materialnumber,
        BM.Parent_Materialnumber
    FROM
        RecursiveCTE AS RC
        JOIN Bills_of_Materials AS BM ON RC.Materialnumber = BM.Parent_Materialnumber
)

-- Final SELECT statement to retrieve details for the children based on Materialnumbers and supplier location
SELECT
    RC.Materialnumber AS Bills_of_Materialnumber,
    BM.Material_Name,
    BM.Material_type,
    BM.Material_Weight,
    BM.Material_quantity,
    BM.Material_hazardous,
    BM.Parent_Materialnumber,
    S.Location AS Supplier_Location,
    PS.Timestamp_Completed
FROM
    RecursiveCTE AS RC
    LEFT JOIN BoM_Item AS BI ON RC.Materialnumber = BI.Bills_of_Materials_Materialnumber
    LEFT JOIN Item_Association AS IA ON BI.Item_ID = IA.Item_ID
    LEFT JOIN Bills_of_Materials AS BM ON RC.Materialnumber = BM.Materialnumber
    LEFT JOIN Supplier AS S ON IA.Supplier_ID = S.ID
    LEFT JOIN Batch AS B ON IA.Batch_ID = B.Batch_ID
    LEFT JOIN Batch_Production_Association AS BPA ON B.Batch_ID = BPA.Batch_ID
    LEFT JOIN Production_Step AS PS ON BPA.ProductionStep_ID = PS.Step_ID
WHERE
    PS.Timestamp_Completed = (SELECT Timestamp_Creation FROM Product WHERE Serialnumber = 101);'''
