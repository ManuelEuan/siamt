-- liquibase formatted sql
-- changeset imjcu-7.sql
-- Generación de módulo de Perfiles con sus permisos correspondientes

/*
~~~~~~~~~~~~~~~~~~~~~~~ TODOS LOS PERMISOS EN MÓDULO DE PERFILES (ins)   ~~~~~~~~~~~~~~~~~~~~~~~

****** SUBMÓDULO CARGA DE TRABAJO
- VER PERFIL                                 (vepe)
- EDITAR PERFIL                              (edpe)
- BORRAR PERFIL                              (bope)
- CREAR PERFIL                               (crpe)

~~~~~~~~~~~~~~~~~~~~~~~ ESTRUCTURA DEL MÓDULO                               ~~~~~~~~~~~~~~~~~~~~~~~
- Administración
  |- Perfiles
*/

WITH modulo_perfiles AS (
    INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion)
    VALUES 
        ('Administración', 'Perfiles', NULL, 'per', 'mdi-human-capacity-increase', '1', NOW(), NOW())
    RETURNING id
),
permiso_perfiles AS (
    INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
    VALUES 
        ('Ver perfil', 'Ver información del perfil', 'vepe', (SELECT id FROM modulo_perfiles)),
        ('Editar perfil', 'Editar información y configuración del perfil', 'edpe', (SELECT id FROM modulo_perfiles)),
        ('Borrar perfil', 'Activar o desactivar perfil', 'bope', (SELECT id FROM modulo_perfiles)),
        ('Crear perfil', 'Crear nuevo perfil', 'crpe', (SELECT id FROM modulo_perfiles))
    RETURNING id
),
usuario_dominio_modulo_perfiles AS (
    INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo, activo, fecha_creacion, fecha_modificacion)
    SELECT 
        1 as idusuario,
        1 as iddominio,
        id as idmodulo,
        '1' as activo,
        NOW() as fecha_creacion,
        NOW() as fecha_modificacion
    FROM modulo_perfiles
)
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
SELECT 
    1 as idperfil,
    id as idpermiso,
    '1' as activo,
    NOW() as fecha_creacion,
    NOW() as fecha_modificacion
FROM permiso_perfiles;
