## Tabla estudiantes de ejemplo

```SQL
CREATE TABLE estudiantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edad INT NOT NULL
);

```

## Procedimiento para inserción de estudiantes.

```SQL
DELIMITER //

CREATE PROCEDURE insertar_estudiante(IN nombre VARCHAR(100), IN edad INT)
BEGIN
    INSERT INTO estudiantes (nombre, edad) VALUES (nombre, edad);
END //

DELIMITER ;
```

## Procedimiento para actualizar un estudiante

Se considera una validación de entre un rango de edad, si no se cumple que los datos para la actualización cumplan con el rango, genera un error.
```SQL
DELIMITER //

CREATE PROCEDURE actualizar_edad(IN estudiante_id INT, IN nueva_edad INT)
BEGIN
    IF nueva_edad BETWEEN 18 AND 50 THEN
        UPDATE estudiantes SET edad = nueva_edad WHERE id = estudiante_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Edad fuera del rango permitido (18-50)';
    END IF;
END //

DELIMITER ;

```

### Probando el procedimiento

```SQL
call actualizar_edad(2, 45);
```

### Generación de errores al borrar un id inválido

Si existe un error durante la actualización (el rango según el ejemplo anterior), se genera un error.

```SQL
DELIMITER //

CREATE PROCEDURE actualizar_edad_estudiante(IN estudiante_id INT, IN nueva_edad INT)
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al eliminar el estudiante';
    END;
    
    START TRANSACTION;    
        UPDATE estudiantes SET edad = nueva_edad WHERE id = estudiante_id;
    COMMIT;
END //
DELIMITER ;
```

## ROLLBACK

Suponer la siguiente tabla

```SQL
CREATE TABLE estudiantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edad INT NOT NULL,
    CHECK (edad BETWEEN 18 AND 50)
);

```
crear un procedimiento almacenado que intenta insertar 10 estudiantes y maneja las excepciones. Si ocurre una excepción, se activa un ROLLBACK.


```SQL
DELIMITER //

CREATE PROCEDURE insertar_estudiantes()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Ha ocurrido un error. Se ha realizado un rollback.' AS mensaje;
    END;

    START TRANSACTION;

    INSERT INTO estudiantes (nombre, edad) VALUES ('Estudiante1', 22);
    INSERT INTO estudiantes (nombre, edad) VALUES ('Estudiante2', 25);
    INSERT INTO estudiantes (nombre, edad) VALUES ('Estudiante3', 27);
    INSERT INTO estudiantes (nombre, edad) VALUES ('Estudiante4', 30);
    INSERT INTO estudiantes (nombre, edad) VALUES ('Estudiante5', 32);
    INSERT INTO estudiantes (nombre, edad) VALUES ('Estudiante6', 35);
    INSERT INTO estudiantes (nombre, edad) VALUES ('Estudiante7', 37);
    INSERT INTO estudiantes (nombre, edad) VALUES ('Estudiante8', 28);
    INSERT INTO estudiantes (nombre, edad) VALUES ('Estudiante9', 26);
    -- Esta inserción producirá un error debido a que la edad está fuera del rango permitido (si existiera un CHECK constraint)
    INSERT INTO estudiantes (nombre, edad) VALUES ('Estudiante10', 17);

    COMMIT;
END //

DELIMITER ;


```

## Llamar al procedimiento

```SQL
CALL insertar_estudiantes();


```
El procedimiento puede manejar errores durante la inserción y garantizar que no se cometan errores parciales en la base de datos.







