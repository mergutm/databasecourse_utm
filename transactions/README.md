# Ejemplo de datos

```SQL
CREATE TABLE `cuentas` (
  `id` int NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `balance` decimal(10,2) DEFAULT NULL
);

INSERT INTO `cuentas` (`id`, `nombre`, `balance`) VALUES
(1, 'pedro', '900.00'),
(2, 'Maria', '5100.00'),
(3, 'Sara', '750.00'),
(4, 'Olá', '3200.00');

ALTER TABLE `cuentas`
  ADD PRIMARY KEY (`id`);
```

# Aislamiento de transacción

```SQL

-- Iniciar la transacción
START TRANSACTION;

-- Bloquear las filas de las cuentas involucradas para evitar conflictos
SELECT balance FROM cuentas WHERE id = 1 FOR UPDATE;
SELECT balance FROM cuentas WHERE id = 2 FOR UPDATE;

-- Supongamos que queremos transferir 100 unidades de la cuenta 1 a la cuenta 2
UPDATE cuentas SET balance = balance - 100 WHERE id = 1;
UPDATE cuentas SET balance = balance + 100 WHERE id = 2;

-- Confirmar la transacción
COMMIT;
```

### Autocommit

* En MySQL, la variable autocommit controla si las modificaciones de la base de datos se confirman automáticamente después de cada declaración SQL. 
* Por defecto, autocommit está habilitado (valor 1), lo que significa que cada declaración SQL que modifica la base de datos se confirma automáticamente una vez que se ejecuta. Si se establece autocommit en 0, se requiere una confirmación explícita (COMMIT) para aplicar los cambios, o una reversión explícita (ROLLBACK) para deshacerlos.
* Deshabilitar autocommit permite agrupar múltiples declaraciones en una sola transacción atómica. Esto asegura que todas las modificaciones se apliquen o se deshagan juntas, manteniendo la consistencia de los datos.
* Con autocommit deshabilitado, se pueden aplicar bloqueos y manejar el aislamiento de transacciones de manera más efectiva, evitando problemas de concurrencia como lecturas sucias, lecturas no repetibles y fantasmas.

To disable autocommit mode explicitly, use the following statement:
```SQL
SET autocommit=0;
```


# Datos un segundo ejemplo 

```SQL
CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    cantidad INT
);

INSERT INTO productos (nombre, cantidad) VALUES
('Producto A', 10),
('Producto B', 15),
('Producto C', 20);
```

ejecución de la transacción

```SQL
-- Iniciar una transacción explícita
START TRANSACTION;

-- Obtener un bloqueo de lectura exclusiva en el producto con id = 1
SELECT cantidad  FROM productos WHERE id = 1;

-- Actualizar la cantidad del producto (restar 1)
UPDATE productos SET cantidad = cantidad - 1 WHERE id = 1;

-- Confirmar la transacción
COMMIT;
```


