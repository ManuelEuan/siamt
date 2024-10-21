--liquibase formatted sql
--changeset aicf:22
--usuario y perfil admin de operadores


WITH ruser AS (
    SELECT id FROM usuario.usuario AS u WHERE u.usuario = 'master' AND u.activo = TRUE LIMIT 1
    ),
    domain AS (
SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1
    ),
    perfil AS (
INSERT INTO usuario.perfil (nombre, descripcion, activo, fecha_creacion, fecha_modificacion)
VALUES ('Admin Operadores', 'Perfíl para visualizar los módulos relacionados a Operadores', 't', now(), now())
    RETURNING id
    ),
    users_added AS (
INSERT INTO usuario.usuario (usuario, clave, nombre, apepat, apemat, correo, admin, activo, fecha_creacion, fecha_modificacion)
VALUES ('admin.operadores', encode(sha256('admin.operadores'), 'hex'), 'Administrador', 'Operadores', '', '', 't', 't', now(), now())
    RETURNING id
    ),
    modules AS (
SELECT id FROM usuario.modulo
WHERE siglas IN ('op_rep', 'op_gta', 'op_adm', 'op_ani', 'op_ase', 'op_cli', 'op_cla', 'op_cps', 'op_cnu', 'op_cof', 'op_cap', 'op_cte', 'op_cpr', 'op_csi', 'op_vin')
  AND activo = TRUE
    ),
    usuario_dominio_modulo AS (
INSERT INTO usuario.usuario_dominio_modulo (iddominio, idmodulo, idusuario)
SELECT domain.id, modules.id, users_added.id FROM domain, modules, users_added
    ),
    usuario_dominio AS (
INSERT INTO usuario.usuario_dominio (iddominio, idusuario)
SELECT domain.id, users_added.id FROM domain, users_added
    ),
    perfil_usuario AS (
INSERT INTO usuario.perfil_usuario (idperfil, idusuario)
SELECT perfil.id, users_added.id FROM perfil, users_added
    ),
    permisos AS (
SELECT id FROM usuario.permiso WHERE siglas IN ('seop', 'reop', 'niop', 'taop', 'adop', 'clop', 'laop', 'psop', 'nuop', 'ofop', 'caop', 'teop', 'prop', 'siop', 'viop')
    ),
    perfil_permisos AS (
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso)
SELECT perfil.id, permisos.id FROM perfil, permisos
    ),
    aplicacion AS (
SELECT iid FROM usuario.aplicacion WHERE txtnombre = 'EGIT' LIMIT 1
    )

-- Inserción en usuario.usuario_aplicacion
INSERT INTO usuario.usuario_aplicacion (iidusuario, iidaplicacion, bactivo, dtfecha_creacion, dtfecha_modificacion)
SELECT users_added.id, aplicacion.iid, true, now(), now()
FROM users_added, aplicacion;