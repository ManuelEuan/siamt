-- changeset imjcu-4.sql
-- Generación de módulo de Gestión de firmas con sus permisos correspondientes

/*
~~~~~~~~~~~~~~~~~~~~~~~ TODOS LOS PERMISOS EN MÓDULO DE FIRMAS ~~~~~~~~~~~~~~~~~~~~~~~
- Ver tablero                               (veta)
- Crear plantilla                           (vepl)
- Crear firma                               (vefi)

~~~~~~~~~~~~~~~~~~~~~~~ ESTRUCTURA DEL MÓDULO                               ~~~~~~~~~~~~~~~~~~~~~~~
- Gestión de firmas
  |- Tablero
  |- Listas
     |- Firmas
     |- Plantillas
*/

-- MÓDULO PADRE
WITH modulo_insertado_firma AS (
    INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion)
    VALUES 
        ('Gestión de firmas', 'Listas', 'Gestión de firmas', 'fir', 'mdi-format-list-text', true, NOW(), NOW())
    RETURNING id
),
usuario_dominio_modulo_insertado_firma AS (
    INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo, activo, fecha_creacion, fecha_modificacion)
    SELECT 
        1 as idusuario,
        1 as iddominio,
        id as idmodulo,
        '1' as activo,
        NOW() as fecha_creacion,
        NOW() as fecha_modificacion
    FROM modulo_insertado_firma
),

-- MÓDULO HIJO UNO
submodulo_uno_insertado AS (
    INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion, idpadre)
    VALUES 
        ('Gestión de firmas', 'Plantillas', 'Plantillas', 'fip', 'mdi-human-capacity-increase', true, NOW(), NOW(), (SELECT id FROM modulo_insertado_firma))
    RETURNING id
),
permisos_submodulo_uno_insertado AS (
    INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
    VALUES 
        ('Ver plantillas', 'Ver información de las plantillas', 'vepl', (SELECT id FROM submodulo_uno_insertado))
    RETURNING id
),
usuario_dominio_submodulo_uno_insertado AS (
    INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo, activo, fecha_creacion, fecha_modificacion)
    SELECT 
        1 as idusuario,
        1 as iddominio,
        id as idmodulo,
        '1' as activo,
        NOW() as fecha_creacion,
        NOW() as fecha_modificacion
    FROM submodulo_uno_insertado
),
insert_permisos_submodulo_uno_insertado AS (
    INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
    SELECT 
        1 as idperfil,
        id as idpermiso,
        '1' as activo,
        NOW() as fecha_creacion,
        NOW() as fecha_modificacion
    FROM permisos_submodulo_uno_insertado
),

-- MÓDULO HIJO DOS
submodulo_dos_insertado AS (
    INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion, idpadre)
    VALUES 
        ('Gestión de firmas', 'Firmas', 'Firmas', 'fif', 'mdi-pencil-box-outline', true, NOW(), NOW(), (SELECT id FROM modulo_insertado_firma))
    RETURNING id
),
permisos_submodulo_dos_insertado AS (
    INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
    VALUES 
        ('Ver firmas', 'Ver información de las firmas', 'vefi', (SELECT id FROM submodulo_dos_insertado))
    RETURNING id
),
usuario_dominio_submodulo_dos_insertado AS (
    INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo, activo, fecha_creacion, fecha_modificacion)
    SELECT 
        1 as idusuario,
        1 as iddominio,
        id as idmodulo,
        '1' as activo,
        NOW() as fecha_creacion,
        NOW() as fecha_modificacion
    FROM submodulo_dos_insertado
),
insert_permisos_submodulo_dos_insertado AS (
    INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
    SELECT 
        1 as idperfil,
        id as idpermiso,
        '1' as activo,
        NOW() as fecha_creacion,
        NOW() as fecha_modificacion
    FROM permisos_submodulo_dos_insertado
),


-- MÓDULO HIJO TRES
submodulo_tres_insertado AS (
    INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion, idpadre)
    VALUES 
        ('Gestión de firmas', 'Tablero', 'Tablero', 'fit', 'mdi-developer-board', true, NOW(), NOW(), NULL)
    RETURNING id
),
permisos_submodulo_tres_insertado AS (
    INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
    VALUES 
        ('Ver Tablero', 'Ver información del Tablero', 'veta', (SELECT id FROM submodulo_tres_insertado))
    RETURNING id
),
usuario_dominio_submodulo_tres_insertado AS (
    INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo, activo, fecha_creacion, fecha_modificacion)
    SELECT 
        1 as idusuario,
        1 as iddominio,
        id as idmodulo,
        '1' as activo,
        NOW() as fecha_creacion,
        NOW() as fecha_modificacion
    FROM submodulo_tres_insertado
)
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
SELECT 
    1 as idperfil,
    id as idpermiso,
    '1' as activo,
    NOW() as fecha_creacion,
    NOW() as fecha_modificacion
FROM permisos_submodulo_tres_insertado

