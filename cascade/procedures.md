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

```SQL
DELIMITER //

CREATE PROCEDURE eliminar_estudiante(IN estudiante_id INT)
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al eliminar el estudiante';
    END;
    
    START TRANSACTION;    
    DELETE FROM estudiantes WHERE id = estudiante_id;    
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



```SQL


```


