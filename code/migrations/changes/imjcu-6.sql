
-- liquibase formatted sql
-- changeset imjcu-6.sql
-- Generación de módulo de mantenimiento de unidades con sus permisos correspondientes

/*
~~~~~~~~~~~~~~~~~~~~~~~ ESTRUCTURA DEL MÓDULO                               ~~~~~~~~~~~~~~~~~~~~~~~
- Mantenimiento
  |- Unidades

*/

-- MÓDULO PADRE
WITH inserted_module_mto_unidades AS (
  INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, orden, activo, idpadre)
  VALUES ('Mantenimiento', 'Unidades', NULL, 'mto', 'mdi-tools', NULL, 't', NULL)
  RETURNING id
)
INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo)
VALUES (1, 1, (SELECT id FROM inserted_module_mto_unidades));
