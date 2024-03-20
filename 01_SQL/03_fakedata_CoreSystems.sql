INSERT INTO Supplier (SupplierID, Name, Address, ContactInfo) VALUES
(1, 'Supplier 1', 'Address 1', 'Contact 1'),
(2, 'Supplier 2', 'Address 2', 'Contact 2'),
(3, 'Supplier 3', 'Address 3', 'Contact 3'),
(4, 'Supplier 4', 'Address 4', 'Contact 4'),
(5, 'Supplier 5', 'Address 5', 'Contact 5');
Select * from Supplier;

INSERT INTO OEM (OEMID, Name, Address, ContactInfo) VALUES
(1, 'OEM 1', 'OEM1  Adress', 'OEM 1 Contact');
Select * from OEM;

INSERT INTO BillOFMaterials (MaterialNumber, ParentMaterialNumber, Name, Type, Description, Quantity, MaterialWeight, AggregatedWeight) VALUES
(123, Null, 'Product A', 'Type Product A', 'BoM Product A', 1, 5.5, Null), --highest parent node for product
(456, Null, 'Product B', 'Type Product B', 'BoM Product B', 1, 5.5, Null), --highest parent node for product

(1234, 123, 'Component A', 'Type Component A', 'BoM Component A', 1, 5.5, Null), --second parent node for component of product A
(1235, 123, 'Component B', 'Type Component B', 'BoM Component B', 1, 5.6, Null), --second parent node for component of product A
(1236, 123, 'Component C', 'Type Component C', 'BoM Component C', 1, 5.7, Null), --second parent node for component of product A
(1237, 123, 'Component D', 'Type Component D', 'BoM Component D', 1, 5.8, Null), --second parent node for component of product A
(1238, 123, 'Component E', 'Type Component E', 'BoM Component E', 1, 5.9, Null), --second parent node for component of product A

(4561, 456, 'Component F', 'Type Component F', 'BoM Component F', 1, 6.5, Null), --second parent node for component of product B
(4562, 456, 'Component G', 'Type Component G', 'BoM Component G', 1, 7.5, Null), --second parent node for component of product B
(4563, 456, 'Component H', 'Type Component H', 'BoM Component H', 1, 8.5, Null), --second parent node for component of product B
(4564, 456, 'Component I', 'Type Component I', 'BoM Component I', 1, 9.5, Null), --second parent node for component of product B
(4565, 456, 'Component J', 'Type Component J', 'BoM Component J', 1, 10.5, Null), --second parent node for component of product B

(12341, 1234, 'Material A', 'Type Material A', 'BoM Material A', 1, 5.5 , Null), --lead node for component product A
(12342, 1234, 'Material B', 'Type Material B', 'BoM Material B', 1, 6.5 , Null), --lead node for component product A
(12343, 1235, 'Material C', 'Type Material C', 'BoM Material C', 1, 7.5 , Null), --lead node for component product A
(12344, 1236, 'Material D', 'Type Material D', 'BoM Material D', 1, 8.5 , Null), --lead node for component product A
(12345, 1237, 'Material E', 'Type Material E', 'BoM Material E', 1, 9.5 , Null), --lead node for component product A
(12346, 1238, 'Material F', 'Type Material F', 'BoM Material F', 1, 5.5 , Null), --lead node for component product A

(45611, 4561, 'Material K', 'Type Material K', 'BoM Material K', 1, 10.0 , Null), --lead node for component product A
(45612, 4562, 'Material L', 'Type Material L', 'BoM Material L', 1, 7.8 , Null), --lead node for component product A
(45613, 4563, 'Material M', 'Type Material M', 'BoM Material M', 1, 4.7 , Null), --lead node for component product A
(45614, 4563, 'Material N', 'Type Material N', 'BoM Material N', 1, 8.6 , Null), --lead node for component product A
(45615, 4564, 'Material O', 'Type Material O', 'BoM Material O', 1, 9.9 , Null), --lead node for component product A
(45616, 4565, 'Material P', 'Type Material P', 'BoM Material P', 1, 5.5 , Null); --lead node for component product A
Select * from BillOFMaterials;


INSERT INTO SerialNumberRange (RangeID, StartSerialNumber, EndSerialNumber, CreatedOn) VALUES
(1,00093355, 00093359, GETDATE()),
(2,00067835, 00067839, GETDATE());
Select * from SerialNumberRange;


