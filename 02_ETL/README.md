# ETL Service


## start ETL service

in terminal, start the service for the front-end;
`` python 02_ETL\main.py    
``

## Program structure

1. main.py contains the program executing the ETL job
2. db_connection.py contains the database connection properties to connect to the database
3. queries.py contains the relevant sql queries to fetch data from the database
4. etl.py contains the data transformation program that transforms and loads the data into the Target database