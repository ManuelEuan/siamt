WITH modulo_modulos AS (
    INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion)
    VALUES 
        ('Administración', 'Módulos', NULL, 'mod', 'mdi-view-module', '1', NOW(), NOW())
    RETURNING id
),
permiso_modulos AS (
    INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
    VALUES 
        ('Ver módulo', 'Ver información del módulo', 'vemo', (SELECT id FROM modulo_modulos)),
        ('Editar módulo', 'Editar información y configuración del módulo', 'edmo', (SELECT id FROM modulo_modulos)),
        ('Borrar módulo', 'Activar o desactivar módulo', 'bomo', (SELECT id FROM modulo_modulos)),
        ('Crear módulo', 'Crear nuevo módulo', 'crmo', (SELECT id FROM modulo_modulos))
    RETURNING id
),
usuario_dominio_modulo_modulos AS (
    INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo, activo, fecha_creacion, fecha_modificacion)
    SELECT 
        1 as idusuario,
        1 as iddominio,
        id as idmodulo,
        '1' as activo,
        NOW() as fecha_creacion,
        NOW() as fecha_modificacion
    FROM modulo_modulos
)
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
SELECT 
    1 as idperfil,
    id as idpermiso,
    '1' as activo,
    NOW() as fecha_creacion,
    NOW() as fecha_modificacion
FROM permiso_modulos;
