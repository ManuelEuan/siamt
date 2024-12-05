--liquibase formatted sql
--changeset aicf:40

/*
~~~~~~~~~~~~~~~~~~~~~~~ ESTRUCTURA DEL MÓDULO DE MANTENIMIENTOS ~~~~~~~~~~~~~~~~~~~~~~~
- Mantenimientos
  |- Planes
  |- Actividades
  |- Preventivos
  |- Correctivos
  |- Registro de incidentes
*/

WITH m_modulo AS (
    INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, orden, activo, idpadre, configuracion, fecha_creacion, fecha_modificacion)
        VALUES ('Mantenimientos', 'Planes', NULL, 'mto_pla', 'mdi-calendar-clock', 1, true, NULL, '{}', NOW(), NOW()),
               ('Mantenimientos', 'Actividades', NULL, 'mto_act', 'mdi-format-list-bulleted', 2, true, NULL, '{}', NOW(), NOW()),
               ('Mantenimientos', 'Preventivos', NULL, 'mto_pre', 'mdi-calendar-check', 3, true, NULL, '{}', NOW(), NOW()),
               ('Mantenimientos', 'Correctivos', NULL, 'mto_cor', 'mdi-hammer-wrench', 4, true, NULL, '{}', NOW(), NOW()),
               ('Mantenimientos', 'Registro de incidentes', NULL, 'mto_rin', 'mdi-clipboard-alert-outline', 5, true, NULL, '{}', NOW(), NOW())
        RETURNING id, siglas),
     m_usuario_dominio_modulo AS (
         INSERT INTO siamt.usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo, activo, fecha_creacion, fecha_modificacion)
             SELECT 1           AS idusuario,
                    1           AS iddominio,
                    m_modulo.id AS idmodulo,
                    true        AS activo,
                    NOW()       AS fecha_creacion,
                    NOW()       AS fecha_modificacion
             FROM m_modulo),
     m_permiso AS (
         INSERT INTO usuario.permiso (nombre, descripcion, siglas, activo, fecha_creacion, fecha_modificacion, idmodulo)
             VALUES ('Ver planes', 'Ver planes de mantenimiento', 'vmpl', true, NOW(), NOW(), (SELECT m_modulo.id FROM m_modulo WHERE m_modulo.siglas = 'mto_pla')),
                    ('Crear planes', 'Crear plan de mantenimiento', 'cmpl', true, NOW(), NOW(), (SELECT m_modulo.id FROM m_modulo WHERE m_modulo.siglas = 'mto_pla')),
                    ('Editar planes', 'Editar plan de mantenimiento', 'empl', true, NOW(), NOW(), (SELECT m_modulo.id FROM m_modulo WHERE m_modulo.siglas = 'mto_pla')),
                    ('Ver actividades', 'Ver actividades de mantenimiento', 'vmac', true, NOW(), NOW(), (SELECT m_modulo.id FROM m_modulo WHERE m_modulo.siglas = 'mto_act')),
                    ('Crear actividades', 'Crear actividad de mantenimiento', 'cmac', true, NOW(), NOW(), (SELECT m_modulo.id FROM m_modulo WHERE m_modulo.siglas = 'mto_act')),
                    ('Editar actividades', 'Editar actividad de mantenimiento', 'emac', true, NOW(), NOW(), (SELECT m_modulo.id FROM m_modulo WHERE m_modulo.siglas = 'mto_act')),
                    ('Ver preventivos', 'Ver mantenimientos preventivos', 'vmpr', true, NOW(), NOW(), (SELECT m_modulo.id FROM m_modulo WHERE m_modulo.siglas = 'mto_pre')),
                    ('Crear preventivos', 'Crear mantenimiento preventivo', 'cmpr', true, NOW(), NOW(), (SELECT m_modulo.id FROM m_modulo WHERE m_modulo.siglas = 'mto_pre')),
                    ('Editar preventivos', 'Editar mantenimiento preventivo', 'empr', true, NOW(), NOW(), (SELECT m_modulo.id FROM m_modulo WHERE m_modulo.siglas = 'mto_pre')),
                    ('Ver correctivos', 'Ver mantenimientos correctivos', 'vmcr', true, NOW(), NOW(), (SELECT m_modulo.id FROM m_modulo WHERE m_modulo.siglas = 'mto_cor')),
                    ('Crear correctivos', 'Crear mantenimiento correctivo', 'cmcr', true, NOW(), NOW(), (SELECT m_modulo.id FROM m_modulo WHERE m_modulo.siglas = 'mto_cor')),
                    ('Editar correctivos', 'Editar mantenimiento correctivo', 'emcr', true, NOW(), NOW(), (SELECT m_modulo.id FROM m_modulo WHERE m_modulo.siglas = 'mto_cor')),
                    ('Ver registros incidentes', 'Ver registros de incidentes', 'vmri', true, NOW(), NOW(), (SELECT m_modulo.id FROM m_modulo WHERE m_modulo.siglas = 'mto_rin')),
                    ('Crear registro incidente', 'Crear registro de incidente', 'cmri', true, NOW(), NOW(), (SELECT m_modulo.id FROM m_modulo WHERE m_modulo.siglas = 'mto_rin')),
                    ('Editar registro incidente', 'Editar registro de incidente', 'emri', true, NOW(), NOW(), (SELECT m_modulo.id FROM m_modulo WHERE m_modulo.siglas = 'mto_rin'))
             RETURNING id),
     m_perfil_permiso AS (
         INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
             SELECT 1     AS idperfil,
                    id    AS idpermiso,
                    true  AS activo,
                    NOW() AS fecha_creacion,
                    NOW() AS fecha_modificacion
             FROM m_permiso)
SELECT 1;
