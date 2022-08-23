# skin_camera

Aplicacion y notebook para el entrenamiento y utilizacion del modelo VGG16+CNN customizado para el problema de clasificacion de lesiones epiteliales


## Notebook de Jupyter
A continuacion se presentara detalles sobre el notebook de Jupyter
1. Subir el notebook en una plataforma como Kaggle o Google Colab (opcional)
2. Agregar el dataset de HAM10000 https://www.kaggle.com/datasets/kmader/skin-cancer-mnist-ham10000
3. Utilizar GPU (opcional pero recomendable)
4. Cambiar los parametros para el data augmentation en caso se necesite realizar alguna combinacion nueva
<code>
  DIR_PATH_1 = '/kaggle/input/skin-cancer-mnist-ham10000/ham10000_images_part_1' // ubicacion de la primera carpeta
  DIR_PATH_2 = '/kaggle/input/skin-cancer-mnist-ham10000/ham10000_images_part_2' // ubicacion de la segunda carpeta

  DIR_PATH = '/kaggle/input/skin-cancer-mnist-ham10000/' // ubicacion de la carpeta raiz
  META_PATH = './HAM10000_metadata.csv' // ubicacion del csv con la metadata del conjunto de datos
</code>
<code>
  HP_PREPRO = hp.HParam('preprocessing_function', hp.Discrete(['gridmask'])) // posibles opciones 'gridmask' y 'rescale'
  
  HP_ROTATE = hp.HParam('rotation_range', hp.Discrete([90]))
  
  HP_WIDTH_SHIFT = hp.HParam('width_shift_range', hp.Discrete([0.15]))
  
  HP_HEIGHT_SHIFT = hp.HParam('height_shift_range', hp.Discrete([0.15]))
  
  HP_SHEAR = hp.HParam('shear_range', hp.Discrete([0.5]))
  
  HP_ZOOM = hp.HParam('zoom_range', hp.Discrete([0.25]))
  
  HP_HORIZONTAL = hp.HParam('horizontal_flip', hp.Discrete([True]))
  
  HP_VERTICAL = hp.HParam('vertical_flip', hp.Discrete([True]))
  
</code>
5. Correr todas las celdas del notebook
6. Se creara nuevas carpetas, las cuales incluye el log para el tensorboard (/logs) y el mejor modelo segun el val_accuracy mayor encontrado durante el periodo de entrenamiento (/models/callback)

Nota: Se recomienda realizar pocas iteraciones para las combinaciones, con el fin de guardar 

## Aplicacion Flutter
Para la aplicacion de Flutter, se realiza una pequena app donde se realiza una subida de imagenes o toma de fotos para el procesamiento con el modelo de clasificacion de lesiones epiteliales

Para correr la aplicacion es necesario configurar la URL del servidor donde se sube las imagenes, esto se realiza en la carpeta /lib/constants/app_urls.dart
<code>
  class AppUrls {
    static String URL_BACKEND = "<endpoint de subida de imagenes>"; // e.g http://localhost:3000/upload
  }
</code>
  
## Modelo dockerizado
Para correr el modelo contenido en el docker, se tiene que seguir los pasos establecidos en la carpeta de vggmodel/ y en el archivo README.md

## Servidor web
Para correr el servidor web que esta enlazado con el modelo dockerizado de inteligencia artificial se establece la url del dockerizado en la siguiente seccion del codigo
 
![image](https://user-images.githubusercontent.com/91985728/186070324-4b8c242c-b89d-475c-a53b-3a546c6df7f4.png)

Una vez establecido el enlace, se corre el servidor con el siguiente comando
<code>
  python main.py
</code>
