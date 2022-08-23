# Tensorflow Serving

Se utilizó una imagen pública `Tensorflow/serving`.

## Dockerfile

```
FROM tensorflow/serving

ENV MODEL_BASE_PATH /models
ENV MODEL_NAME vgg16

COPY models /models
COPY tf_serving_entrypoint.sh /usr/bin/tf_serving_entrypoint.sh
RUN chmod +x /usr/bin/tf_serving_entrypoint.sh
ENTRYPOINT []
CMD ["/usr/bin/tf_serving_entrypoint.sh"]
```

## Heroku CLI
Para realizar el despliegue del servicio web del modelo en Heroku se tiene que instalar Heroku CLI 
1. El cli requiere de login.
```
heroku login
```
2. Autenticar el registro de contenedor
```
heroku container:login
```
3. Crear aplicación
```
heroku create vgg162
```
4. Compilar la imagen Dockerfile y subir la imagen al registro
```
heroku container:push web -a vgg162
```
5. Levantar la imagen
```
heroku container:release web -a vgg162
```

La ruta del despliegue es: `https://vgg162app.herokuapp.com/`
