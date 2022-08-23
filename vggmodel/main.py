import requests
import cv2
import json
import numpy as np
import tensorflow as tf
from tensorflow.keras.applications.vgg16 import decode_predictions
import time


image = cv2.imread("imagen_incognito.jpg")
image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
image = cv2.resize(image, (192, 192))
image = np.expand_dims(image, axis=0)

start_time = time.time()

url = "https://vgg162app.herokuapp.com/v1/models/vgg16:predict"
data = json.dumps({"signature_name": "serving_default", "instances": image.tolist()})
headers = {"content-type": "application/json"}
response = requests.post(url, data=data, headers=headers)
predictions = json.loads(response.text)["predictions"]
#  print(json.loads(response.text)
#  result = decode_predictions(np.array(predictions))
print(predictions)
