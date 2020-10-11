from flask import Flask, request, jsonify
from flask_restplus import Resource, Api, fields
from werkzeug.datastructures import FileStorage
import requests, base64, json, uuid

app = Flask(__name__)
api = Api(app)

parser = api.parser()
parser.add_argument('content', location='files', type=FileStorage, required=True)


@api.route('/car-recognize')
class CarRecognize(Resource):
    @api.doc(parser=parser)
    def post(self):
        image = parser.parse_args()['content'].read()
        cars = requests.post('https://gw.hackathon.vtb.ru/vtb/hackathon/car-recognize', data=json.dumps({'content': base64.b64encode(image).decode('utf-8')}), headers={
            "x-ibm-client-id" : "862e62f61ef0e7ffa9c180225f891565",
            "content-type" : "application/json",
            "accept" : "application/json"
        })
        cars = cars.json()['probabilities']  
        car = max(cars, key=lambda x: cars[x]) 
        
        if (cars[car] < 0.3):
            preds = requests.post('http://84.201.167.60:8080/car-recognize', data=json.dumps({'content': base64.b64encode(image).decode('utf-8')}), headers= {
                "content-type" : "application/json",
                "accept" : "application/json"
            })
            preds = preds.json()['probabilities']
            car = max(preds, key=lambda x: preds[x])
        print(car)
        return jsonify({'car': car}) 

@api.route('/')
class SimpleAnswer(Resource):
    def get(self):
        return "Works"

# if __name__=='__main__':        
#     #Run the applications
#     app.run()