/*


~~~~~~~~~~~~~~~~~~~~~~~ TODOS LOS PERMISOS EN MÓDULO DE INSPECTORES (ins)   ~~~~~~~~~~~~~~~~~~~~~~~
- CREAR PERSONA                                (crmp)
- VER INFORMACIÓN GENERAL DE PERSONA           (vegp)
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


-- MÓDULO PADRE
WITH permisos_submodulo_uno_insertado AS (
    INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
    VALUES 
        ('Crear persona', 'Crear nuevo persona', 'crmp', 2),
        ('Ver información general de persona', 'Ver información del persona', 'vemp', 2),
        ('Editar información general de persona', 'Editar información general de la persona', 'edgp', 2),
        ('Ver direcciones de persona', 'Ver información del persona', 'vedp', 2),
        ('Crear direcciones de persona', 'Crear direcciones de la persona', 'crdp', 2),
        ('Editar direcciones de persona', 'Editar direcciones de la persona', 'eddp', 2),
        ('Ver teléfonos de persona', 'Ver información del persona', 'vetp', 2),
        ('Crear teléfonos de persona', 'Crear teléfonos de la persona', 'crtp', 2),
        ('Editar teléfonos de persona', 'Editar teléfonos de la persona', 'edtp', 2),
        ('Ver archivos de persona', 'Ver archivos de la persona', 'veap', 2),
        ('Crear archivos de persona', 'Crear archivos de la persona', 'crap', 2),
        ('Editar archivos de persona', 'Editar archivos de la persona', 'edap', 2)
    RETURNING id
)

INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
SELECT 
    1 as idperfil,
    id as idpermiso,
    '1' as activo,
    NOW() as fecha_creacion,
    NOW() as fecha_modificacion
FROM permisos_submodulo_uno_insertado