INSERT INTO Product (SerialNumber, ProductName, ProductType, BomMaterialNumber, RangeID, OEMID) VALUES
--5 Products for Serialnumber range 1
(00093355, 'Product A', 'Product Type A', 123, 1, 1),
(00093356, 'Product A', 'Product Type A', 123, 1, 1),
(00093357, 'Product A', 'Product Type A', 123, 1, 1),
(00093358, 'Product A', 'Product Type A', 123, 1, 1),
(00093359, 'Product A', 'Product Type A', 123, 1, 1),
--5 Products for Serialnumberange 2
(00067835, 'Product B', 'Product Type B', 456, 2, 1),
(00067836, 'Product B', 'Product Type B', 456, 2, 1),
(00067837, 'Product B', 'Product Type B', 456, 2, 1),
(00067838, 'Product B', 'Product Type B', 456, 2, 1),
(00067839, 'Product B', 'Product Type B', 456, 2, 1);
Select * from Product;


INSERT INTO AssemblyOrder (AssemblyOrderID, RangeID, StartDate, EndDAte, Status) VALUES
(1, 1, GETDATE()-30, GetDate()-20, 'Assembled'),
(2, 2, GETDATE()-20, GetDate()-15, 'Assembled');
Select * from AssemblyOrder;

-- Create 12 supplier orders for raw material corresponding to thr 12 created leaf nodes in bills of materials
INSERT INTO SupplierOrder (SupplierOrderID, SupplierID, OrderDate, ExpectedDeliveryDate) VALUES
(1, 1, GETDATE()-50, GETDATE()-40), 
(2, 1, GETDATE()-40, GETDATE()-30), 
(3, 2, GETDATE()-30, GETDATE()-20), 
(4, 2, GETDATE()-20, GETDATE()-10), 
(5, 3, GETDATE()-10, GETDATE()), 
(6, 4, GETDATE()-5, GETDATE()-1), 
(7, 4, GETDATE()-50, GETDATE()-30), 
(8, 5, GETDATE()-35, GETDATE()-30), 
(9, 5, GETDATE()-5, GETDATE()), 
(10, 3, GETDATE()-1, GETDATE()), 
(11, 4, GETDATE()-10, GETDATE()-8), 
(12, 5, GETDATE()-3, GETDATE()-2); 
Select * from SupplierOrder;

-- create 10 production orders corresponding to the different components in BoM
INSERT INTO ProductionOrder (ProductionOrderID, StartDate, EndDate, Status) VALUES
(1, GETDATE()-40, GETDATE()-39, 'Production of Component' ), 
(2, GETDATE()-30, GETDATE()-29, 'Production of Component' ), 
(3, GETDATE()-20, GETDATE()-19, 'Production of Component' ), 
(4, GETDATE()-10, GETDATE()-9, 'Production of Component' ), 
(5, GETDATE(), GETDATE(), 'Production of Component' ), 
(6, GETDATE()-10, GETDATE(), 'Production of Component' ), 
(7, GETDATE()-5, GETDATE(), 'Production of Component' ), 
(8, GETDATE()-15, GETDATE(), 'Production of Component' ), 
(9, GETDATE()+10, GETDATE()+15, 'Production of Component' ), 
(10, GETDATE()+10, GETDATE()+16, 'Production of Component' );
Select * from ProductionOrder;

Select * from SupplierOrder; 
Select * from Batch;
-- Create SupplierBatches corresponding to the SupplierOrders
INSERT INTO Batch (BatchID, SupplierOrderID, MaterialNumber, Quantity, ProductionDate,  MaterialOrigin) VALUES
(1, 1, 12341, 10, GETDATE(), 'Example Location for Material Origin'),
(2, 1, 12342, 20, GETDATE()+1, 'Example Location for Material Origin'),
(3, 2, 12343, 30, GETDATE()+2, 'Example Location for Material Origin'),
(4, 2, 12344, 40, GETDATE()+3, 'Example Location for Material Origin'),
(5, 3, 12345, 50, GETDATE(), 'Example Location for Material Origin'),
(6, 3, 12346, 60, GETDATE(), 'Example Location for Material Origin'),

(7, 4, 45611, 10, GETDATE()-5, 'Example Location for Material Origin'),
(8, 4, 45612, 20, GETDATE()-6, 'Example Location for Material Origin'),
(9, 5, 45613, 30, GETDATE()-7, 'Example Location for Material Origin'),
(10,5, 45614,40, GETDATE()-10, 'Example Location for Material Origin'),
(11, 1, 45615, 50, GETDATE(), 'Example Location for Material Origin'),
(12, 2, 45616, 10, GETDATE(), 'Example Location for Material Origin');


