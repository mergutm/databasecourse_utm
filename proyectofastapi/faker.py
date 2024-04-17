# !pip install Faker

from faker import Faker
import numpy as np

#instancia de faker
fake = Faker('es_MX')

#impresion de ejemplo
print( fake.name() )


for i in range(10):
  nombre = fake.name()
  edad = np.random.randint(low=15,high=90)
  direccion = fake.address()  
  sql = f"INSERT INTO Socio (nombre, edad, direccion) VALUES ('{nombre}', {edad}, '{direccion}' );"
  print(sql)
  
"""
Ejemplo de Salida esperada:
INSERT INTO Socio (nombre, edad, direccion) VALUES ('Noelia Sandra Terán', 49, 'Circunvalación Querétaro 796 Edif. 205 , Depto. 940 Vieja Líbano, COAH 06303' );
INSERT INTO Socio (nombre, edad, direccion) VALUES ('Raúl Arriaga', 72, 'Retorno República Democrática Popular Lao 424 Interior 459 Nueva Reino Unido de Gran Bretaña e Irlanda del Norte, MICH 37523-1580' );
INSERT INTO Socio (nombre, edad, direccion) VALUES ('Rolando Quesada Maya', 58, 'Callejón Sur Bahena 947 Edif. 194 , Depto. 244 Vieja Eslovaquia, CAMP 90335' );
INSERT INTO Socio (nombre, edad, direccion) VALUES ('Beatriz Jáquez', 22, 'Periférico Aguascalientes 152 Edif. 190 , Depto. 162 San Indira de la Montaña, VER 45063-8922' );
INSERT INTO Socio (nombre, edad, direccion) VALUES ('Humberto Rosa Rojas', 62, 'Callejón Grecia 659 Interior 858 San Felipe de la Montaña, MEX 18015' );
INSERT INTO Socio (nombre, edad, direccion) VALUES ('Ana Olvera Morales', 40, 'Andador Centeno 699 388 Nueva República Federal Democrática de Nepal, CHIS 99267-8311' );
INSERT INTO Socio (nombre, edad, direccion) VALUES ('Leticia Javier Rocha', 49, 'Ampliación Distrito Federal 868 103 Vieja Djibouti, PUE 59296-4321' );
INSERT INTO Socio (nombre, edad, direccion) VALUES ('Luis Miguel Gustavo Bustamante Garay', 27, 'Calle Azerbaiyán 565 Edif. 912 , Depto. 514 Nueva Bangladesh, GRO 79921-1471' );
INSERT INTO Socio (nombre, edad, direccion) VALUES ('Jorge Luis Natalia Valladares', 58, 'Continuación Malawi 428 Interior 871 San Dulce María los bajos, NAY 17603' );
INSERT INTO Socio (nombre, edad, direccion) VALUES ('Jaime Ordóñez', 44, 'Peatonal Regalado 128 Interior 780 San Asunción de la Montaña, SLP 59950' );
""" 
