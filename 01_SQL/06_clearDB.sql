-- Set the database context
USE <Put in DB name>;

-- Disable foreign key constraints
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';

-- Delete data from all tables
EXEC sp_MSforeachtable 'DELETE FROM ?';

-- Enable foreign key constraints
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';



--or speocifc for Target harcoded
-- Delete all data from the tables in the target database for renewed etl run
DELETE FROM LifecycleEvent;
DELETE FROM BatchSupplierRelation;
DELETE FROM Component;
DELETE FROM Batch;
DELETE FROM Product;
DELETE FROM Supplier;
DELETE FROM OEM;
DELETE FROM ProductSerialization;