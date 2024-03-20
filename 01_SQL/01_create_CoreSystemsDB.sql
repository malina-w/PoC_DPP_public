-- Use your database (replace 'YourDatabase' with your actual database name)
USE CoreSystems;
GO

-- Create Event Table
CREATE TABLE Event (
    EventID INT PRIMARY KEY,
    EventType VARCHAR(50),
    Description VARCHAR(255)
);
GO

-- Create Supplier Table
CREATE TABLE Supplier (
    SupplierID INT PRIMARY KEY,
    Name VARCHAR(255),
    Address VARCHAR(255),
    ContactInfo VARCHAR(255)
);
GO

-- Create OEM Table
CREATE TABLE OEM (
    OEMID INT PRIMARY KEY,
    Name VARCHAR(255),
    Address VARCHAR(255),
    ContactInfo VARCHAR(255)
);
GO

-- Create SerialNumberRange Table
CREATE TABLE SerialNumberRange (
    RangeID INT PRIMARY KEY,
    StartSerialNumber VARCHAR(50),
    EndSerialNumber VARCHAR(50),
    CreatedOn DATETIME2 DEFAULT GETDATE()
);
GO


-- Redesign BillOfMaterials Table to be self-contained with hierarchical support
CREATE TABLE BillOfMaterials (
    MaterialNumber INT PRIMARY KEY,
    ParentMaterialNumber INT NULL,
    Name VARCHAR(255) NOT NULL,
    Type VARCHAR(50) NOT NULL,
    Description VARCHAR(255) NOT NULL,
    Quantity INT NOT NULL,
    MaterialWeight DECIMAL(10,2) NOT NULL,
    AggregatedWeight DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (ParentMaterialNumber) REFERENCES BillOfMaterials(MaterialNumber),
    CHECK (ParentMaterialNumber IS NULL OR ParentMaterialNumber != MaterialNumber)
);
GO

-- Create Product Table
CREATE TABLE Product (
    SerialNumber INT PRIMARY KEY,
    ProductName VARCHAR(255),
    ProductType VARCHAR(50),
	BomMaterialNumber INT,
    RangeID INT,
    OEMID INT,
	FOREIGN KEY (BomMaterialNumber) REFERENCES BillOfMaterials(MaterialNumber),
    FOREIGN KEY (RangeID) REFERENCES SerialNumberRange(RangeID),
    FOREIGN KEY (OEMID) REFERENCES OEM(OEMID)
);
GO

-- Create AssemblyOrder Table
CREATE TABLE AssemblyOrder (
    AssemblyOrderID INT PRIMARY KEY,
    RangeID INT,
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (RangeID) REFERENCES SerialNumberRange(RangeID)
);
GO

-- Create ProductionOrder Table
CREATE TABLE ProductionOrder (
    ProductionOrderID INT PRIMARY KEY,
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(50)
);
GO

-- Create SupplierOrder Table
CREATE TABLE SupplierOrder (
    SupplierOrderID INT PRIMARY KEY,
    SupplierID INT,
    OrderDate DATE,
    ExpectedDeliveryDate DATE,
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);
GO

-- Create Batch Table with a link to BillOfMaterials
CREATE TABLE Batch (
    BatchID INT PRIMARY KEY,
    SupplierOrderID INT, -- Links to SupplierOrder
    ProductionOrderID INT, -- Links to ProductionOrder
    MaterialNumber INT, -- Links to BillOfMaterials
    Quantity INT,
    ProductionDate DATE,
    ExpiryDate DATE,
    MaterialOrigin VARCHAR(255),
    FOREIGN KEY (SupplierOrderID) REFERENCES SupplierOrder(SupplierOrderID),
    FOREIGN KEY (ProductionOrderID) REFERENCES ProductionOrder(ProductionOrderID),
    FOREIGN KEY (MaterialNumber) REFERENCES BillOfMaterials(MaterialNumber) -- Ensures the material/component exists
);
GO

ALTER TABLE Batch
ADD BatchChildReference INT NULL
FOREIGN KEY (BatchChildReference) REFERENCES Batch(BatchID); -- self referencing batch
GO

-- Create HandlingUnit Table
CREATE TABLE HandlingUnit (
    HandlingUnitID INT PRIMARY KEY,
    BatchID INT,
    AssemblyOrderID INT,
    FOREIGN KEY (BatchID) REFERENCES Batch(BatchID),
    FOREIGN KEY (AssemblyOrderID) REFERENCES AssemblyOrder(AssemblyOrderID)
);
GO

-- Create SerialNumberHistory Table
CREATE TABLE SerialNumberHistory (
    HistoryID INT PRIMARY KEY,
    SerialNumber INT,
    EventID INT,
    Timestamp DATETIME,
    Description VARCHAR(255),
    FOREIGN KEY (SerialNumber) REFERENCES Product(SerialNumber),
    FOREIGN KEY (EventID) REFERENCES Event(EventID)
);
GO

-- Stored Procedure to recursively update aggregated weights
CREATE PROCEDURE UpdateAggregatedWeights
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare a table variable to store intermediate results
    DECLARE @AggregatedWeights TABLE (
        MaterialNumber INT,
        TotalWeight DECIMAL(10,2)
    );

    -- Insert leaf nodes weights into the table variable
    INSERT INTO @AggregatedWeights (MaterialNumber, TotalWeight)
    SELECT 
        MaterialNumber, 
        MaterialWeight * Quantity
    FROM 
        BillOfMaterials
    WHERE 
        MaterialNumber NOT IN (SELECT ParentMaterialNumber FROM BillOfMaterials WHERE ParentMaterialNumber IS NOT NULL);

    -- Recursively update parent nodes
    WHILE @@ROWCOUNT > 0
    BEGIN
        INSERT INTO @AggregatedWeights (MaterialNumber, TotalWeight)
        SELECT 
            b.ParentMaterialNumber,
            SUM(a.TotalWeight)
        FROM 
            BillOfMaterials b
        INNER JOIN 
            @AggregatedWeights a ON b.MaterialNumber = a.MaterialNumber
        WHERE 
            b.ParentMaterialNumber IS NOT NULL
        GROUP BY 
            b.ParentMaterialNumber
        EXCEPT 
        SELECT 
            MaterialNumber, 
            TotalWeight 
        FROM 
            @AggregatedWeights;
    END

    -- Update the BillOfMaterials table with the calculated weights
    UPDATE b
    SET b.AggregatedWeight = a.TotalWeight
    FROM 
        BillOfMaterials b
    INNER JOIN 
        @AggregatedWeights a ON b.MaterialNumber = a.MaterialNumber;
END;
GO

-- Create the trigger to automatically update the aggregated weights after any change in BillOfMaterials
CREATE TRIGGER trg_BillOfMaterials_AfterChange
ON BillOfMaterials
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    EXEC UpdateAggregatedWeights;
END;
GO

