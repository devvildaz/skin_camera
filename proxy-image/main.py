from fastapi import FastAPI, File, UploadFile
import os
import cv2
import numpy as np
import uuid 
import json
import requests
import uvicorn

app = FastAPI()


@app.post("/fast-proxy/")
async def create_file(file :UploadFile):
    
    classes = ['bkl', 'nv', 'df', 'mel', 'vasc', 'bcc', 'akiec'] 

    classes = [
            "benign keratosis-like lesions",
            "melanocytic nevi",
            "dermatofibroma",
            "melanoma",
            "vascular lesions",
            "basal cell carcinoma",
            "Actinic keratoses and intraepithelial carcinoma / Bowen's disease"
    ]

    classes = [
            "Actinic keratoses and intraepithelial carcinoma / Bowen's disease",
            "Basal cell carcinoma",
            "benign keratosis-like lesions",
            "dermatofibroma",
            "melanoma",
            "melanocytic nevi",
            "vascular lesions"
    ]

    content = await file.read()
    print("pass content")
    image = cv2.imdecode(np.fromstring(content, np.uint8), cv2.IMREAD_UNCHANGED)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    image = cv2.resize(image, (192, 192))
    image = np.expand_dims(image, axis=0)
    headers = {"content-type": "application/json"}
    url = "https://vgg162app.herokuapp.com/v1/models/vgg16:predict"
    data = json.dumps({"signature_name": "serving_default", "instances": image.tolist()})
    response = requests.post(url, data=data, headers=headers)
    predictions = json.loads(response.text)["predictions"]
    res = classes[np.argmax(predictions)]
    return {"prediction": res}

uvicorn.run(app, host="0.0.0.0", port=8000)
