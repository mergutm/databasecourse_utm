## 1. Escenario

Una universidad registra las inscripciones de sus estudiantes. Cada estudiante puede inscribirse en varios cursos. 
Se consideran las siguientes reglas del negocio:

- Cada matrícula identifica a un único estudiante.
- Cada código de curso identifica a un único curso.
- En este escenario, cada docente imparte un solo curso durante el periodo.
- Un estudiante puede cursar un curso con un docente determinado.
- La calificación corresponde a la inscripción del estudiante en el curso.
- Un curso puede tener varios estudiantes.
- Un docente puede tener varios estudiantes inscritos en el curso que imparte.

> **Importante:** La regla “cada docente imparte un solo curso” se establece deliberadamente para construir un caso que permita demostrar la diferencia entre 3FN y FNBC.

## 2. Conceptos que se utilizarán

###  Atributo, tupla y relación

- **Relación:** tabla que representa un conjunto de datos, por ejemplo `INSCRIPCION`.
- **Atributo:** columna de una relación, por ejemplo `Matricula` o `CodCurso`.
- **Tupla:** fila de una relación.
- **Dominio:** conjunto de valores permitidos para un atributo. Por ejemplo, `Calificacion` puede admitir valores numéricos entre 0 y 100.

###  Dependencia funcional

Una dependencia funcional `X → Y` significa que, para cada valor de `X`, existe como máximo un valor correspondiente de `Y`. En otras palabras, `X` determina `Y`.

Ejemplos del escenario:

- `Matricula → NombreAlumno, Carrera`
- `CodCurso → NombreCurso, Creditos`
- `IdDocente → CodCurso`
- `(Matricula, CodCurso) → IdDocente, Calificacion`

La expresión `(Matricula, CodCurso)` representa un conjunto de dos atributos que, juntos, determinan los atributos indicados.

### Clave superpuesta, clave candidata y clave primaria

- **Superclave:** conjunto de uno o más atributos que identifica de manera única cada tupla. **Puede contener atributos innecesarios**.
- **Clave candidata:** superclave mínima; si se elimina cualquiera de sus atributos, deja de identificar de forma única las tuplas.
- **Clave primaria:** clave candidata seleccionada para identificar oficialmente las filas.
- **Clave compuesta:** clave formada por más de un atributo.
- **Clave alterna:** clave candidata que no fue seleccionada como primaria.

Para encontrar claves candidatas se utilizan las dependencias funcionales y el **cierre de atributos**. 

> **El cierre de `X`**, escrito `X+`, es el conjunto de atributos que pueden determinarse a partir de `X` aplicando repetidamente las dependencias funcionales.

### Atributos primos y no primos

- **Atributo primo:** pertenece al menos a una clave candidata.
- **Atributo no primo:** no pertenece a ninguna clave candidata.

### Elementos necesarios para normalizar

Antes de descomponer una tabla, se debe identificar:

1. Las reglas del negocio.
2. Los atributos y sus dominios.
3. Las claves candidatas y la clave primaria.
4. Las dependencias funcionales.
5. Los atributos primos y no primos.
6. Las dependencias parciales y transitivas.
7. Las anomalías de inserción, actualización y eliminación.
8. Si la descomposición conserva la información (unión sin pérdida) y, cuando sea posible, las dependencias funcionales.


---

## 3. Situación inicial: tabla sin normalizar (UNF)

La universidad guarda varios cursos dentro de una misma celda para cada estudiante. Esto dificulta consultar, actualizar y validar la información.

### Tabla `REGISTRO_UNF`

| Matricula | NombreAlumno | Carrera | CursosInscritos |
|---|---|---|---|
| A001 | Ana López | Sistemas | C101 / Bases de datos / D01 / Laura / 92; C102 / Redes / D02 / Mario / 88 |
| A002 | Bruno Díaz | Sistemas | C101 / Bases de datos / D01 / Laura / 85 |
| A003 | Carla Ruiz | Diseño | C103 / Interfaces / D03 / Elena / 95; C102 / Redes / D02 / Mario / 90 |

En `CursosInscritos` se almacenan grupos repetidos de datos: código, nombre del curso, docente, nombre del docente y calificación.

### Problemas detectados

- **No hay atomicidad:** una celda contiene varios valores.
- **Consulta compleja:** buscar a todos los estudiantes de `C102` exige interpretar el contenido de una cadena.
- **Actualización propensa a errores:** cambiar el nombre de un curso puede requerir modificar muchas cadenas.
- **Inserción limitada:** no se puede registrar fácilmente un curso si todavía no tiene estudiantes.
- **Eliminación peligrosa:** borrar la última inscripción de un curso podría hacer que se pierda también la única copia de sus datos.

---

