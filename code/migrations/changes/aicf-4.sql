WITH modulo_insertado AS (
    INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion)
    VALUES 
        ('', 'Perfiles', NULL, 'per', 'mdi-human-capacity-increase', '1', NOW(), NOW())
    RETURNING id
),
permisos_insertados AS (
    INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
    VALUES 
        ('Ver perfil', 'Ver información del usuario', 'vepe', (SELECT id FROM modulo_insertado)),
        ('Editar perfil', 'Editar información y configuración del usuario', 'edpe', (SELECT id FROM modulo_insertado)),
        ('Borrar perfil', 'Activar o desactivar usuario', 'bope', (SELECT id FROM modulo_insertado)),
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
