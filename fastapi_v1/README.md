# FastAPI 
FastAPI es un marco web moderno y de alto rendimiento para construir APIs con Python 3.7+ basado en estándares de tipado de Python, como Pydantic para la validación de datos y Starlette para el manejo de solicitudes HTTP.

Proporciona una sintaxis fácil de usar y rápida, así como una documentación automática generada con Swagger (OpenAPI) y ReDoc.


## Crear main.py

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "¡Hola Mundo!"}
```

## Instalar FastAPI y Uvicorn
```bash
pip install fastapi uvicorn

``` 


### Lanzar el servidor en algún puerto, por ejemplo 8210
```bash
uvicorn app:app --port 8210
```


## Links

[FastAPI user guide](https://fastapi.tiangolo.com/tutorial/)



# Probar la aplicación 
Una vez que el servidor esté en funcionamiento, puedes abrir un navegador web o utilizar herramientas como curl o Postman para acceder a la URL http://localhost:8210 y verás la respuesta 
```
¡Hola Mundo!
```











