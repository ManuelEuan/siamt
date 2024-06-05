-- ----------------------------
-- Records of usuario
-- ----------------------------

-- Desactivar restricciones de clave externa temporalmente
-- ALTER TABLE perfil_usuario DROP CONSTRAINT fk_usuario_id;

-- Truncar las tablas con la opción CASCADE
TRUNCATE TABLE usuario.usuario CASCADE;
TRUNCATE TABLE usuario.perfil CASCADE;
TRUNCATE TABLE usuario.perfil_usuario CASCADE;
TRUNCATE TABLE usuario.usuario_dominio CASCADE;

-- Reactivar la restricción de clave externa
-- ALTER TABLE perfil_usuario ADD CONSTRAINT fk_usuario_id FOREIGN KEY (id_usuario) REFERENCES usuario.usuario(id) ON DELETE CASCADE;


INSERT INTO "usuario"."usuario" VALUES (1, 'master', 'fc613b4dfd6736a7bd268c8a0e74ed0d1c04a959f59dd74ef2874983fd443fc9', 'El', 'Administrador', NULL, NULL, 't', 't', NOW(), NOW());
INSERT INTO "usuario"."perfil" VALUES (1, 'Admin', 'Todos los permisos', 't', '2020-12-16 06:39:39.218785', '2020-12-16 06:39:39.218785');

-- ----------------------------
-- Records of dominio
-- ----------------------------
INSERT INTO "usuario"."dominio" VALUES (1, 'localhost', 'Inicial', 'a4e270a1-9689-4507-8988-749a0a919b21', 't', '2020-12-10 05:39:04.293219', '2020-12-10 05:39:04.293219');
INSERT INTO "usuario"."dominio" VALUES (2, 'egit.transporteyucatan.org.mx', 'Inicial', 'a4e270a1-9689-4507-8988-749a0a919b21', 't', '2020-12-10 05:39:04.293219', '2020-12-10 05:39:04.293219');


INSERT INTO "usuario"."perfil_usuario" ("idusuario", "idperfil") VALUES (1, 1);
INSERT INTO "usuario"."usuario_dominio" ("idusuario", "iddominio") VALUES (1, 1);


-- ----------------------------
-- Records of modulo
-- ----------------------------
WITH modulo_usuarios AS (
    INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion)
    VALUES 
        ('Administrativo', 'Usuarios', NULL, 'usr', 'mdi-human-capacity-increase', 't', NOW(), NOW())
    RETURNING id
),
permiso_usuarios AS (
    INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
    VALUES 
		('Ver usuario', 'Ver información del usuario', 'veus', (SELECT id FROM modulo_usuarios)),
		('Editar usuario', 'Editar información y configuración del usuario', 'edus', (SELECT id FROM modulo_usuarios)),
		('Borrar usuario', 'Activar o desactivar usuario', 'bous', (SELECT id FROM modulo_usuarios)),
		('Crear usuario', 'Crear nuevo usuario', 'crus', (SELECT id FROM modulo_usuarios)),
		('Restablecer contraseña', 'Restablecer la contraseña del usuario', 'reco', (SELECT id FROM modulo_usuarios)),
		('Cambiar contraseña', 'Cambiar la contraseña del usuario', 'caco', (SELECT id FROM modulo_usuarios))
    RETURNING id
),
usuario_dominio_modulo_usuarios AS (
    INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo, activo, fecha_creacion, fecha_modificacion)
    SELECT 
        1 as idusuario,
        1 as iddominio,
        id as idmodulo,
        '1' as activo,
        NOW() as fecha_creacion,
        NOW() as fecha_modificacion
    FROM modulo_usuarios
)
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
SELECT 
    1 as idperfil,
    id as idpermiso,
    '1' as activo,
    NOW() as fecha_creacion,
    NOW() as fecha_modificacion
FROM permiso_usuarios;


