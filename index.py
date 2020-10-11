from flask import Flask, request, jsonify
from flask_restplus import Resource, Api, fields
# from mongoengine import Document, connect, disconnect, StringField, ListField, IntField, EmailField
from werkzeug.datastructures import FileStorage
import requests, base64, json, uuid
# import utils
# from PIL import Image
# from io import BytesIO

app = Flask(__name__)
api = Api(app)


# class User(Document):
#     user_id = StringField(required=True)
#     photos = ListField(StringField())
#     first_name = StringField()
#     family_name = StringField()
#     middle_name = StringField()
#     phone = IntField()
#     birth_place = StringField()
#     email = EmailField()
#     birth_date_time = StringField()



parser = api.parser()
parser.add_argument('content', location='files', type=FileStorage, required=True)
# model = utils.load_model('./model.weights')


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
            # preds = utils.inference(model, image)
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
        return jsonify({'response': 'ok'})

        # info = requests.get('https://gw.hackathon.vtb.ru/vtb/hackathon/marketplace', headers={
        #     "x-ibm-client-id" : "862e62f61ef0e7ffa9c180225f891565",
        #     'accept': 'application/json',
        # })
        
        # auto = []
        # for x in info.json()['list']:
        #     if car.startswith(x['title']):
        #         for mod in x['models']:
        #             auto.append({
        #                 "price": mod['minPrice'],
        #                 "title": mod['title'],
        #                 "doors": mod['bodies'][0]['doors'],
        #                 "body": mod['bodies'][0]['title']
        #             })
        # print(auto)

        # [print(x['models'][0]['minPrice']) for x in info.json()['list'] if car.startswith(x['title'])]   



# if __name__ == '__main__':
#     app.run(debug=True)