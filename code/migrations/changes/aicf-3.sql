--liquibase formatted sql
--changeset aicf:3



-- ----------------------------
-- Records of modulo
-- ----------------------------
ALTER TABLE usuario.usuario
ALTER COLUMN correo TYPE character varying(50);

WITH perfil AS(
    INSERT INTO usuario.perfil (nombre, descripcion ,activo, fecha_creacion,fecha_modificacion)
    VALUES ('ACiudadana', 'Perfíl para visualizar los módulos relacionados a brindar información a ciudadanos', 't', now(), now()) RETURNING id
),
    users_added AS (
    INSERT INTO usuario.usuario (usuario, clave, nombre, apepat, apemat, correo, admin, activo, fecha_creacion,fecha_modificacion)
    VALUES
    ('coral.dominguez', encode(sha256('coral.dominguez'),'hex'), 'Coral', 'Dominguez', 'Leon', 'coral.dominguez@yucatan.gob.mx', 'f', 't', now(), now()),
    ('edward.soberanis', encode(sha256('edward.soberanis'),'hex'), 'Edward Augusto', 'Soberanis', 'Cabrera', 'edward.soberanis@yucatan.gob.mx', 'f', 't', now(), now()),
    ('francisco.zabaleta', encode(sha256('francisco.zabaleta'),'hex'), 'Francisco Alonso', 'Zabaleta', 'Arceo', 'francisco.zabaleta@yucatan.gob.mx', 'f', 't', now(), now())
    RETURNING id
),
module AS (
    SELECT id FROM usuario.modulo AS m WHERE m.activo = TRUE AND m.siglas = 'deb' LIMIT 1
),
 domain AS (
     SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1
 ),
usuario_dominio_modulo as(
    INSERT INTO usuario.usuario_dominio_modulo (iddominio, idmodulo, idusuario)
    SELECT domain.id, module.id, users_added.id FROM domain, module, users_added
),
usuario_dominio as(
    INSERT INTO usuario.usuario_dominio (iddominio, idusuario)
    SELECT domain.id, users_added.id FROM domain, users_added
)

INSERT INTO usuario.perfil_usuario (idperfil, idusuario)
SELECT perfil.id, users_added.id FROM perfil, users_added;

WITH perfil AS (
	SELECT id FROM usuario.perfil WHERE nombre='Admin' LIMIT 1
),  
modulo AS (
    SELECT id FROM usuario.modulo WHERE siglas = 'usr' LIMIT 1
), 
permisos AS (
	INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
	VALUES
		('Ver usuario', 'Ver información del usuario', 'veus', (SELECT id FROM modulo)),
		('Editar usuario', 'Editar información y configuración del usuario', 'edus', (SELECT id FROM modulo)),
		('Borrar usuario', 'Activar o desactivar usuario', 'bous', (SELECT id FROM modulo)),
		('Crear usuario', 'Crear nuevo usuario', 'crus', (SELECT id FROM modulo)),
		('Restablecer contraseña', 'Restablecer la contraseña del usuario', 'reco', (SELECT id FROM modulo)),
		('Cambiar contraseña', 'Cambiar la contraseña del usuario', 'caco', (SELECT id FROM modulo))
	RETURNING id
)

INSERT INTO usuario.perfil_permiso (idperfil, idpermiso)
SELECT perfil.id, permisos.id FROM perfil, permisos