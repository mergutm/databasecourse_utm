# Datos para consulta

## Creación de tablas
```sql
-- Crear la tabla de departamentos
CREATE TABLE departamentos (
    id_depto INT PRIMARY KEY,
    nombre_depto VARCHAR(50) NOT NULL
);

-- Crear la tabla de empleados
CREATE TABLE empleados (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    id_depto INT,
    FOREIGN KEY (id_depto) REFERENCES departamentos(id_depto)
);

-- Crear la tabla de productos
CREATE TABLE productos (
    prod_id INT PRIMARY KEY,
    nombre_prod VARCHAR(50) NOT NULL,
    id_depto INT,
    FOREIGN KEY (id_depto) REFERENCES departamentos(id_depto)
);
```

## Inserción de datos.
```sql
-- Insertar datos en la tabla de departamentos
INSERT INTO departamentos (id_depto, nombre_depto) VALUES
(1, 'Recursos Humanos'),
(2, 'Tecnología de la Información'),
(3, 'Finanzas'),
(4, 'Marketing');

-- Insertar datos en la tabla de empleados
INSERT INTO empleados (id_empleado, nombre, salario, id_depto) VALUES
(101, 'Juan Perez', 50000.00, 2),
(102, 'Maria Gomez', 60000.00, 1),
(103, 'Carlos Lopez', 55000.00, 3),
(104, 'Ana Martinez', 70000.00, 2),
(105, 'Luis Rodriguez', 45000.00, 4);

-- Insertar datos en la tabla de productos
INSERT INTO productos (prod_id, nombre_prod, id_depto) VALUES
(201, 'Software de Gestión', 2),
(202, 'Plan de Beneficios', 1),
(203, 'Reporte Financiero', 3),
(204, 'Campaña Publicitaria', 4);

```

# Ejemplos con cuantificadores universales.

## Obtener los nombres de los departamentos en los que todos los empleados tienen un salario mayor a 50000

Consulta usando cálculo de tuplas:

```
{ d.nombre_depto | departamentos(d) 
        ∧ ∀ e (empleados(e) 
                ∧ e.id_depto = d.id_depto ⇒ e.salario > 50000) }
```


Antes: consulta para mostrar departamentos con al menos un empleado que NO cumpla que su salario sea mayor a 50000
```sql
SELECT 1, d.nombre_depto
    FROM empleados e, departamentos d
    WHERE e.id_depto = d.id_depto
      AND e.salario <= 50000
```

La salida obtenida es:
|  1 | nombre_depto |
| -------- | ----------|
|  1 | Tecnología de la Información |
|  1 |  Marketing  |

Aplicando la idea de la consulta anterior, la nueva consulta queda de la siguiente manera:

```sql
SELECT d.nombre_depto
FROM departamentos d
WHERE NOT EXISTS (
    SELECT 1
    FROM empleados e
    WHERE e.id_depto = d.id_depto
      AND e.salario <= 50000
);
```

La salida obtenida es:
| nombre_depto |
| ----------|
| Recursos humanos |
|  Finanzas  |

# 



```sql

```


```sql

```


```sql

```

