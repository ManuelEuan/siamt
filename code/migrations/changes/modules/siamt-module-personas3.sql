/*
~~~~~~~~~~~~~~~~~~~~~~~ TODOS LOS PERMISOS EN MÓDULO DE INSPECTORES (ins)   ~~~~~~~~~~~~~~~~~~~~~~~
- CREAR PERSONA                                (crmp)
- VER INFORMACIÓN GENERAL DE PERSONA           (vemp)
- EDITAR INFORMACIÓN GENERAL DE PERSONA        (edgp)
- VER DIRECCIONES DE PERSONA                   (vedp)
- CREAR DIRECCIONES DE PERSONA                 (crdp)
- EDITAR DIRECCIONES DE PERSONA                (eddp)
- VER TELÉFONOS DE PERSONA                     (vetp)
- CREAR TELÉFONOS DE PERSONA                   (crtp)
- EDITAR TELÉFONOS DE PERSONA                  (edtp)
- VER ARCHIVOS DE PERSONA                      (veap)
- CREAR ARCHIVOS DE PERSONA                    (crap)
- EDITAR ARCHIVOS DE PERSONA                   (edap)

~~~~~~~~~~~~~~~~~~~~~~~ ESTRUCTURA DEL MÓDULO                               ~~~~~~~~~~~~~~~~~~~~~~~
- Personas

*/

WITH modulo_usuarios AS (
    INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion)
    VALUES 
        ('Administración', 'Personas', NULL, 'pel', 'mdi-account-details', 't', NOW(), NOW())
    RETURNING id
),
permiso_usuarios AS (
    INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
    VALUES 
        ('Crear persona', 'Crear nuevo persona', 'crmp', (SELECT id FROM modulo_usuarios)),
        ('Ver información general de persona', 'Ver información del persona', 'vemp', (SELECT id FROM modulo_usuarios)),
        ('Editar información general de persona', 'Editar información general de la persona', 'edgp', (SELECT id FROM modulo_usuarios)),
        ('Ver direcciones de persona', 'Ver información del persona', 'vedp', (SELECT id FROM modulo_usuarios)),
        ('Crear direcciones de persona', 'Crear direcciones de la persona', 'crdp', (SELECT id FROM modulo_usuarios)),
        ('Editar direcciones de persona', 'Editar direcciones de la persona', 'eddp', (SELECT id FROM modulo_usuarios)),
        ('Ver teléfonos de persona', 'Ver información del persona', 'vetp', (SELECT id FROM modulo_usuarios)),
        ('Crear teléfonos de persona', 'Crear teléfonos de la persona', 'crtp', (SELECT id FROM modulo_usuarios)),
        ('Editar teléfonos de persona', 'Editar teléfonos de la persona', 'edtp', (SELECT id FROM modulo_usuarios)),
        ('Ver archivos de persona', 'Ver archivos de la persona', 'veap', (SELECT id FROM modulo_usuarios)),
        ('Crear archivos de persona', 'Crear archivos de la persona', 'crap', (SELECT id FROM modulo_usuarios)),
        ('Editar archivos de persona', 'Editar archivos de la persona', 'edap', (SELECT id FROM modulo_usuarios))
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
