# Listado de deportes

- **Obtener la lista de deportes registrados en la base de datos, ordenados alfabéticamente.**

Requisitos:

- Mostrar el identificador y nombre del deporte.
- Ordenar los resultados por nombre ascendente.
  Tablas: sport

Conceptos: SELECT, ORDER BY.

```sql
SELECT
    id,
    sport_name
FROM sport
ORDER BY sport_name ASC;

```

```sql
SELECT
    s.id AS identificador,
    s.sport_name AS deporte
FROM sport AS s
ORDER BY deporte;
```

# Participantes por deporte

- **Obtener el número de participantes distintos registrados en cada deporte, considerando todos los juegos olímpicos disponibles.**

Requisitos:

- Mostrar el nombre del deporte y el total de participantes.
- Contar cada participante una sola vez por deporte, aunque compita en varios eventos.
- Ordenar de mayor a menor número de participantes.
  Tablas: sport, event, competitor_event.

Conceptos: INNER JOIN, COUNT(DISTINCT ...), GROUP BY, ORDER BY.

## Relaciona las tablas y agrupa los registros.

Es una solución natural para trabajar con agregaciones.

```sql
SELECT
    s.sport_name AS deporte,
    COUNT(DISTINCT ce.competitor_id)
        AS total_participantes
FROM sport AS s
INNER JOIN event AS e
    ON s.id = e.sport_id
INNER JOIN competitor_event AS ce
    ON e.id = ce.event_id
GROUP BY s.id, s.sport_name
ORDER BY total_participantes DESC;
```

```sql
SELECT
	q.deporte, count(q.deporte)
FROM
(SELECT
	DISTINCT
	s.sport_name as deporte,
    ce.competitor_id   AS identificador
FROM sport as s
INNER join event AS ev
	ON ev.sport_id = s.id
inner join competitor_event as  ce
	ON ce.event_id = ev.id ) AS q
GROUP BY q.deporte
```

## calcula el total para cada deporte mediante una subconsulta que hace referencia al deporte de la fila exterior.

Puede ser más fácil de entender inicialmente, pero el costo depende de cómo MySQL optimice la subconsulta.

```sql
SELECT
    s.sport_name AS deporte,
    (
        SELECT COUNT(DISTINCT ce.competitor_id)
        FROM event AS e
        INNER JOIN competitor_event AS ce
            ON e.id = ce.event_id
        WHERE e.sport_id = s.id
    ) AS total_participantes
FROM sport AS s
ORDER BY total_participantes DESC;
```

# Medallero por país en 2008

Intermedio

- **Generar el medallero de los Juegos Olímpicos de verano de 2008, agrupando las medallas por país o región.**

Requisitos:

- Mostrar el nombre del país.
- Calcular el total de medallas de oro, plata y bronce.
- Mostrar el total de medallas obtenidas.
- Ordenar por oro, plata y bronce, en orden descendente.
  Tablas: games, games_competitor, competitor_event, medal, person, person_region, noc_region.

Conceptos: múltiples JOIN, CASE WHEN, SUM, GROUP BY, filtros con WHERE.

#### Obtener las medallas por cada persona y país para verano 2008

```sql
SELECT
    nr.region_name AS pais,  m.medal_name
FROM games AS g
JOIN games_competitor AS gc
    ON g.id = gc.games_id
JOIN competitor_event AS ce
    ON gc.id = ce.competitor_id
JOIN medal AS m
    ON ce.medal_id = m.id
JOIN person AS p
    ON gc.person_id = p.id
JOIN person_region AS pr
    ON p.id = pr.person_id
JOIN noc_region AS nr
    ON pr.region_id = nr.id
WHERE g.games_year = 2008
  AND g.season = 'Summer'
  AND m.medal_name IN ('Gold', 'Silver', 'Bronze');
```

> Reto adicional:
> investigar cómo evitar el doble conteo de medallas en pruebas por equipos.

#### Uso de CASE

```SQL
CASE WHEN  [CONDICION] THEN [VALOR VERDADERO] ELSE [VALOR FALSO] END
```

**Modificar la selección**

```SQL
SELECT
    nr.region_name AS pais,  m.medal_name,
    CASE  WHEN m.medal_name='Gold' THEN 1 ELSE  0 END AS oro
```

Obtenemos

```SQL
SELECT
    nr.region_name AS pais,  m.medal_name,
    CASE  WHEN m.medal_name='Gold' THEN 1 ELSE  0 END AS oro
FROM games AS g
JOIN games_competitor AS gc
    ON g.id = gc.games_id
JOIN competitor_event AS ce
    ON gc.id = ce.competitor_id
JOIN medal AS m
    ON ce.medal_id = m.id
JOIN person AS p
    ON gc.person_id = p.id
JOIN person_region AS pr
    ON p.id = pr.person_id
JOIN noc_region AS nr
    ON pr.region_id = nr.id
WHERE g.games_year = 2008
  AND g.season = 'Summer'
  AND m.medal_name IN ('Gold', 'Silver', 'Bronze');
```

