--liquibase formatted sql
--changeset aicf:3

-- ----------------------------
-- Records of modulo
-- ----------------------------

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