--liquibase formatted sql
--changeset abc:1

-- ----------------------------
-- Records of modulo
-- ----------------------------

WITH ruser AS (
    SELECT id FROM usuario.usuario AS u WHERE u.usuario = 'master' AND u.activo = TRUE LIMIT 1
),
module AS (
    INSERT INTO usuario.modulo (seccion,nombre,descripcion,siglas,icono,orden,activo,idpadre,fecha_creacion,fecha_modificacion)
    VALUES ('Administrativo','Usuarios', NULL, 'usr', 'mdi-human-capacity-increase', NULL, 't', NULL, now(), now()) RETURNING id
),
domain AS (
    SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1
)

INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo)
SELECT ruser.id, domain.id, module.id FROM ruser, domain, module;
