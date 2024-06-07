
-- changeset imjcu-3.sql
-- Generación de módulo de debitaciones con sus permisos correspondientes

/*
~~~~~~~~~~~~~~~~~~~~~~~ ESTRUCTURA DEL MÓDULO EN EL PANEL ADMINISTRATIVO  ~~~~~~~~~~~~~~~~~~~~~~~
- Administración
  |- Debitaciones

*/

-- MÓDULO PADRE
WITH inserted_module_debitaciones AS (
  INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, orden, activo, idpadre)
  VALUES ('Administración', 'Debitaciones', NULL, 'deb', 'mdi-credit-card-clock-outline', NULL, 't', NULL)
  RETURNING id
)
INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo)
VALUES (1, 1, (SELECT id FROM inserted_module_debitaciones));

