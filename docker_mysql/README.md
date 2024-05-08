# Contenedor con mysql y phpmyadmin

Detalles técnicos pueden consultarse en: https://josejuansanchez.org/bd/practica-07/index.html

## usaremos el archivo `docker-compose.yml` 

```yml
version: '3'

services:
  mysql:
    image: mysql:8.0
    ports:
      - 3306:3306
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=database
      - MYSQL_USER=user
      - MYSQL_PASSWORD=password
    volumes:
      - mysql_data:/var/lib/mysql
      - /home/usuario/databasestar:/databasestar

  phpmyadmin:
    image: phpmyadmin
    ports:
      - 8080:80
    environment:
      - PMA_HOST=mysql
    depends_on:
      - mysql

volumes:
  mysql_data:


```  

## Levantar el servidor:

```bash 
  docker compose up
```
  
### Para iniciar los servicios en segundo plano con la utilidad docker-compose tenemos que ejecutar el siguiente comando.

```bash 
docker-compose up -d
```

### Para detener los servicios y mantener el volumen que hemos creado podemos ejecutar:
```bash 
docker-compose down
```
### Si además de detener los servicios queremos eliminar el volumen que hemos creado tenemos que añadir el parámetro -v.
```bash 
docker-compose down -v
```
### Para comprobar el estado de los servicios podemos ejecutar:
```bash 
docker-compose ps
```


## Source
https://github.com/josejuansanchez/docker-compose-playground/tree/master/example-07-mysql-phpmyadmin





# Usando variables de entorno 

Usar el archivo `docker-compose.yml`

```yml

version: '3'

services:
  mysql:
    image: mysql:8.0
    ports:
      - 3306:3306
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_DATABASE=${MYSQL_DATABASE}
      - MYSQL_USER=${MYSQL_USER}
      - MYSQL_PASSWORD={MYSQL_PASSWORD}
    volumes:
      - mysql_data:/var/lib/mysql

  phpmyadmin:
    image: phpmyadmin
    ports:
      - 8080:80
    environment:
      - PMA_HOST=mysql
    depends_on: 
      - mysql 

volumes:
  mysql_data:
```


Se requiere tener las variables de entorno declaradas con el comando export o con el siguiente archivo  `.env`

```bash
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=database
MYSQL_USER=user
MYSQL_PASSWORD=password
```

Para activar las variables de entorno, usar:
```bash
source .env
```


Más ejemplos en:

https://github.com/josejuansanchez/docker-compose-playground/tree/master







Descargar bases de datos de ejemplo en: 
`https://github.com/bbrumm/databasestar.git`
