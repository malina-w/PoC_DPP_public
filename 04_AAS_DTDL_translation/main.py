#!/usr/bin/env python3
import json
import re
import argparse

def parse_sql_table(table_definition):
    """
    Parses a single SQL table definition and extracts its columns.
    """
    lines = table_definition.split('\n')
    table_name = re.findall(r'CREATE TABLE (\w+)', lines[0])[0]
    columns = []
    for line in lines[1:]:
        match = re.match(r'\s*(\w+) (\w+).*', line)
        if match:
            columns.append({'name': match.group(1), 'type': match.group(2)})
    return table_name, columns

def sql_to_aas(sql_schema):
    """
    Converts the entire SQL schema into an AAS model.
    """
    tables = sql_schema.strip().split(';')
    aas_model = []
    for table in tables:
        if "CREATE TABLE" in table:
            table_name, columns = parse_sql_table(table)
            asset = {
                'id': table_name,
                'properties': columns
            }
            aas_model.append(asset)
    return aas_model

def convert_sql_to_aas(input_file, output_file):
    with open(input_file, 'r') as file:
        sql_schema = file.read()

    aas_model = sql_to_aas(sql_schema)

    with open(output_file, 'w') as file:
        json.dump(aas_model, file, indent=4)

def main():
    parser = argparse.ArgumentParser(description='Convert SQL schema to AAS format.')
    parser.add_argument('sql_in', type=str, help='AAS_DTDL_translation\aas_out.json')
    parser.add_argument('aas_out', type=str, help='AAS_DTDL_translation\sql_in.sql')
    args = parser.parse_args()

    convert_sql_to_aas(args.input_file, args.output_file)

if __name__ == "__main__":
    main()
