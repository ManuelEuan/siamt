--changeset aicf:25
--perfil administrador inspectores



DO $$
DECLARE
id_perfil integer;
    id_usuario integer;
    id_aplicacion integer;
    id_dominio integer;
BEGIN


INSERT INTO usuario.perfil (nombre, descripcion, activo, fecha_creacion, fecha_modificacion)
VALUES ('Administrador Inspectores', 'Perfil del administrador de inspectores', true, now(), now()) RETURNING id INTO id_perfil;
RAISE NOTICE 'El valor de la variable id_perfil es: (%)', id_perfil;


INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
SELECT id_perfil, id, true, now(), now()
FROM usuario.permiso
WHERE activo AND idmodulo IN (
    SELECT id
    FROM usuario.modulo
    WHERE activo AND (siglas = 'ias' OR siglas = 'itr' OR siglas = 'iin' OR siglas = 'pel')
);


INSERT INTO usuario.usuario (usuario, clave, nombre, apepat, apemat, correo, admin, activo, fecha_creacion, fecha_modificacion)
VALUES ('admin.inspectores', encode(sha256('admin.inspectores'::bytea),'hex'), 'Administrador', 'Inspectores', null, null, false, true, now(), now()) RETURNING id INTO id_usuario;
RAISE NOTICE 'El valor de la variable id_usuario es: (%)', id_usuario;


INSERT INTO usuario.perfil_usuario (idusuario, idperfil, activo, fecha_creacion, fecha_modificacion)
VALUES (id_usuario, id_perfil, true, now(), now());


SELECT iid INTO id_aplicacion FROM usuario.aplicacion WHERE bactivo AND txtnombre = 'EGIT';
RAISE NOTICE 'El valor de la variable id_aplicacion 1 es: (%)', id_aplicacion;
INSERT INTO usuario.usuario_aplicacion (iidusuario, iidaplicacion, bactivo, dtfecha_creacion, dtfecha_modificacion)
VALUES (id_usuario, id_aplicacion, true, now(), now());


SELECT iid INTO id_aplicacion FROM usuario.aplicacion WHERE bactivo AND txtnombre = 'APP INSPECCIÓN';
RAISE NOTICE 'El valor de la variable id_aplicacion 2 es: (%)', id_aplicacion;
INSERT INTO usuario.usuario_aplicacion (iidusuario, iidaplicacion, bactivo, dtfecha_creacion, dtfecha_modificacion)
VALUES (id_usuario, id_aplicacion, true, now(), now());


SELECT id INTO id_dominio FROM usuario.dominio WHERE activo limit 1;
RAISE NOTICE 'El valor de la variable id_dominio es: (%)', id_dominio;
INSERT INTO usuario.usuario_dominio (idusuario, iddominio, admin, activo, fecha_creacion, fecha_modificacion)
VALUES (id_usuario, id_dominio, false, true, now(), now());


INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo, activo, fecha_creacion, fecha_modificacion)
SELECT id_usuario, id_dominio, id, true, now(), now()
FROM usuario.modulo
WHERE activo AND (siglas = 'ias' OR siglas = 'itr' OR siglas = 'iin' OR siglas = 'pel');


END $$;


