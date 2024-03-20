# DPP Service

## start DPP service

in first terminal, start the service for the front-end
``python 03_DPP_Service\dpp_service\web_app.py     
``
in second terminal start the service for the back-end
``
python 03_DPP_Service\main.py
``


## Program structure
1. templates/index.html contains the script that generates the front-end of the DPP service
2. web_app.py conmtains the python program executing the service on localhost
3. main.py executes the service for data retrieval from the database called Target, representing a data warehouse
4. database/db_connection.py contains the connection to the database
5. database/db_queries contains the queries to fetch data from the database