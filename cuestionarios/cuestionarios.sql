CREATE TABLE `Pregunta` (
  `id` integer PRIMARY KEY,
  `texto` tinytext,
  `correcta` integer,
  `resp_1` tinytext,
  `resp_2` tinytext,
  `resp_3` tinytext,
  `resp_4` tinytext,
  `id_cuestionario` integer
);

CREATE TABLE `Cuestionario` (
  `id` integer PRIMARY KEY,
  `id_tema` integer,
  `titulo` varchar(40)
);

CREATE TABLE `Tema` (
  `id` integer PRIMARY KEY,
  `nombre` tinytext
);

CREATE TABLE `Respuesta` (
  `respuesta` integer,
  `id_usuario` integer,
  `id_pregunta` integer
);

CREATE TABLE `Usuario` (
  `id` integer PRIMARY KEY,
  `correo` varchar(40),
  `contrasena` varchar(20),
  `id_rol` integer
);

CREATE TABLE `Rol` (
  `id` integer PRIMARY KEY,
  `nombre` varchar(20)
);

ALTER TABLE `Pregunta` ADD FOREIGN KEY (`id_cuestionario`) REFERENCES `Cuestionario` (`id`);

ALTER TABLE `Cuestionario` ADD FOREIGN KEY (`id_tema`) REFERENCES `Tema` (`id`);

ALTER TABLE `Respuesta` ADD FOREIGN KEY (`id_usuario`) REFERENCES `Usuario` (`id`);

ALTER TABLE `Respuesta` ADD FOREIGN KEY (`id_pregunta`) REFERENCES `Pregunta` (`id`);

ALTER TABLE `Usuario` ADD FOREIGN KEY (`id_rol`) REFERENCES `Rol` (`id`);
