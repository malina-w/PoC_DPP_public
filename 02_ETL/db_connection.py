# Pyton programme for Database connection supporting the etl service
import pyodbc

def connect_to_database(server, db_name, username, password):
    #Create a connection string
    db_source_conn_str = f'DRIVER={{SQL Server}};SERVER={server};DATABASE={db_name};UID={username};PWD={password}'
    # Establish a connection to the database
    conn = pyodbc.connect(db_source_conn_str)
    # Get the list of tables in the database       
    return conn


