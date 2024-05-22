--liquibase formatted sql
--changeset aicf:1

-- ----------------------------
-- Records of modulo
-- ----------------------------

WITH ruser AS (
    SELECT id FROM usuario.usuario AS u WHERE u.usuario = 'master' AND u.activo = TRUE LIMIT 1
),
module AS (
    INSERT INTO usuario.modulo (seccion,nombre,descripcion,siglas,icono,orden,activo,idpadre,fecha_creacion,fecha_modificacion)
    VALUES (NULL,'Debitaciones', NULL, 'deb', 'mdi-credit-card-clock-outline', NULL, 't', NULL, now(), now()) RETURNING id
),
 domain AS (
     SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1
 )

INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo)
SELECT ruser.id, domain.id, module.id FROM ruser, domain, module;

UPDATE usuario.modulo SET activo = 'f' WHERE siglas IN('mdl', 'pel');

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
SELECT perfil.id, permisos.id FROM perfil, permisos;

--liquibase formatted sql
--changeset aicf:4

WITH modulo_insertado AS (
    INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion)
    VALUES 
        ('', 'Perfiles', NULL, 'per', 'mdi-human-capacity-increase', '1', NOW(), NOW())
    RETURNING id
),
permisos_insertados AS (
    INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
    VALUES 
        ('Ver perfil', 'Ver información del perfil', 'vepe', (SELECT id FROM modulo_insertado)),
        ('Editar perfil', 'Editar información y configuración del perfil', 'edpe', (SELECT id FROM modulo_insertado)),
        ('Borrar perfil', 'Activar o desactivar perfil', 'bope', (SELECT id FROM modulo_insertado)),
        ('Crear perfil', 'Crear nuevo perfil', 'crpe', (SELECT id FROM modulo_insertado))
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
    FROM modulo_insertado
)
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
SELECT 
    1 as idperfil,
    id as idpermiso,
    '1' as activo,
    NOW() as fecha_creacion,
    NOW() as fecha_modificacion
FROM permisos_insertados;
