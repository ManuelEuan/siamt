--changeset aicf:27
--permisos para el perfil INSPECTOR_APP

DO $$
DECLARE
id_perfil integer;
BEGIN


SELECT id INTO id_perfil FROM usuario.perfil WHERE nombre = 'INSPECTOR_APP';
RAISE NOTICE 'El valor de la variable id_perfil es: (%)', id_perfil;


    IF id_perfil > 0 THEN
        INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
        SELECT id_perfil, id, true, now(), now()
        FROM usuario.permiso
        WHERE activo AND idmodulo IN (
            SELECT id
            FROM usuario.modulo
            WHERE activo AND (siglas = 'ias' OR siglas = 'itr')
        ) AND (siglas = 'cras' OR siglas = 'edas' OR siglas = 'crit');
    ELSE
            RAISE NOTICE 'No existe perfil INSPECTOR_APP';
    END IF;


END $$;

