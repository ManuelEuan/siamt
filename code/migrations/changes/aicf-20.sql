--liquibase formatted sql
--changeset aicf:20
--Módulos, permisos, perfiles y proceso de operadores


WITH ruser AS (
    SELECT id FROM usuario.usuario AS u WHERE u.usuario = 'admin.operadores' AND u.activo = TRUE LIMIT 1
    ),
    module AS (
INSERT INTO usuario.modulo (seccion,nombre,descripcion,siglas,icono,orden,activo,idpadre,fecha_creacion,fecha_modificacion)
VALUES ('Operadores','REPO', 'REPO', 'op_rep', 'mdi-account-tie', 1, 't', NULL, now(), now()) RETURNING id
    ),
    domain AS (
SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1
    )

INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo)
SELECT ruser.id, domain.id, module.id FROM ruser, domain, module;

--------------------

WITH ruser AS (
    SELECT id FROM usuario.usuario AS u WHERE u.usuario = 'admin.operadores' AND u.activo = TRUE LIMIT 1
    ),
    module AS (
INSERT INTO usuario.modulo (seccion,nombre,descripcion,siglas,icono,orden,activo,idpadre,fecha_creacion,fecha_modificacion)
VALUES ('Operadores','Gestión tarjetón', 'Gestión tarjetón', 'op_gta', 'mdi-badge-account', 2, 't', NULL, now(), now()) RETURNING id
    ),
    domain AS (
SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1
    )

INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo)
SELECT ruser.id, domain.id, module.id FROM ruser, domain, module;

--------------------

WITH ruser AS (
    SELECT id FROM usuario.usuario AS u WHERE u.usuario = 'admin.operadores' AND u.activo = TRUE LIMIT 1
    ),
    module AS (
INSERT INTO usuario.modulo (seccion,nombre,descripcion,siglas,icono,orden,activo,idpadre,fecha_creacion,fecha_modificacion)
VALUES ('Operadores','Admisión', 'Admisión', 'op_adm', 'mdi-account-arrow-left', 3, 't', NULL, now(), now()) RETURNING id
    ),
    domain AS (
SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1
    )

INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo)
SELECT ruser.id, domain.id, module.id FROM ruser, domain, module;


WITH ruser AS (
    SELECT id FROM usuario.usuario AS u WHERE u.usuario = 'admin.operadores' AND u.activo = TRUE LIMIT 1
    ),
    root_module AS (
SELECT id FROM usuario.modulo AS m WHERE m.siglas = 'op_adm' AND m.activo = TRUE LIMIT 1
    ),
    modules AS (
INSERT INTO usuario.modulo (seccion,nombre,descripcion,siglas,icono,orden,activo,idpadre,fecha_creacion,fecha_modificacion)
VALUES ('Operadores','Nuevo Ingreso', 'Nuevo Ingreso', 'op_ani', ' ', 1, 't', (SELECT id FROM root_module), now(), now()),
    ('Operadores','Seguimiento', 'Seguimiento', 'op_ase', ' ', 2, 't', (SELECT id FROM root_module), now(), now())

    RETURNING id
    ),
    domain AS (
SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1
    )

INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo)
SELECT ruser.id, domain.id, modules.id FROM ruser, domain, modules;


---------------------

WITH ruser AS (
    SELECT id FROM usuario.usuario AS u WHERE u.usuario = 'admin.operadores' AND u.activo = TRUE LIMIT 1
    ),
    module AS (
INSERT INTO usuario.modulo (seccion,nombre,descripcion,siglas,icono,orden,activo,idpadre,fecha_creacion,fecha_modificacion)
VALUES ('Operadores','Clínica', 'Clínica', 'op_cli', 'mdi-clipboard-pulse-outline', 4, 't', NULL, now(), now()) RETURNING id
    ),
    domain AS (
SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1
    )

INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo)
SELECT ruser.id, domain.id, module.id FROM ruser, domain, module;


WITH ruser AS (
    SELECT id FROM usuario.usuario AS u WHERE u.usuario = 'admin.operadores' AND u.activo = TRUE LIMIT 1
    ),
    root_module AS (
SELECT id FROM usuario.modulo AS m WHERE m.siglas = 'op_cli' AND m.activo = TRUE LIMIT 1
    ),
    modules AS (
INSERT INTO usuario.modulo (seccion,nombre,descripcion,siglas,icono,orden,activo,idpadre,fecha_creacion,fecha_modificacion)
VALUES ('Operadores','Laboratorio', 'Laboratorio', 'op_cla', ' ', 1, 't', (SELECT id FROM root_module), now(), now()),
    ('Operadores','Psicología', 'Seguimiento', 'op_cps', ' ', 2, 't', (SELECT id FROM root_module), now(), now()),
    ('Operadores','Nutrición', 'Nutrición', 'op_cnu', ' ', 3, 't', (SELECT id FROM root_module), now(), now()),
    ('Operadores','Oftalmología', 'Oftalmología', 'op_cof', ' ', 4, 't', (SELECT id FROM root_module), now(), now())

    RETURNING id
    ),
    domain AS (
SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1
    )

INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo)
SELECT ruser.id, domain.id, modules.id FROM ruser, domain, modules;


---------------------

WITH ruser AS (
    SELECT id FROM usuario.usuario AS u WHERE u.usuario = 'admin.operadores' AND u.activo = TRUE LIMIT 1
    ),
    module AS (
INSERT INTO usuario.modulo (seccion,nombre,descripcion,siglas,icono,orden,activo,idpadre,fecha_creacion,fecha_modificacion)
VALUES ('Operadores','Capacitación', 'Capacitación', 'op_cap', 'mdi-school', 5, 't', NULL, now(), now()) RETURNING id
    ),
    domain AS (
SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1
    )

INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo)
SELECT ruser.id, domain.id, module.id FROM ruser, domain, module;


WITH ruser AS (
    SELECT id FROM usuario.usuario AS u WHERE u.usuario = 'admin.operadores' AND u.activo = TRUE LIMIT 1
    ),
    root_module AS (
SELECT id FROM usuario.modulo AS m WHERE m.siglas = 'op_cap' AND m.activo = TRUE LIMIT 1
    ),
    modules AS (
INSERT INTO usuario.modulo (seccion,nombre,descripcion,siglas,icono,orden,activo,idpadre,fecha_creacion,fecha_modificacion)
VALUES ('Operadores','Teórica', 'Teórica', 'op_cte', ' ', 1, 't', (SELECT id FROM root_module), now(), now()),
    ('Operadores','Práctica', 'Práctica', 'op_cpr', ' ', 2, 't', (SELECT id FROM root_module), now(), now()),
    ('Operadores','Simulador', 'Simulador', 'op_csi', ' ', 3, 't', (SELECT id FROM root_module), now(), now())

    RETURNING id
    ),
    domain AS (
SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1
    )

INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo)
SELECT ruser.id, domain.id, modules.id FROM ruser, domain, modules;

------------------------

WITH ruser AS (
    SELECT id FROM usuario.usuario AS u WHERE u.usuario = 'admin.operadores' AND u.activo = TRUE LIMIT 1
    ),
    module AS (
INSERT INTO usuario.modulo (seccion,nombre,descripcion,siglas,icono,orden,activo,idpadre,fecha_creacion,fecha_modificacion)
VALUES ('Operadores','Vinculación', 'Vinculación', 'op_vin', 'mdi-link-variant', 6, 't', NULL, now(), now()) RETURNING id
    ),
    domain AS (
SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1
    )

INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo)
SELECT ruser.id, domain.id, module.id FROM ruser, domain, module;