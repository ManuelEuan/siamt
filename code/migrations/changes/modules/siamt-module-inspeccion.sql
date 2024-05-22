/*


~~~~~~~~~~~~~~~~~~~~~~~ TODOS LOS PERMISOS EN MÓDULO DE INSPECTORES (ins)   ~~~~~~~~~~~~~~~~~~~~~~~
- VER INSPECTOR                                (veii)
- EDITAR INSPECTOR                             (edii)
- BORRAR INSPECTOR                             (boii)
- CREAR INSPECTOR                              (crii)

~~~~~~~~~~~~~~~~~~~~~~~ ESTRUCTURA DEL MÓDULO                               ~~~~~~~~~~~~~~~~~~~~~~~
- Inspección
  |- Carga de trabajo
  |- Listas
     |- Trabajo
     |- Inspectores


*/

-- MÓDULO PADRE
WITH modulo_insertado_inspeccion AS (
    INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion)
    VALUES 
        ('Inspecciones', 'Listas', 'Catalogo de inspecciones', 'ins', 'mdi-human-capacity-increase', true, NOW(), NOW())
    RETURNING id
),
usuario_dominio_modulo_insertado_inspeccion AS (
    INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo, activo, fecha_creacion, fecha_modificacion)
    SELECT 
        1 as idusuario,
        1 as iddominio,
        id as idmodulo,
        '1' as activo,
        NOW() as fecha_creacion,
        NOW() as fecha_modificacion
    FROM modulo_insertado_inspeccion
),

-- MÓDULO HIJO UNO
submodulo_uno_insertado_inspeccion AS (
    INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion, idpadre)
    VALUES 
        ('Inspección', 'Inspectores', 'Inspectores', 'iin', 'mdi-human-capacity-increase', true, NOW(), NOW(), (SELECT id FROM modulo_insertado_inspeccion))
    RETURNING id
),
permisos_submodulo_uno_insertado_inspeccion AS (
    INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
    VALUES 
        ('Ver inspector', 'Ver información del inspector', 'veii', (SELECT id FROM submodulo_uno_insertado_inspeccion)),
        ('Editar inspector', 'Editar información y configuración del inspector', 'edii', (SELECT id FROM submodulo_uno_insertado_inspeccion)),
        ('Borrar inspector', 'Activar o desactivar inspector', 'boii', (SELECT id FROM submodulo_uno_insertado_inspeccion)),
        ('Crear inspector', 'Crear nuevo inspector', 'crii', (SELECT id FROM submodulo_uno_insertado_inspeccion))
    RETURNING id
),
usuario_dominio_submodulo_uno_insertado_inspeccion AS (
    INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo, activo, fecha_creacion, fecha_modificacion)
    SELECT 
        1 as idusuario,
        1 as iddominio,
        id as idmodulo,
        '1' as activo,
        NOW() as fecha_creacion,
        NOW() as fecha_modificacion
    FROM submodulo_uno_insertado_inspeccion
),
insert_permisos_submodulo_uno_insertado_inspeccion AS (
    INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
    SELECT 
        1 as idperfil,
        id as idpermiso,
        '1' as activo,
        NOW() as fecha_creacion,
        NOW() as fecha_modificacion
    FROM permisos_submodulo_uno_insertado_inspeccion
),

-- MÓDULO HIJO DOS
submodulo_dos_insertado_inspeccion AS (
    INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion, idpadre)
    VALUES 
        ('Inspección', 'Trabajo', 'Trabajo', 'itr', 'mdi-human-capacity-increase', true, NOW(), NOW(), (SELECT id FROM modulo_insertado_inspeccion))
    RETURNING id
),
permisos_submodulo_dos_insertado_inspeccion AS (
    INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
    VALUES 
        ('Ver trabajo', 'Ver información del trabajo', 'veit', (SELECT id FROM submodulo_dos_insertado_inspeccion)),
        ('Editar trabajo', 'Editar información y configuración del trabajo', 'edit', (SELECT id FROM submodulo_dos_insertado_inspeccion)),
        ('Borrar trabajo', 'Activar o desactivar trabajo', 'boit', (SELECT id FROM submodulo_dos_insertado_inspeccion)),
        ('Crear trabajo', 'Crear nuevo trabajo', 'crit', (SELECT id FROM submodulo_dos_insertado_inspeccion))
    RETURNING id
),
usuario_dominio_submodulo_dos_insertado_inspeccion AS (
    INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo, activo, fecha_creacion, fecha_modificacion)
    SELECT 
        1 as idusuario,
        1 as iddominio,
        id as idmodulo,
        '1' as activo,
        NOW() as fecha_creacion,
        NOW() as fecha_modificacion
    FROM submodulo_dos_insertado_inspeccion
),
insert_permisos_submodulo_dos_insertado_inspeccion AS (
    INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
    SELECT 
        1 as idperfil,
        id as idpermiso,
        '1' as activo,
        NOW() as fecha_creacion,
        NOW() as fecha_modificacion
    FROM permisos_submodulo_dos_insertado_inspeccion
),


-- MÓDULO HIJO TRES
submodulo_tres_insertado_inspeccion AS (
    INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion, idpadre)
    VALUES 
        ('Inspecciones', 'Carga de trabajo', 'Carga de trabajo', 'ica', 'mdi-human-capacity-increase', true, NOW(), NOW(), NULL)
    RETURNING id
),
permisos_submodulo_tres_insertado_inspeccion AS (
    INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
    VALUES 
        ('Ver carga de trabajo', 'Ver información del carga de trabajo', 'veic', (SELECT id FROM submodulo_tres_insertado_inspeccion)),
        ('Editar carga de trabajo', 'Editar información y configuración del carga de trabajo', 'edic', (SELECT id FROM submodulo_tres_insertado_inspeccion)),
        ('Borrar carga de trabajo', 'Activar o desactivar carga de trabajo', 'boic', (SELECT id FROM submodulo_tres_insertado_inspeccion)),
        ('Crear carga de trabajo', 'Crear nuevo carga de trabajo', 'cric', (SELECT id FROM submodulo_tres_insertado_inspeccion))
    RETURNING id
),
usuario_dominio_submodulo_tres_insertado_inspeccion AS (
    INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo, activo, fecha_creacion, fecha_modificacion)
    SELECT 
        1 as idusuario,
        1 as iddominio,
        id as idmodulo,
        '1' as activo,
        NOW() as fecha_creacion,
        NOW() as fecha_modificacion
    FROM submodulo_tres_insertado_inspeccion
)
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
SELECT 
    1 as idperfil,
    id as idpermiso,
    '1' as activo,
    NOW() as fecha_creacion,
    NOW() as fecha_modificacion
FROM permisos_submodulo_tres_insertado_inspeccion

