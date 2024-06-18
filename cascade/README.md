# Creación de tablas con claves foráneas y dependencias en cascada

La actualización en cascada es una característica de las bases de datos relacionales que permite que los cambios en los valores 
de claves primarias de una tabla se propaguen automáticamente a las tablas relacionadas que contienen claves foráneas referenciando 
esas claves primarias. Esto es especialmente útil para mantener la integridad referencial entre tablas relacionadas.


## Creación de tablas departamentos y empleados
```SQL

CREATE TABLE departamentos (
    dept_id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);
CREATE TABLE empleados (
    emp_id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departamentos(dept_id)
        ON UPDATE CASCADE
);
```

## Inserción de datos de departamentos

```SQL
INSERT INTO departamentos (dept_id, nombre) VALUES
(1, 'Recursos Humanos'),
(2, 'TI'),
(3, 'Finanzas');

``` 
