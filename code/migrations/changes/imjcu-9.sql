-- liquibase formatted sql
-- changeset imjcu-9.sql
-- Generación de módulo de procesos con sus permisos correspondientes

/*
~~~~~~~~~~~~~~~~~~~~~~~ ESTRUCTURA DEL MÓDULO EN EL PANEL ADMINISTRATIVO  ~~~~~~~~~~~~~~~~~~~~~~~
- Administración
  |- Procesos

*/

WITH inserted_module_proceso AS (
  INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, orden, activo, idpadre)
  VALUES ('Administración', 'Procesos', NULL, 'pro', 'mdi-ray-start-vertex-end', NULL, 't', NULL)
  RETURNING id
),
inserted_usuario_dominio_modulo AS (
  INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo)
  SELECT 1, 1, id FROM inserted_module_proceso
  RETURNING *
)
SELECT * FROM inserted_module_proceso;