## 4. Primera Forma Normal (1FN)

### Regla de 1FN

Una relación está en primera forma normal cuando:

- Cada celda contiene un solo valor atómico para el dominio definido.
- No existen grupos repetidos dentro de una misma fila.
- Cada fila puede identificarse de manera única.

> **Nota**: La atomicidad depende del uso que se dará al dato. Por ejemplo, si se necesita buscar por nombre y apellido por separado, conviene almacenar ambos en atributos distintos.

### Transformación

Se separa cada curso inscrito en una fila. Para esta etapa se utiliza la relación plana `INSCRIPCION_1FN`.

### Tabla `INSCRIPCION_1FN`

| Matricula | NombreAlumno | Carrera | CodCurso | NombreCurso | IdDocente | NombreDocente | Calificacion |
|---|---|---|---|---|---|---|---:|
| A001 | Ana López | Sistemas | C101 | Bases de datos | D01 | Laura | 92 |
| A001 | Ana López | Sistemas | C102 | Redes | D02 | Mario | 88 |
| A002 | Bruno Díaz | Sistemas | C101 | Bases de datos | D01 | Laura | 85 |
| A003 | Carla Ruiz | Diseño | C103 | Interfaces | D03 | Elena | 95 |
| A003 | Carla Ruiz | Diseño | C102 | Redes | D02 | Mario | 90 |

Ahora cada celda contiene un valor individual y cada inscripción ocupa una fila.

### Clave e identificación de dependencias

Para este ejemplo, las reglas establecen:

- `Matricula → NombreAlumno, Carrera`
- `CodCurso → NombreCurso`
- `IdDocente → NombreDocente, CodCurso`
- `(Matricula, CodCurso) → IdDocente, Calificacion`

La clave candidata de `INSCRIPCION_1FN` es `(Matricula, CodCurso)`, bajo las reglas definidas. La clave primaria elegida será esa **clave compuesta**.

**¿Por qué?** `Matricula` por sí sola no identifica una fila porque un estudiante puede inscribirse en varios cursos. `CodCurso` tampoco identifica una fila porque un curso puede tener varios estudiantes. Juntos identifican una inscripción.

### ¿Qué no resuelve 1FN?

Aunque los valores ya son atómicos, los datos de estudiante y curso se repiten en varias filas. Esto produce redundancia y anomalías.

**Pregunta:** ¿Por qué `Matricula` no puede ser la clave primaria de esta tabla?.

---

## 5. Segunda Forma Normal (2FN)

### Regla de 2FN

Una relación está en segunda forma normal cuando:

1. Ya cumple 1FN.
2. Cada atributo no primo depende de la clave candidata completa, **no solamente de una parte de una clave compuesta.**

Una **dependencia parcial** aparece cuando un atributo no primo depende de una parte de una clave compuesta.

En `INSCRIPCION_1FN`, la clave candidata es `(Matricula, CodCurso)`:

- `Matricula → NombreAlumno, Carrera`: depende solo de una parte de la clave.
- `CodCurso → NombreCurso`: depende solo de otra parte de la clave.

Por lo tanto, hay dependencias parciales y se viola 2FN.

### Descomposición para 2FN

Se separan los datos que dependen únicamente de la matrícula, los que dependen únicamente del curso y los que describen la inscripción.

#### Tabla `ESTUDIANTE_2FN`

| Matricula (PK) | NombreAlumno | Carrera |
|---|---|---|
| A001 | Ana López | Sistemas |
| A002 | Bruno Díaz | Sistemas |
| A003 | Carla Ruiz | Diseño |

#### Tabla `CURSO_2FN`

| CodCurso (PK) | NombreCurso |
|---|---|
| C101 | Bases de datos |
| C102 | Redes |
| C103 | Interfaces |

#### Tabla `INSCRIPCION_2FN`

| Matricula (PK, FK) | CodCurso (PK, FK) | IdDocente | NombreDocente | Calificacion |
|---|---|---|---|---:|
| A001 | C101 | D01 | Laura | 92 |
| A001 | C102 | D02 | Mario | 88 |
| A002 | C101 | D01 | Laura | 85 |
| A003 | C103 | D03 | Elena | 95 |
| A003 | C102 | D02 | Mario | 90 |

La clave primaria de `INSCRIPCION_2FN` es `(Matricula, CodCurso)`. `Matricula` y `CodCurso` son además claves foráneas hacia `ESTUDIANTE_2FN` y `CURSO_2FN`.

### Resultado de 2FN

- Los datos del estudiante se guardan una sola vez por matrícula.
- Los datos del curso se guardan una sola vez por código.
- La calificación y el docente asignado permanecen asociados a la inscripción.