-- create 10 batches for production of the 10 different components
INSERT INTO Batch (BatchID, ProductionOrderID, MaterialNumber, Quantity, ProductionDate,  BatchChildReference) VALUES
--batches components for product A
(13, 1, 1234, 10, GETDATE()+2,1 ),
(14, 1, 1234, 20, GETDATE()+2, 2),
(15, 2, 1235, 30, GETDATE(),3 ),
(16, 3, 1236, 40, GETDATE(), 4),
(17, 4, 1237, 50, GETDATE(), 5),
(18, 5, 1238, 60, GETDATE(),6 ),
--batches components for product B
(19, 6, 4561, 10, GETDATE(),7 ),
(20, 7, 4562, 20, GETDATE(),8 ),
(21, 8, 4563, 30, GETDATE(),9 ),
(22,8, 4563,40, GETDATE(), 10),
(23, 9, 4564, 30, GETDATE(),11),
(24,10, 4565,40, GETDATE(),12 );
Select * from Batch;


INSERT INTO HandlingUnit (HandlingUnitID, BatchID, AssemblyOrderID) VALUES
--bacthes for product A into HUs
(1, 13, 1),
(2, 13, 1),
(3, 14, 1),
(4, 14, 1),
(5, 15, 1),
(6, 15, 1),
(7, 16, 1),
(8, 16, 1),
(9, 17, 1),
(10, 17, 1),
(11, 18, 1),
(12, 18, 1),
-- batches for product B into HUs
(13, 19, 2),
(14, 19, 2),
(15, 20, 2),
(16, 20, 2),
(17, 21, 2),
(18, 21, 2),
(19, 22, 2),
(20, 22, 2),
(21, 23, 2),
(22, 23, 2),
(23, 24, 2),
(24, 24, 2);
Select * from HandlingUnit;
 

INSERT INTO Event (EventID, EventType, Description) VALUES
(1, 'Product Assembly', 'Assembly description'),
(2, 'End of Line Test', 'Testing description'),
(3, 'Product Warehousing at Plant', 'Storage location at Plant'),
(4, 'Transport to Distribution Center', 'Distribution center location'),
(5, 'Customer Purchase', 'Contract Information'),
(6, 'Repair and maintenance Service', 'Repair description'),
(7, 'Return to OEM', 'return information'),
(8, 'Disassemly, recycling and disposal', 'End of Life information');
Select * from Event;


