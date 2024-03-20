import pyodbc

from database.db_queries import FETCH_PRODUCT_DATA
from database.db_queries import FETCH_MATERIAL_DATA
from database.db_queries import FETCH_EVENT_DATA

def fetch_product_data(serialnumber):
    # DB connection to Target
    server = 'localhost\SQLEXPRESS'  # SQL Server name
    database2 = 'Target'  # database2 name
    username = 'PoCUser'  #  username
    password = 'AccessMalinasPoC'  # password

    # Create a connection string
    db_conn_str = f'DRIVER={{SQL Server}};SERVER={server};DATABASE={database2};UID={username};PWD={password}'
    # Establish a connection
    conn_db = pyodbc.connect(db_conn_str)
    
    # Create a cursor
    cursor_db = conn_db.cursor()
    # Execute queries for the specified serial number
    cursor_db.execute(FETCH_PRODUCT_DATA, serialnumber)
    # Fetch the result for the product
    product_result = cursor_db.fetchone()

    # Create a new cursor for the second query
    cursor_db_components = conn_db.cursor()
    # Execute the modified query for fetching components for the specified serial number
    cursor_db_components.execute(FETCH_MATERIAL_DATA, serialnumber)
    # Fetch all the results for components
    components_results = cursor_db_components.fetchall()
    
    # Create a new cursor for the third query
    cursor_db_events = conn_db.cursor()
    # Execute the modified query for fetching events for the specified serial number
    cursor_db_events.execute(FETCH_EVENT_DATA, serialnumber)
    # Fetch all the results for components
    event_results = cursor_db_events.fetchall()

    # Get the column names from the cursor
    product_columns = [column[0] for column in cursor_db.description]
    components_columns = [column[0] for column in cursor_db_components.description]
    event_columns = [column[0] for column in cursor_db_events.description]

    # Create dictionaries for the product and components
    product_dict = dict(zip(product_columns, product_result))
    components_list = [dict(zip(components_columns, row)) for row in components_results]
    event_list = [dict(zip(event_columns, row)) for row in event_results]

    # Combine the results into a single dictionary
    result_dict = {
        'Product': product_dict,
        'Components': components_list,
        'Events': event_list
    }

    # Return the combined result
    return result_dict