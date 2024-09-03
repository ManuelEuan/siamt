--liquibase formatted sql
--changeset aicf:11
-- Generación de módulo de inspecciones

/*
~~~~~~~~~~~~~~~~~~~~~~~ TODOS LOS PERMISOS EN MÓDULO DE INSPECTORES (ins)   ~~~~~~~~~~~~~~~~~~~~~~~

****** MÓDULO CARGA DE TRABAJO
- VER CARGA DE TRABAJO                                  (veif)
- EDITAR CARGA DE TRABAJO                               (edif)
- BORRAR CARGA DE TRABAJO                               (boif)
- CREAR CARGA DE TRABAJO                                (crif)

****** MÓDULO BOLETA
- VER BOLETA                                            (veit)
- EDITAR BOLETA                                         (edit)
- BORRAR BOLETA                                         (boit)
- CREAR BOLETA                                          (crit)

****** MÓDULO INSPECTORES
- VER INSPECTOR                                         (veii)
- EDITAR INSPECTOR                                      (edii)
- BORRAR INSPECTOR                                      (boii)
- CREAR INSPECTOR                                       (crii)

****** MÓDULO ASISTENCIA
- VER ASISTENCIA                                         (veas)
- EDITAR ASISTENCIA                                      (edas)
- BORRAR ASISTENCIA                                      (boas)
- CREAR ASISTENCIA                                       (cras)

~~~~~~~~~~~~~~~~~~~~~~~ ESTRUCTURA DEL MÓDULO                               ~~~~~~~~~~~~~~~~~~~~~~~
- Inspección
    |- Inspectores
    |- Inspección
    |- Boletas
    |- Asistencia
*/


-- MÓDULO HIJO UNO
WITH submodulo_uno_insertado_inspeccion AS (
INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion)
VALUES
    ('Inspección', 'Inspectores', 'Inspectores', 'iin', 'mdi-account-multiple-check', true, NOW(), NOW())
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
INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion)
VALUES
    ('Inspección', 'Boletas', 'Boletas', 'itr', 'mdi-credit-card-edit-outline', true, NOW(), NOW())
    RETURNING id
    ),
    permisos_submodulo_dos_insertado_inspeccion AS (
INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
VALUES
    ('Ver Boleta', 'Ver información del Boleta', 'veit', (SELECT id FROM submodulo_dos_insertado_inspeccion)),
    ('Editar Boleta', 'Editar información y configuración del Boleta', 'edit', (SELECT id FROM submodulo_dos_insertado_inspeccion)),
    ('Borrar Boleta', 'Activar o desactivar Boleta', 'boit', (SELECT id FROM submodulo_dos_insertado_inspeccion)),
    ('Crear Boleta', 'Crear nuevo Boleta', 'crit', (SELECT id FROM submodulo_dos_insertado_inspeccion))
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

-- MÓDULO HIJO TRES (Inspeccione)
    submodulo_tres_insertado_inspeccion AS (
INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion)
VALUES
    ('Inspección', 'Inspecciones', 'Inspecciones', 'iif', 'mdi-clipboard-list-outline', true, NOW(), NOW())
    RETURNING id
    ),
    permisos_submodulo_tres_insertado_inspeccion AS (
INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
VALUES
    ('Ver Inspección', 'Ver información de la Inspección', 'veif', (SELECT id FROM submodulo_tres_insertado_inspeccion)),
    ('Editar Inspección', 'Editar información y configuración de la Inspección', 'edif', (SELECT id FROM submodulo_tres_insertado_inspeccion)),
    ('Borrar Inspección', 'Activar o desactivar Inspección', 'boif', (SELECT id FROM submodulo_tres_insertado_inspeccion)),
    ('Crear Inspección', 'Crear nueva Inspección', 'crif', (SELECT id FROM submodulo_tres_insertado_inspeccion))
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
    ),
    insert_permisos_submodulo_tres_insertado_inspeccion AS (
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
SELECT
    1 as idperfil,
    id as idpermiso,
    '1' as activo,
    NOW() as fecha_creacion,
    NOW() as fecha_modificacion
FROM permisos_submodulo_tres_insertado_inspeccion
    ),

-- Módulo Hijo cuatro (Asistencia)
    submodulo_cuatro_insertado_inspeccion AS (
INSERT INTO usuario.modulo (seccion, nombre, descripcion, siglas, icono, activo, fecha_creacion, fecha_modificacion)
VALUES
    ('Inspección', 'Asistencia', 'Asistencia', 'ias', 'mdi-calendar-check', true, NOW(), NOW())
    RETURNING id
    ),
    permisos_submodulo_cuatro_insertado_inspeccion AS (
INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo)
VALUES
    ('Ver Asistencia', 'Ver información de la Asistencia', 'veas', (SELECT id FROM submodulo_cuatro_insertado_inspeccion)),
    ('Editar Asistencia', 'Editar información y configuración de la Asistencia', 'edas', (SELECT id FROM submodulo_cuatro_insertado_inspeccion)),
    ('Borrar Asistencia', 'Activar o desactivar Asistencia', 'boas', (SELECT id FROM submodulo_cuatro_insertado_inspeccion)),
    ('Crear Asistencia', 'Crear nueva Asistencia', 'cras', (SELECT id FROM submodulo_cuatro_insertado_inspeccion))
    RETURNING id
    ),
    usuario_dominio_submodulo_cuatro_insertado_inspeccion AS (
INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo, activo, fecha_creacion, fecha_modificacion)
SELECT
    1 as idusuario,
    1 as iddominio,
    id as idmodulo,
    '1' as activo,
    NOW() as fecha_creacion,
    NOW() as fecha_modificacion
FROM submodulo_cuatro_insertado_inspeccion
    )
-- insert_permisos_submodulo_cuatro_insertado_inspeccion AS (
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso, activo, fecha_creacion, fecha_modificacion)
SELECT
    1 as idperfil,
    id as idpermiso,
    '1' as activo,
    NOW() as fecha_creacion,
    NOW() as fecha_modificacion
FROM permisos_submodulo_cuatro_insertado_inspeccion;
-- );





