--liquibase formatted sql
--changeset aicf:2



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

