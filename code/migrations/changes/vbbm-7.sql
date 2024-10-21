--liquibase formatted sql
--changeset vbbm:7
--Módulo para la plataforma de transportes

WITH submodulos_insertado_transporte AS (
INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion, idpadre)
VALUES
    ('Transportes', 'Empresas', 'Empresas', 'iie', 'mdi-domain', true, NOW(), NOW(), NULL)
     RETURNING id
),
    permisos_submodulos_insertado_transporte AS (
    INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
    VALUES 
        ('Ver empresa', 'Ver información de la empresa', 'veie', (SELECT id FROM submodulos_insertado_transporte)),
        ('Editar empresa', 'Editar información y configuración de la empresa', 'edie', (SELECT id FROM submodulos_insertado_transporte)),
        ('Borrar empresa', 'Activar o desactivar empresa', 'boie', (SELECT id FROM submodulos_insertado_transporte)),
        ('Crear empresa', 'Crear nueva empresa', 'crie', (SELECT id FROM submodulos_insertado_transporte))
    RETURNING id
),
    usuario_dominio_modulo_insertado_transporte AS (
INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo, activo, fecha_creacion, fecha_modificacion)
SELECT
    1 as idusuario,
    1 as iddominio,
    id as idmodulo,
    '1' as activo,
    NOW() as fecha_creacion,
    NOW() as fecha_modificacion
FROM submodulos_insertado_transporte
    ),
    insert_permisos_submodulo_insertado_tranporte AS (
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
SELECT
    1 as idperfil,
    id as idpermiso,
    '1' as activo,
    NOW() as fecha_creacion,
    NOW() as fecha_modificacion
FROM permisos_submodulos_insertado_transporte
    )
SELECT 1; -- Finaliza la consulta principal