**Observación:** todavía se repite `NombreDocente`. Además, la dependencia `IdDocente → NombreDocente` no depende directamente de la clave de inscripción. Se resolverá en la siguiente etapa.


---

## 6. Tercera Forma Normal (3FN)

### Regla de 3FN

Una relación está en tercera forma normal cuando:

1. Ya cumple 2FN.
2. No existen dependencias transitivas de atributos no primos respecto de una clave candidata.

Una forma habitual de expresar la condición es: para toda dependencia funcional no trivial `X → A`, se cumple al menos una de estas condiciones:

- `X` es superclave, o
- `A` es un atributo primo.

Una **dependencia transitiva** ocurre cuando la clave determina un atributo que, a su vez, determina otro atributo no primo.

En `INSCRIPCION_2FN` tenemos:

- `(Matricula, CodCurso) → IdDocente`
- `IdDocente → NombreDocente`

Por transitividad, la clave de inscripción determina `NombreDocente` a través de `IdDocente`. `NombreDocente` no debe almacenarse repetidamente en la tabla de inscripciones.

### Descomposición para 3FN

Se crea una tabla para los docentes y se conserva su identificador en la inscripción.

#### Tabla `DOCENTE_3FN`

| IdDocente (PK) | NombreDocente |
|---|---|
| D01 | Laura |
| D02 | Mario |
| D03 | Elena |

#### Tabla `INSCRIPCION_3FN`

| Matricula (PK, FK) | CodCurso (PK, FK) | IdDocente (FK) | Calificacion |
|---|---|---|---:|
| A001 | C101 | D01 | 92 |
| A001 | C102 | D02 | 88 |
| A002 | C101 | D01 | 85 |
| A003 | C103 | D03 | 95 |
| A003 | C102 | D02 | 90 |

Se mantienen las tablas `ESTUDIANTE_2FN` y `CURSO_2FN`, que ya no tienen dependencias parciales ni transitivas dentro de sus relaciones. En el esquema final pueden renombrarse como `ESTUDIANTE` y `CURSO`.

### Resultado de 3FN

- Los datos del docente se almacenan en una sola tabla.
- La inscripción conserva el identificador del docente, no su nombre.
- Se reduce la redundancia y el riesgo de inconsistencias.

Sin embargo, todavía existe una dependencia funcional que permite demostrar una violación de FNBC. Para estudiarla se observa la relación:

`INSCRIPCION(Matricula, CodCurso, IdDocente, Calificacion)`

con estas dependencias:

- `(Matricula, CodCurso) → IdDocente, Calificacion`
- `IdDocente → CodCurso`

La segunda dependencia procede de la regla del escenario: cada docente imparte un solo curso durante el periodo.

---

## 7. Claves candidatas y atributos primos en la relación de 3FN

Analicemos la relación:

`R(Matricula, CodCurso, IdDocente, Calificacion)`

Dependencias funcionales:

- `F1: (Matricula, CodCurso) → IdDocente, Calificacion`
- `F2: IdDocente → CodCurso`

###  Primera clave candidata

Calcular el cierre de `(Matricula, CodCurso)`:

1. Inicio: `{Matricula, CodCurso}`.
2. Por **F1** se agrega `IdDocente` y `Calificacion`.
3. El cierre contiene todos los atributos.

Por tanto:

`(Matricula, CodCurso)+ = {Matricula, CodCurso, IdDocente, Calificacion}`

Es una superclave. Como ninguno de sus dos atributos puede eliminarse y seguir identificando la inscripción, es una clave candidata.

### Segunda clave candidata

Calculamos el cierre de `(Matricula, IdDocente)`:

1. Inicio: `{Matricula, IdDocente}`.
2. Por F2 agregamos `CodCurso`.
3. Con `Matricula` y `CodCurso`, por F1 agregamos `Calificacion`.
4. El cierre contiene todos los atributos.

Por tanto:

`(Matricula, IdDocente)+ = {Matricula, IdDocente, CodCurso, Calificacion}`

También es una clave candidata.

### Resultado: claves y atributos primos

| Elemento | Resultado |
|---|---|
| Clave candidata 1 | `(Matricula, CodCurso)` |
| Clave candidata 2 | `(Matricula, IdDocente)` |
| Atributos primos | `Matricula`, `CodCurso`, `IdDocente` |
| Atributo no primo | `Calificacion` |

Los tres atributos que aparecen en al menos una clave candidata son **primos**. `Calificacion` es no primo porque no pertenece a ninguna clave candidata.

### ¿Por qué esta relación cumple 3FN?

Revisemos las dependencias:

- `(Matricula, CodCurso) → IdDocente, Calificacion`: el determinante es una clave candidata y, por tanto, una superclave.
- `IdDocente → CodCurso`: `IdDocente` no es superclave, pero `CodCurso` es atributo primo porque pertenece a las claves candidatas.