INSERT INTO SerialNumberHistory (HistoryID, SerialNumber, EventID, Timestamp, Description) VALUES
--create assembly events for all 10 products
(1, 67835, 1, GETDATE()+10, 'Assembly description details'),
(2, 67836, 1, GETDATE()+10, 'Assembly description details'),
(3, 67837, 1, GETDATE()+10, 'Assembly description details'),
(4, 67838, 1, GETDATE()+10, 'Assembly description details'),
(5, 67839, 1, GETDATE()+10, 'Assembly description details'),
(6, 93355, 1, GETDATE()+10, 'Assembly description details'),
(7, 93356, 1, GETDATE()+10, 'Assembly description details'),
(8, 93357, 1, GETDATE()+10, 'Assembly description details'),
(9, 93358, 1, GETDATE()+10, 'Assembly description details'),
(10, 93359, 1, GETDATE()+10, 'Assembly description details'),
--create EoL evets for all products
(11, 67835, 2, GETDATE()+20, 'End of Line Test details'),
(12, 67836, 2, GETDATE()+20, 'End of Line Test details'),
(13, 67837, 2, GETDATE()+20, 'End of Line Test details'),
(14, 67838, 2, GETDATE()+20, 'End of Line Test details'),
(15, 67839, 2, GETDATE()+20, 'End of Line Test details'),
(16, 93355, 2, GETDATE()+20, 'End of Line Test details'),
(17, 93356, 2, GETDATE()+20, 'End of Line Test details'),
(18, 93357, 2, GETDATE()+20, 'End of Line Test details'),
(19, 93358, 2, GETDATE()+20, 'End of Line Test details'),
(20, 93359, 2, GETDATE()+20, 'End of Line Test details'),
--create warehousing events for all products
(21, 67835, 3, GETDATE()+30, 'Warehouse details'),
(22, 67836, 3, GETDATE()+30, 'Warehouse details'),
(23, 67837, 3, GETDATE()+30, 'Warehouse details'),
(24, 67838, 3, GETDATE()+30, 'Warehouse details'),
(25, 67839, 3, GETDATE()+30, 'Warehouse details'),
(26, 93355, 3, GETDATE()+30, 'Warehouse details'),
(27, 93356, 3, GETDATE()+30, 'Warehouse details'),
(28, 93357, 3, GETDATE()+30, 'Warehouse details'),
(29, 93358, 3, GETDATE()+30, 'Warehouse details'),
(30, 93359, 3, GETDATE()+30, 'Warehouse details'),
--create distribution center transport events for all products
(31, 67835, 4, GETDATE()+35, 'Distribution details'),
(32, 67836, 4, GETDATE()+35, 'Distribution details'),
(33, 67837, 4, GETDATE()+35, 'Distribution details'),
(34, 67838, 4, GETDATE()+35, 'Distribution details'),
(35, 67839, 4, GETDATE()+35, 'Distributiondetails'),
(36, 93355, 4, GETDATE()+35, 'Distribution details'),
(37, 93356, 4, GETDATE()+35, 'Distribution details'),
(38, 93357, 4, GETDATE()+35, 'Distribution details'),
(39, 93358, 4, GETDATE()+35, 'Distribution details'),
(40, 93359, 4, GETDATE()+35, 'Distribution details'),
--create purchasing events for all products
(41, 67835, 5, GETDATE()+40, 'Purchase details'),
(42, 67836, 5, GETDATE()+40, 'Purchase details'),
(43, 67837, 5, GETDATE()+40, 'Purchase details'),
(44, 67838, 5, GETDATE()+40, 'Purchase details'),
(45, 67839, 5, GETDATE()+40, 'Purchase details'),
(46, 93355, 5, GETDATE()+40, 'Purchase details'),
(47, 93356, 5, GETDATE()+40, 'Purchase details'),
(48, 93357, 5, GETDATE()+40, 'Purchase details'),
(49, 93358, 5, GETDATE()+40, 'Purchase details'),
(50, 93359, 5, GETDATE()+40, 'Purchase details'),
--create repair events for some products also
(51, 67835, 6, GETDATE()+50, 'Repair details'),
(52, 67835, 6, GETDATE()+55, 'Repair details'),
(53, 67835, 6, GETDATE()+60, 'Repair details'),
(54, 67838, 6, GETDATE()+50, 'Repair details'),
(55, 67839, 6, GETDATE()+50, 'Repair details'),
(56, 93355, 6, GETDATE()+50, 'Repair details'),
(57, 93355, 6, GETDATE()+80, 'Repair details'),
(58, 93357, 6, GETDATE()+50, 'Repair details'),
(59, 93358, 6, GETDATE()+50, 'Repair details'),
(60, 93358, 6, GETDATE()+60, 'Repair details');
Select * from SerialNumberHistory;


--Adding a third product of Type a for more compexity

Select * from SerialNumberRange;
INSERT INTO SerialNumberRange (RangeID, StartSerialNumber, EndSerialNumber, CreatedOn) VALUES
(3,00044551, 00044555, GETDATE()-5);
Select * from SerialNumberRange;

--adding the product into product table: 
INSERT INTO Product (SerialNumber, ProductName, ProductType, BomMaterialNumber, RangeID, OEMID) VALUES
--5 Products for Serialnumber range 1
(00044551, 'Product A', 'Product Type A', 123, 3, 1),
(00044552, 'Product A', 'Product Type A', 123, 3, 1),
(00044553, 'Product A', 'Product Type A', 123, 3, 1),
(00044554, 'Product A', 'Product Type A', 123, 3, 1),
(00044555, 'Product A', 'Product Type A', 123, 3, 1);
Select * from Product;
--adding the necessary assmebly order
INSERT INTO AssemblyOrder (AssemblyOrderID, RangeID, StartDate, EndDAte, Status) VALUES
(3, 3, GETDATE()-1, GetDate(), 'Assembled');
Select * from AssemblyOrder;


