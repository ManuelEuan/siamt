/*

~~~~~~~~~~~~~~~~~~~~~~~ ESTRUCTURA DEL MÓDULO                               ~~~~~~~~~~~~~~~~~~~~~~~
- Procesos


*/
-- SELECT pg_terminate_backend(pid)
-- FROM pg_stat_activity
-- WHERE datname = 'siamt';


WITH inserted_module_proceso AS (
  INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, orden, activo, idpadre)
  VALUES (null, 'Procesos', NULL, 'pro', 'mdi-tools', NULL, 't', NULL)
  RETURNING id
),
inserted_usuario_dominio_modulo AS (
  INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo)
  SELECT 1, 1, id FROM inserted_module_proceso
  RETURNING *
)
SELECT * FROM inserted_module_proceso;
