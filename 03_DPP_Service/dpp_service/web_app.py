from flask import render_template, Flask, request
import requests


app = Flask(__name__)

# url from dt platform
base_url = 'http://localhost:5001'

@app.route('/')
def index():
    return render_template('index.html')


@app.route('/api_request', methods=['POST'])
def api_request():
    data = request.get_json()
    entered_product_id = data.get('productId')
    print(entered_product_id)
    # response = requests.get(f"{base_url}/api/defaultapi")
    response = requests.get(f"{base_url}/api/dpp/{entered_product_id}")
    if response.status_code == 200:
        data = response.json()
        return data
    return 'API request failed.'

if __name__ == '__main__':
    app.run(host="localhost", port=5002, debug=True)
