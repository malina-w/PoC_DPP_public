# queries.py
# for etl service
# Contains queries to fetch data from Coresystems database

FETCH_PRODUCT_DATA = '''--query to retrieve all product info: 
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
'''

FETCH_SERIALNUMBERRANGE_DATA = '''Select * from SerialNumberRange;'''

FETCH_SERIALNUMBERHISTORY_DATA = '''Select 
     SerialNumberHistory.HistoryID,
	 Event.EventID,
	 SerialNumberHistory.SerialNumber, 
	 Event.EventType, 
	 SerialNumberHistory.Timestamp,
	 SerialNumberHistory.Description,
	 Event.Description
from 
SerialNumberHistory
JOIN Event ON SerialNumberHistory.EventID = Event.EventID;'''

FETCH_OEM = '''Select * from OEM;'''

FETCH_SUPPLIER = '''Select * from Supplier;'''

FETCH_COMPONENT = '''SELECT * 
FROM IndividualizedBillOfMaterialsView
WHERE ParentMaterialNumber IS NOT NULL 
  AND SerialNumber IS NOT NULL;'''


FETCH_BATCH = '''SELECT 
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
LEFT JOIN SupplierOrder ON Batch.SupplierOrderID = SupplierOrder.SupplierOrderID;'''

FETCH_BATCH_SUPPLIER_RELATION = '''SELECT 
    Batch.BatchID,
    SupplierOrder.SupplierID
FROM Batch 
LEFT JOIN SupplierOrder ON Batch.SupplierOrderID = SupplierOrder.SupplierOrderID
WHERE SupplierOrder.SupplierID IS NOT NULL;'''


