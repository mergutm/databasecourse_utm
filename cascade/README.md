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

## Inserción de datos válidos en empleados

```SQL
INSERT INTO empleados (emp_id, nombre, dept_id) VALUES 
(101, 'Alice', 1), 
(102, 'Bob', 2), 
(103, 'Charlie', 3);
```


## Actualización de los datos en la BD

```sql
UPDATE departamentos SET dept_id = 4 WHERE dept_id = 1;
```



## Actualización y eliminación en cascada
Se pueden agregar restricciones de eliminación y actualización en cascada 
```SQL
ALTER TABLE empleados
ADD CONSTRAINT fk_dept
FOREIGN KEY (dept_id) 
	REFERENCES departamentos(dept_id)
ON DELETE CASCADE
ON UPDATE CASCADE
```

o definir la tabla al momento de crearla con dichas restricciones.

```SQL
CREATE TABLE empleados (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departamentos(dept_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

# Validación de restricciones

Validación de ejemplo sobre rangos de datos enteros, de punto flotante, y fechas

```sql
CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edad INT NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    CHECK (edad BETWEEN 18 AND 65),
    CHECK (salario >= 30000.00 AND salario <= 200000.00),
    CHECK (fecha_contratacion >= '2000-01-01' AND fecha_contratacion <= CURRENT_DATE())
);
```

Usando disparadores:
```sql
CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edad INT NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    fecha_contratacion DATE NOT NULL
);

DELIMITER //

CREATE TRIGGER validar_empleado_insert
BEFORE INSERT ON empleados
FOR EACH ROW
BEGIN
    IF NEW.edad < 18 OR NEW.edad > 65 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La edad debe estar entre 18 y 65 años';
    END IF;
    IF NEW.salario < 30000.00 OR NEW.salario > 200000.00 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El salario debe estar entre 30000.00 y 200000.00';
    END IF;
    IF NEW.fecha_contratacion < '2000-01-01' OR NEW.fecha_contratacion > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de contratación debe estar entre 2000-01-01 y la fecha actual';
    END IF;
END //

CREATE TRIGGER validar_empleado_update
BEFORE UPDATE ON empleados
FOR EACH ROW
BEGIN
    IF NEW.edad < 18 OR NEW.edad > 65 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La edad debe estar entre 18 y 65 años';
    END IF;
    IF NEW.salario < 30000.00 OR NEW.salario > 200000.00 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El salario debe estar entre 30000.00 y 200000.00';
    END IF;
    IF NEW.fecha_contratacion < '2000-01-01' OR NEW.fecha_contratacion > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de contratación debe estar entre 2000-01-01 y la fecha actual';
    END IF;
END //

DELIMITER ;

```



#
