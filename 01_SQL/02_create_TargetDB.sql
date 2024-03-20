--Simplified database schema:

-- Create Supplier Table
CREATE TABLE Supplier (
    SupplierID INT PRIMARY KEY,
    Name VARCHAR(255),
    Address VARCHAR(255),
    ContactInfo VARCHAR(255)
);

-- Create OEM Table
CREATE TABLE OEM (
    OEMID INT PRIMARY KEY,
    Name VARCHAR(255),
    Address VARCHAR(255),
    ContactInfo VARCHAR(255)
);


-- Create ProductSerialization Table, equivalent to the SerialNumberRange in CoreSytstems,
-- but may contain more information in the future as well
CREATE TABLE ProductSerialization (
    SerializationID INT PRIMARY KEY,
    RangeStart VARCHAR(50),
    RangeEnd VARCHAR(50),
	Assemblytime DATETIME2 -- equivalent to CreatedOn in CoreSystems
);

-- Product Table
CREATE TABLE Product (
    SerialNumber INT PRIMARY KEY, -- equivalent to SerialNumber of Product in CoreSystems
    ProductName VARCHAR(255),
    RevisionLevel VARCHAR(10),  --from AssemblyOrder table
    ProductType VARCHAR(50),
	ProductSerializationID INT, 
    OEMID INT,
	FOREIGN KEY (ProductSerializationID) REFERENCES ProductSerialization(SerializationID),
    FOREIGN KEY (OEMID) REFERENCES OEM(OEMID)
    -- Other Product attributes
);


-- Create LifecycleEvent Table - summarizes the SerialNumberHistory of the product based on the equivalent tables in CoreSystems
CREATE TABLE LifecycleEvent (
    EventID INT PRIMARY KEY,
	SourceEventID INT, -- to reference back to the original table form CoreSystems
    ProductSerialNumber INT,
    EventType VARCHAR(50),
    Timestamp DATETIME,
    Description VARCHAR(255),
	EventDescription VARCHAR(255),
    FOREIGN KEY (ProductSerialNumber) REFERENCES Product(SerialNumber)
);


CREATE TABLE Batch ( -- summarizes all batch information from CoreSystems such as ProductionOrder and Supplier Batch
    BatchID INT PRIMARY KEY, 
	ProductionBatchID INT NULL, -- Nullable to support components without a production batch, i.e. SupplierBatches
    SupplierBatchID INT NULL, -- Nullable to support components without a supplier batch, i.e. ProductionBatches
    MaterialOrigin VARCHAR(255) NULL, -- From Batch table, nullable in case of components with subcomponents/ materials
	MaterialQuantity DECIMAL(10,2), -- depends on the original batch
	RevisionLevel NVARCHAR(50), -- euivalent to RevisionLevel of Batch in CoreSystems
    ProductionDate DATE NULL, -- From ProductionOrder, nullable in case of SupplierBatch
    SupplierOrderDate DATE NULL, -- From SupplierOrder, nullable in case of ProductionBAtch
    ExpectedDeliveryDate DATE NULL -- From SupplierOrder, nullable in case of ProductionBatch
);

CREATE TABLE BatchSupplierRelation (
    BatchID INT,
    SupplierID INT,
    FOREIGN KEY (BatchID) REFERENCES Batch(BatchID),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

-- Create Component Table (Combining BillOfMaterials, Batch, ProductionOrder, and SupplierOrder from CoreSystems)
-- the component is materialized from the CoreSystems table to support the actual representation of the product on Item level
-- the information for Component is aggregated and summrized from BoM & Batch tables from CoreSystems to represent the underlying complexity of ERP & EWM systems accurately
CREATE TABLE Component (
    ComponentID INT PRIMARY KEY,
	SourceMaterialNumber INT, --matches to original BoM number in CoreSystems
    Name VARCHAR(255),
    Description VARCHAR(255),
    MaterialWeight DECIMAL(10,2) NULL, -- Nullable to support parent nodes
	AggregatedMaterialWeight DECIMAL(10,2),
	BatchID INT,
    ParentComponentID INT, 
    SerialNumber INT,
    --FOREIGN KEY (ParentComponentID) REFERENCES Component(ComponentID), -- Hierarchical struture for components with subcomponents & materials
	FOREIGN KEY (BatchID) REFERENCES Batch(BatchID), -- direct relationship to Batch
    FOREIGN KEY (SerialNumber) REFERENCES Product(SerialNumber),
);


--check if needed?
-- ProductComponentRelationship Table
--CREATE TABLE ProductComponentRelationship (
    --ProductID INT,
   -- ComponentID INT,
   -- PRIMARY KEY (ProductID, ComponentID),
   -- FOREIGN KEY (ProductID) REFERENCES Product(Serialnumber),
--);

-- ActorProductRelationship Table
-- for the 3NF we need extra tables to resolve the relationships between ValueChainActor and Product
-- this way we can summarize all actors in one table
--CREATE TABLE ActorProductRelationship (
 --   ActorID INT,
--ProductID INT,
--    PRIMARY KEY (ActorID, ProductID),
--    FOREIGN KEY (ActorID) REFERENCES ValueChainActor(ActorID),
--    FOREIGN KEY (ProductID) REFERENCES Product(Serialnumber)
--);

-- ActorBatchRelationship Table
-- for the 3NF we need extra tables to resolve the relationships between ValueChainActor and Batch
-- this way we can summarize all actors in one table
--CREATE TABLE ActorComponentRelationship (
--    ActorID INT,
--    BatchID INT,
--    PRIMARY KEY (ActorID, BatchID),
 --   FOREIGN KEY (ActorID) REFERENCES ValueChainActor(ActorID),
--    FOREIGN KEY (BatchID) REFERENCES Batch(BatchID)
--);

