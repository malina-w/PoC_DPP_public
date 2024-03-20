Select * from Product;
Select * from Component;
Select * from Batch;
Select * from Supplier;
Select * from OEM;
Select * from LifecycleEvent;
Select * from ProductSerialization;
Select * from BatchSupplierRelation;

-- Queries to create for the DPP service: 

--1 All product info together with OEM info
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
    p.SerialNumber = X; -- Replace X with the actual serial number


--2. Fetch component data
SELECT 
    c.ComponentID,
    c.SourceMaterialNumber,
    c.Name,
    c.Description,
    c.AggregatedMaterialWeight,
    c.BatchID,
    c.ParentComponentID,
    CASE 
        WHEN bs.SupplierID IS NULL THEN 'Inhouse Production at OEM 1'
        ELSE b.MaterialOrigin
    END AS MaterialOrigin,
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
    c.SerialNumber = X; -- Replace X with the actual serial number

--3. Fetch Lifecycleeventhistory
SELECT 
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
    le.ProductSerialNumber = X; -- Replace X with the actual serial number
