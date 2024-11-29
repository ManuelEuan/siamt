--liquibase formatted sql
--changeset aicf:39
--Módulo para la credencialización - solicitud

WITH submodulos_insertado_credencializacion AS (
INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion, idpadre)
VALUES
    ('Credencialización', 'Solicitud', 'Solicitud', 'CREDSOL', 'mdi-note-check', true, NOW(), NOW(), NULL)
    RETURNING id
    ),
    permisos_submodulos_insertado_credencializacion AS (
INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
VALUES
    ('Ver solicitud', 'Ver información de la solicitud', 'VIEWSOL', (SELECT id FROM submodulos_insertado_credencializacion)),
    ('Editar solicitud', 'Editar información y configuración de la solicitud', 'EDITSOL', (SELECT id FROM submodulos_insertado_credencializacion)),
    ('Borrar solicitud', 'Activar o desactivar solicitud', 'DELETESOL', (SELECT id FROM submodulos_insertado_credencializacion))
    RETURNING id
    ),
    usuario_dominio_modulo_insertado_credencializacion AS (
INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo, activo, fecha_creacion, fecha_modificacion)
SELECT
    1 as idusuario,
    1 as iddominio,
    id as idmodulo,
    '1' as activo,
    NOW() as fecha_creacion,
    NOW() as fecha_modificacion
FROM submodulos_insertado_credencializacion
    ),
    insert_permisos_submodulo_insertado_credencializacion AS (
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
SELECT
    1 as idperfil,
    id as idpermiso,
    '1' as activo,
    NOW() as fecha_creacion,
    NOW() as fecha_modificacion
FROM permisos_submodulos_insertado_credencializacion
    )
SELECT 1; -- Finaliza la consulta principal