--changeset aicf:35
--permisos para agregar y eliminar documentos en boletas de inspecciln



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
    VALUES('Agregar documentos a la boleta', 'Permiso para agregar documentos a las boletas de infreccion', 'adddocticket', id_modulo, true, now(), now()) RETURNING id INTO id_permiso;
    RAISE NOTICE 'El valor de la variable id_permiso es: (%)', id_permiso;


        IF id_perfilA > 0 THEN
            INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
                VALUES(id_perfilA, id_permiso, true, now(), now());
    END IF;


        IF id_perfil > 0 THEN
            INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
                VALUES(id_perfil, id_permiso, true, now(), now());
    END IF;


    INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo, activo, fecha_creacion, fecha_modificacion)
    VALUES('Eliminar documentos a la boleta', 'Permiso para eliminar documentos a las boletas de infreccion', 'deletedocticket', id_modulo, true, now(), now()) RETURNING id INTO id_permiso;
    RAISE NOTICE 'El valor de la variable id_permiso es: (%)', id_permiso;


    IF id_perfilA > 0 THEN
            INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
                VALUES(id_perfilA, id_permiso, true, now(), now());
    END IF;


    IF id_perfil > 0 THEN
            INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
                VALUES(id_perfil, id_permiso, true, now(), now());
    END IF;


END $$;


