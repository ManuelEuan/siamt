--changeset aicf:25
--permiso para agregar derechos en la boleta

DO $$
DECLARE
id_perfil integer;
    id_perfilA integer;
    id_modulo integer;
    id_permiso integer;
BEGIN


SELECT id INTO id_perfilA FROM usuario.perfil WHERE activo AND nombre = 'Admin';
RAISE NOTICE 'El valor de la variable id_perfilA es: (%)', id_perfilA;


SELECT id INTO id_perfil FROM usuario.perfil WHERE activo AND nombre = 'Administrador Inspectores';
RAISE NOTICE 'El valor de la variable id_perfil es: (%)', id_perfil;


SELECT id INTO id_modulo FROM usuario.modulo WHERE activo AND siglas = 'itr';
RAISE NOTICE 'El valor de la variable id_modulo es: (%)', id_modulo;


INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo, activo, fecha_creacion, fecha_modificacion)
VALUES('Agregar derechos a boleta', 'Permiso para agregar derechos a las boletas de infreccion', 'addrighticket', id_modulo, true, now(), now()) RETURNING id INTO id_permiso;
RAISE NOTICE 'El valor de la variable id_permiso es: (%)', id_permiso;


INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
VALUES(id_perfilA, id_permiso, true, now(), now());


INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
VALUES(id_perfil, id_permiso, true, now(), now());


INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo, activo, fecha_creacion, fecha_modificacion)
VALUES('Eliminar derechos a boleta', 'Permiso para eliminar derechos a las boletas de infreccion', 'deleterighticket', id_modulo, true, now(), now()) RETURNING id INTO id_permiso;
RAISE NOTICE 'El valor de la variable id_permiso es: (%)', id_permiso;


INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
VALUES(id_perfilA, id_permiso, true, now(), now());


INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
VALUES(id_perfil, id_permiso, true, now(), now());


END $$;