La segunda dependencia satisface la condición de 3FN por tener un atributo primo en el lado derecho. Por eso esta relación puede cumplir 3FN y, al mismo tiempo, no cumplir FNBC.

---

## 9. Forma Normal de Boyce-Codd (FNBC o BCNF)

### Regla de FNBC

Una relación está en FNBC cuando, para toda dependencia funcional no trivial `X → Y`, `X` es una superclave.

Es una condición más estricta que 3FN. En particular, FNBC no permite la excepción de 3FN que admite un atributo primo en el lado derecho.

### Detección de la violación

En la relación:

`R(Matricula, CodCurso, IdDocente, Calificacion)`

tenemos:

`IdDocente → CodCurso`

Pero `IdDocente` no es superclave: su cierre es `{IdDocente, CodCurso}` y no incluye `Matricula` ni `Calificacion`.

Por lo tanto, la relación viola FNBC.

### Descomposición para FNBC

Se descompone la relación en dos:

#### Tabla `DOCENTE_CURSO`

| IdDocente (PK) | CodCurso |
|---|---|
| D01 | C101 |
| D02 | C102 |
| D03 | C103 |

#### Tabla `INSCRIPCION_DOCENTE`

| Matricula (PK) | IdDocente (PK, FK) | Calificacion |
|---|---|---:|
| A001 | D01 | 92 |
| A001 | D02 | 88 |
| A002 | D01 | 85 |
| A003 | D03 | 95 |
| A003 | D02 | 90 |

Ahora `IdDocente` es clave de `DOCENTE_CURSO`, y `(Matricula, IdDocente)` es clave de `INSCRIPCION_DOCENTE`.

Se conserva también la tabla `DOCENTE` para los datos descriptivos del docente, si se desea mantener el nombre separado:

#### Tabla `DOCENTE`

| IdDocente (PK) | NombreDocente |
|---|---|
| D01 | Laura |
| D02 | Mario |
| D03 | Elena |

La tabla `DOCENTE_CURSO` puede usar `IdDocente` como clave primaria y como clave foránea hacia `DOCENTE`. `CodCurso` puede ser clave foránea hacia `CURSO`.

### ¿Por qué la descomposición es válida?

- En `DOCENTE_CURSO`, la dependencia `IdDocente → CodCurso` tiene como determinante una clave.
- En `INSCRIPCION_DOCENTE`, la clave es `(Matricula, IdDocente)`; la calificación depende de la inscripción completa.
- La descomposición permite reconstruir las inscripciones junto con el curso mediante la unión de `INSCRIPCION_DOCENTE` y `DOCENTE_CURSO` por `IdDocente`.

> **Nota sobre el modelo:** esta descomposición refleja exactamente la regla del ejemplo actual en el  que cada docente imparte un único curso en el periodo. Si un docente pudiera impartir varios cursos, la dependencia `IdDocente → CodCurso` no sería válida y habría que revisar las claves y la descomposición.

---

## 10. Resumen visual de la secuencia

| Etapa | Estructura principal | Problema que se resuelve |
|---|---|---|
| Sin normalizar | `REGISTRO_UNF` | Grupos repetidos y celdas con varios valores |
| 1FN | `INSCRIPCION_1FN` | Valores no atómicos y grupos repetidos |
| 2FN | `ESTUDIANTE`, `CURSO`, `INSCRIPCION` | Dependencias parciales de una clave compuesta |
| 3FN | `ESTUDIANTE`, `CURSO`, `DOCENTE`, `INSCRIPCION` | Dependencias transitivas |
| FNBC | `ESTUDIANTE`, `CURSO`, `DOCENTE`, `DOCENTE_CURSO`, `INSCRIPCION_DOCENTE` | Dependencias cuyo determinante no es superclave |

### Esquema final sugerido

```text
ESTUDIANTE
----------
PK Matricula
   NombreAlumno
   Carrera

CURSO
-----
PK CodCurso
   NombreCurso

DOCENTE
-------
PK IdDocente
   NombreDocente

DOCENTE_CURSO
-------------
PK, FK IdDocente
FK     CodCurso

INSCRIPCION_DOCENTE
-------------------
PK, FK Matricula
PK, FK IdDocente
       Calificacion
```

Relaciones:

- `INSCRIPCION_DOCENTE.Matricula` referencia `ESTUDIANTE.Matricula`.
- `INSCRIPCION_DOCENTE.IdDocente` referencia `DOCENTE_CURSO.IdDocente`.
- `DOCENTE_CURSO.IdDocente` referencia `DOCENTE.IdDocente`.
- `DOCENTE_CURSO.CodCurso` referencia `CURSO.CodCurso`.