--creating the serialnumber history for the product
INSERT INTO SerialNumberHistory (HistoryID, SerialNumber, EventID, Timestamp, Description) VALUES
--create assembly events for all 10 products
(61, 44551, 1, GETDATE()+10, 'Assembly description details'),
(62, 44552, 1, GETDATE()+10, 'Assembly description details'),
(63, 44552, 1, GETDATE()+10, 'Assembly description details'),
(64, 44554, 1, GETDATE()+10, 'Assembly description details'),
(65, 44555, 1, GETDATE()+10, 'Assembly description details'),
--create EoL evets for all products
(66, 44551, 2, GETDATE()+20, 'End of Line Test details'),
(67, 44552, 2, GETDATE()+20, 'End of Line Test details'),
(68, 44553, 2, GETDATE()+20, 'End of Line Test details'),
(69, 44554, 2, GETDATE()+20, 'End of Line Test details'),
(70, 44555, 2, GETDATE()+20, 'End of Line Test details'),
--create warehousing events for all products
(71, 44551, 3, GETDATE()+30, 'Warehouse details'),
(72, 44552, 3, GETDATE()+30, 'Warehouse details'),
(73, 44553, 3, GETDATE()+30, 'Warehouse details'),
(74, 44554, 3, GETDATE()+30, 'Warehouse details'),
(75, 44555, 3, GETDATE()+30, 'Warehouse details'),
--create distribution center transport events for all products
(76, 44551, 4, GETDATE()+35, 'Distribution details'),
(77, 44552, 4, GETDATE()+35, 'Distribution details'),
(78, 44553, 4, GETDATE()+35, 'Distribution details'),
(79, 44554, 4, GETDATE()+35, 'Distribution details'),
(80, 44555, 4, GETDATE()+35, 'Distributiondetails'),
--create purchasing events for all products
(81, 44551, 5, GETDATE()+40, 'Purchase details'),
(82, 44552, 5, GETDATE()+40, 'Purchase details'),
(83, 44553, 5, GETDATE()+40, 'Purchase details'),
(84, 44554, 5, GETDATE()+40, 'Purchase details'),
(85, 44555, 5, GETDATE()+40, 'Purchase details'),
--create repair events for some products also
(86, 44551, 6, GETDATE()+50, 'Repair details'),
(87, 44551, 6, GETDATE()+55, 'Repair details'),
(88, 44552, 6, GETDATE()+60, 'Repair details'),
(89, 44552, 6, GETDATE()+50, 'Repair details'),
(90, 44553, 6, GETDATE()+50, 'Repair details');


--adding the HandlingUnits witht he existing batches to the new product
Select * from AssemblyOrder;
INSERT INTO HandlingUnit (HandlingUnitID, BatchID, AssemblyOrderID) VALUES
--bacthes for product A into HUs
(25, 13, 3),
(26, 13, 3),
(27, 14, 3),
(28, 14, 3),
(29, 15, 3),
(30, 15, 3),
(31, 16, 3),
(32, 16, 3),
(33, 17, 3),
(34, 17, 3),
(35, 18, 3),
(36, 18, 3);
Select * from HandlingUnit;


--add RevisionLevel entry to Batch retrospectively: 
-- Add the RevisionLevel column to the Batch table
-- Add the RevisionLevel column to the Batch table
ALTER TABLE Batch
ADD RevisionLevel VARCHAR(10);

-- Create a CTE to calculate the row numbers
WITH NumberedBatches AS (
    SELECT
        BatchID,
        ProductionOrderID,
        SupplierOrderID,
        ROW_NUMBER() OVER (PARTITION BY COALESCE(ProductionOrderID, SupplierOrderID) ORDER BY BatchID) AS RowNum
    FROM
        Batch
)

-- Update the RevisionLevel column for existing entries
UPDATE B
SET B.RevisionLevel = CASE
    WHEN NB.ProductionOrderID IS NOT NULL THEN 'P' + CAST(NB.RowNum AS VARCHAR(10))
    WHEN NB.SupplierOrderID IS NOT NULL THEN 'S' + CAST(NB.RowNum AS VARCHAR(10))
    ELSE 'R' + CHAR(65 + (NB.RowNum - 1) % 3) + CAST((NB.RowNum - 1) / 3 + 1 AS VARCHAR(10))
END
FROM
    Batch AS B
    JOIN NumberedBatches AS NB ON B.BatchID = NB.BatchID;


	Select * from Batch;


	-- Add the RevisionLevel column to the AssemblyOrder table
ALTER TABLE AssemblyOrder
ADD RevisionLevel VARCHAR(10);

-- Create a CTE to calculate the row numbers
WITH NumberedAssemblyOrders AS (
    SELECT
        AssemblyOrderID,
        ROW_NUMBER() OVER (PARTITION BY RangeID ORDER BY AssemblyOrderID) AS RowNum
    FROM
        AssemblyOrder
)

-- Update the RevisionLevel column for existing entries
UPDATE AO
SET AO.RevisionLevel = 'A' + CAST(NAO.RowNum AS VARCHAR(10))
FROM
    AssemblyOrder AS AO
    JOIN NumberedAssemblyOrders AS NAO ON AO.AssemblyOrderID = NAO.AssemblyOrderID;


	Select * from AssemblyOrder;

