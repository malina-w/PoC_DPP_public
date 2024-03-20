from database.db_connection import fetch_product_data

from flask import Flask, jsonify
import logging


logging.basicConfig(
    level=logging.DEBUG
)

logger = logging.getLogger(__name__)

app = Flask(__name__)

# API 1: default api for testing
@app.route('/api/defaultapi', methods=['GET'])
def default_api():
    response = {
        'number': "Welcome to the Digital Product Passport - this is a test!"
    }
    return jsonify(response)

# API 2: DPP response (Main API for Digital Product Pass Response)
@app.route('/api/dpp/<string:serial_number>', methods=['GET'])
def dpp(serial_number):
    # Call the fetch_product_data function from db_queries module
    result = fetch_product_data(serial_number)
    # Return the result as JSON
    print(result)
    return jsonify(result)

if __name__ == "__main__":
    app.run(host="localhost", port=5001, debug=True)
    #main()
  