--liquibase formatted sql
--changeset aicf:7
--Módulo para la plataforma de firma de correos

-- MÓDULO PADRE
WITH submodulos_insertados AS (
INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion, idpadre)
VALUES
    ('Gestión de firmas', 'Tablero', 'Tablero', 'fit', 'mdi-developer-board', true, NOW(), NOW(), NULL),
    ('Gestión de firmas', 'Firmas', 'Firmas', 'fif', 'mdi-pencil-box-outline', true, NOW(), NOW(), NULL),
    ('Gestión de firmas', 'Plantillas', 'Plantillas', 'fip', 'mdi-human-capacity-increase', true, NOW(), NOW(), NULL)
    RETURNING id, nombre, siglas
    ),
    permisos_insertados AS (
INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
SELECT
    'Ver Tablero', 'Ver información del Tablero', 'veta', id FROM submodulos_insertados WHERE nombre = 'Tablero'
UNION ALL
SELECT
    'Ver firmas', 'Ver información de las firmas', 'vefi', id FROM submodulos_insertados WHERE nombre = 'Firmas'
UNION ALL
SELECT
    'Ver plantillas', 'Ver información de las plantillas', 'vepl', id FROM submodulos_insertados WHERE nombre = 'Plantillas'
    RETURNING id
    ),
    usuario_dominio_modulo_insertado AS (
INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo, activo, fecha_creacion, fecha_modificacion)
SELECT
    1 as idusuario,
    1 as iddominio,
    id as idmodulo,
    '1' as activo,
    NOW() as fecha_creacion,
    NOW() as fecha_modificacion
FROM submodulos_insertados
    ),
    insert_permisos_submodulo_insertado AS (
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
SELECT
    1 as idperfil,
    id as idpermiso,
    '1' as activo,
    NOW() as fecha_creacion,
    NOW() as fecha_modificacion
FROM permisos_insertados
    )
SELECT 1; -- Finaliza la consulta principal

