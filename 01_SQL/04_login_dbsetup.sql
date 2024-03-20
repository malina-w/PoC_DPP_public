-- Replace 'YourLoginName' and 'YourPassword' with your desired values
CREATE LOGIN PoCUser WITH PASSWORD = 'AccessMalinasPoC', CHECK_POLICY = OFF;


-- Replace 'YourLoginName' and 'YourDatabase' with your login and database names
USE CoreSystems;
CREATE USER PoCUser FOR LOGIN PoCUser;

-- Replace 'YourLoginName' and 'YourDatabase' with your login and database names
USE CoreSystems;
EXEC sp_addrolemember 'db_datareader', 'PoCUser';  -- Grant necessary roles
EXEC sp_addrolemember 'db_datawriter', 'PoCUser';



-- Replace 'YourLoginName' and 'YourPassword' with your desired values
CREATE LOGIN PoCUser WITH PASSWORD = 'AccessMalinasPoC', CHECK_POLICY = OFF;
-- Replace 'YourLoginName' and 'YourDatabase' with your login and database names
USE Target;
CREATE USER PoCUser FOR LOGIN PoCUser;

-- Replace 'YourLoginName' and 'YourDatabase' with your login and database names
USE Target;
EXEC sp_addrolemember 'db_datareader', 'PoCUser';  -- Grant necessary roles
EXEC sp_addrolemember 'db_datawriter', 'PoCUser';
