# ETL program for etl service
import pyodbc
from db_connection import connect_to_database


#import queries for ETL retrieval
from queries import FETCH_PRODUCT_DATA
from queries import FETCH_SERIALNUMBERRANGE_DATA
from queries import FETCH_SERIALNUMBERHISTORY_DATA
from queries import FETCH_SUPPLIER
from queries import FETCH_OEM
from queries import FETCH_COMPONENT
from queries import FETCH_BATCH
from queries import FETCH_BATCH_SUPPLIER_RELATION

def etl_process():
    #DB connections properties
    server = 'localhost\SQLEXPRESS'  # SQL Server name
    db_source = 'CoreSystems'  # complex database representing core systems ERP, EWM..
    db_target = 'Target' # simplified database representing Datawarehouse on Product level
    username = 'PoCUser'  #  universial username
    password = 'AccessMalinasPoC'  # universial password
    
    # Connect to the source database (CoreSystems)
    source_conn = connect_to_database(server, db_source, username, password)
    if not source_conn:
        print('NO CONNECTION TO CORESYSTEMS DB ESTANBLISHED')
        return
    
    try:
        # Extract data from the source tables
        source_cursor = source_conn.cursor()
        #product info
        source_cursor.execute(FETCH_PRODUCT_DATA)
        product = source_cursor.fetchall()
        #Serialnumberrange
        source_cursor.execute(FETCH_SERIALNUMBERRANGE_DATA)
        productserialization = source_cursor.fetchall()
        #Serialnumberhistory for events
        source_cursor.execute(FETCH_SERIALNUMBERHISTORY_DATA)
        events = source_cursor.fetchall()
        #OEM data
        source_cursor.execute(FETCH_OEM)
        oem = source_cursor.fetchall()
        #Supplier data
        source_cursor.execute(FETCH_SUPPLIER)
        supplier = source_cursor.fetchall()
        #Batch data
        source_cursor.execute(FETCH_BATCH)
        batch = source_cursor.fetchall()
        #Batch SUpplier relation data
        source_cursor.execute(FETCH_BATCH_SUPPLIER_RELATION)
        batch_supplier = source_cursor.fetchall()        
        #Component data
        source_cursor.execute(FETCH_COMPONENT)
        component = source_cursor.fetchall()
        
        # Transform and load data into the target tables
        #test output from CoreSystems database
        #test_output(product, productserialization, events, oem, supplier, batch, component)
        
        # Connect to the target database (Target)
        target_conn = connect_to_database(server, db_target, username, password)
        if not target_conn:
            print('NO CONNECTION TO TARGET DB ESTANBLISHED')
            return
        
        target_cursor = target_conn.cursor()
        #write data into ProductSerialization
        for serial_number_range in productserialization:
            sql = 'INSERT INTO ProductSerialization (SerializationID, RangeStart, RangeEnd, Assemblytime) VALUES (?, ?, ?, ?)'
            values = (serial_number_range[0], serial_number_range[1], serial_number_range[2], serial_number_range[3])
            target_cursor.execute(sql, values)
        
        #write data into OEM
        for oem_item in oem:
             sql = 'INSERT INTO OEM (OEMID, Name, Address, ContactInfo) VALUES (?,?,?,?)'
             values = (oem_item[0], oem_item[1], oem_item[2], oem_item[3])
             target_cursor.execute(sql, values)  
        
        #write data into Product    
        for product_item in product:
            sql = 'INSERT INTO Product (SerialNumber, ProductName, RevisionLevel, ProductType, ProductSerializationID, OEMID) VALUES (?,?,?,?,?,?)'
            values = (product_item[0], product_item[1], product_item[2], product_item[3], product_item[4], product_item[5])
            target_cursor.execute(sql, values)
            
        #write data into Supplier
        for supplier_item in supplier:
            sql = 'INSERT INTO Supplier (SupplierID, Name, Address, ContactInfo) VALUES (?,?,?,?)'
            values = (supplier_item[0], supplier_item[1], supplier_item[2], supplier_item[3])
            target_cursor.execute(sql, values)
        
        #write data into batch
        for batch_item in batch:
            sql = 'INSERT INTO Batch (BatchID, ProductionBatchID, SupplierBatchID, MaterialOrigin, MaterialQuantity, RevisionLevel, ProductionDate, SupplierOrderDate, ExpectedDeliveryDate) VALUES (?,?,?,?,?,?,?,?,?)'
            values = (batch_item[0], batch_item[1], batch_item[2], batch_item[3],  batch_item[4],  batch_item[5],  batch_item[6],  batch_item[7],  batch_item[8])
            target_cursor.execute(sql, values)
        
         #write data into relation item for Supplier and Batch
        for relation_item in batch_supplier:
            sql = 'INSERT INTO BatchSupplierRelation (BatchID, SupplierID) VALUES (?,?)'
            values = (relation_item[0], relation_item[1])
            target_cursor.execute(sql, values)

        #write data into Component
        for component_item in component:
            sql = 'INSERT INTO Component (ComponentID, SourceMaterialNumber, Name, Description, MaterialWeight, AggregatedMaterialWeight, BatchID, ParentComponentID, SerialNumber) VALUES (?,?,?,?,?,?,?,?,?)'
            values = (component_item[0], component_item[1], component_item[2], component_item[3],  component_item[4],  component_item[5],  component_item[6],  component_item[7], component_item[8])
            target_cursor.execute(sql, values)

        #write data into LifecycleEvent
        for events_item in events:
            sql = 'INSERT INTO LifecycleEvent (EventID, SourceEventID, ProductSerialNumber, EventType, Timestamp, Description, EventDescription) VALUES (?,?,?,?,?,?,?)'
            values = (events_item[0], events_item[1], events_item[2], events_item[3],  events_item[4],  events_item[5],  events_item[6])
            target_cursor.execute(sql, values)

        target_conn.commit()
        print("Data loaded successfully into the target tables!")

     #Error handling   
    except pyodbc.Error as e:
        target_conn.rollback()
        print(f"Error during ETL process: {e}")
    finally:
        source_conn.close()
        target_conn.close()

# Run the ETL process
#etl_process()

#method to test output from Coresystems database
def test_output(product, productserialization, events, oem, supplier, batch, component):
        for row in product:
           print(row)
        for row in productserialization:
            print(row) 
        for row in events:
           print(row)
        for row in oem:
           print(row) 
        for row in supplier:
          print(row)               
        for row in batch:
           print(row)       
        for row in component:
           print(row) 