- Usa SUM(): suma unos y ceros para cada tipo de medalla.

```sql

SELECT
    nr.region_name AS pais,
    SUM(CASE WHEN m.medal_name = 'Gold'
             THEN 1 ELSE 0 END) AS oro,
    SUM(CASE WHEN m.medal_name = 'Silver'
             THEN 1 ELSE 0 END) AS plata,
    SUM(CASE WHEN m.medal_name = 'Bronze'
             THEN 1 ELSE 0 END) AS bronce,
```

La consulta queda:

```sql

SELECT
    nr.region_name AS pais,
    SUM(CASE WHEN m.medal_name = 'Gold'
             THEN 1 ELSE 0 END) AS oro,
    SUM(CASE WHEN m.medal_name = 'Silver'
             THEN 1 ELSE 0 END) AS plata,
    SUM(CASE WHEN m.medal_name = 'Bronze'
             THEN 1 ELSE 0 END) AS bronce,
    COUNT(*) AS total_medallas
FROM games AS g
JOIN games_competitor AS gc
    ON g.id = gc.games_id
JOIN competitor_event AS ce
    ON gc.id = ce.competitor_id
JOIN medal AS m
    ON ce.medal_id = m.id
JOIN person AS p
    ON gc.person_id = p.id
JOIN person_region AS pr
    ON p.id = pr.person_id
JOIN noc_region AS nr
    ON pr.region_id = nr.id
WHERE g.games_year = 2008
  AND g.season = 'Summer'
  AND m.medal_name IN ('Gold', 'Silver', 'Bronze')
GROUP BY nr.id, nr.region_name
ORDER BY oro DESC, plata DESC, bronce DESC;

```

---

- COUNT() cuenta los resultados no nulos. Como CASE no incluye ELSE, las filas que no coinciden devuelven NULL y no se cuentan.

```sql
SELECT
    nr.region_name AS pais,
    COUNT(CASE WHEN m.medal_name = 'Gold'
               THEN 1 END) AS oro,
    COUNT(CASE WHEN m.medal_name = 'Silver'
               THEN 1 END) AS plata,
    COUNT(CASE WHEN m.medal_name = 'Bronze'
               THEN 1 END) AS bronce
FROM games AS g
JOIN games_competitor AS gc
    ON g.id = gc.games_id
JOIN competitor_event AS ce
    ON gc.id = ce.competitor_id
JOIN medal AS m
    ON ce.medal_id = m.id
JOIN person AS p
    ON gc.person_id = p.id
JOIN person_region AS pr
    ON p.id = pr.person_id
JOIN noc_region AS nr
    ON pr.region_id = nr.id
WHERE g.games_year = 2008
  AND g.season = 'Summer'
  AND m.medal_name IN ('Gold', 'Silver', 'Bronze')
GROUP BY nr.id, nr.region_name
ORDER BY oro DESC, plata DESC, bronce DESC;

```

```SQL
SELECT
    nr.region_name AS pais,
    COUNT(CASE WHEN m.medal_name = 'Gold'
               THEN 1 END) AS oro,
    COUNT(CASE WHEN m.medal_name = 'Silver'
               THEN 1 END) AS plata,
    COUNT(CASE WHEN m.medal_name = 'Bronze'
               THEN 1 END) AS bronce,
    COUNT(CASE WHEN m.medal_name = 'Bronze'
               THEN 1 ELSE
          	   CASE WHEN m.medal_name = 'Silver'
          	   THEN 1 ELSE
          			CASE WHEN m.medal_name = 'Gold'
          	   		THEN 1
          			END
          	   END
          END) AS total
FROM games AS g
JOIN games_competitor AS gc
    ON g.id = gc.games_id
JOIN competitor_event AS ce
    ON gc.id = ce.competitor_id
JOIN medal AS m
    ON ce.medal_id = m.id
JOIN person AS p
    ON gc.person_id = p.id
JOIN person_region AS pr
    ON p.id = pr.person_id
JOIN noc_region AS nr
    ON pr.region_id = nr.id
WHERE g.games_year = 2008
  AND g.season = 'Summer'
  AND m.medal_name IN ('Gold', 'Silver', 'Bronze')
GROUP BY nr.id, nr.region_name
ORDER BY oro DESC, plata DESC, bronce DESC
```
