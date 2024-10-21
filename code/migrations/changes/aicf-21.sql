--liquibase formatted sql
--changeset aicf:21
--permisos de operadores


WITH ruser AS (
    SELECT id FROM usuario.usuario AS u WHERE u.usuario = 'master' AND u.activo = TRUE LIMIT 1
    ),
    domain AS (
SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1
    )

INSERT INTO usuario.permiso
(nombre, descripcion, siglas, idmodulo, activo, fecha_creacion, fecha_modificacion)
VALUES
    ('Ver Menú Operador REPO', 'Ver listado operadores REPO', 'reop',
    (SELECT id FROM usuario.modulo WHERE siglas = 'op_rep'), true, now(), now()),
    ('Ver Menú Operador Tarjetón', 'Ver listado operadores tarjetón', 'taop',
    (SELECT id FROM usuario.modulo WHERE siglas = 'op_gta'), true, now(), now()),
    ('Ver Menú Operador Admisión', 'Ver menú de operadores en admisión', 'adop',
    (SELECT id FROM usuario.modulo WHERE siglas = 'op_adm'), true, now(), now()),
    ('Ver Operador Nuevo Ingreso', 'Ver listado de operadores en nuevo ingreso', 'niop',
    (SELECT id FROM usuario.modulo WHERE siglas = 'op_ani'), true, now(), now()),
    ('Ver Operador Seguimiento', 'Ver listado de seguimiento', 'seop',
    (SELECT id FROM usuario.modulo WHERE siglas = 'op_ase'), true, now(), now()),
    ('Ver Menú Operador Clínica', 'Ver menú y tab de clínica', 'clop',
    (SELECT id FROM usuario.modulo WHERE siglas = 'op_cli'), true, now(), now()),
    ('Ver Operador Laboratorio', 'Ver listados de laboratorio', 'laop',
    (SELECT id FROM usuario.modulo WHERE siglas = 'op_cla'), true, now(), now()),
    ('Ver Operador Psicología', 'Ver listados de psicología', 'psop',
    (SELECT id FROM usuario.modulo WHERE siglas = 'op_cps'), true, now(), now()),
    ('Ver Operador Nutrición', 'Ver listados de nutrición', 'nuop',
    (SELECT id FROM usuario.modulo WHERE siglas = 'op_cnu'), true, now(), now()),
    ('Ver Operador Oftalmología', 'Ver listado de oftalmología', 'ofop',
    (SELECT id FROM usuario.modulo WHERE siglas = 'op_cof'), true, now(), now()),
    ('Ver Menú Operador Capacitación', 'Ver listado y tab de capacitación', 'caop',
    (SELECT id FROM usuario.modulo WHERE siglas = 'op_cap'), true, now(), now()),
    ('Ver Operador Teórico', 'Ver listados de cap. teórica', 'teop',
    (SELECT id FROM usuario.modulo WHERE siglas = 'op_cte'), true, now(), now()),
    ('Ver Operador Práctico', 'Ver listados de cap. práctica', 'prop',
    (SELECT id FROM usuario.modulo WHERE siglas = 'op_cpr'), true, now(), now()),
    ('Ver Operador Simulador', 'Ver listados de cap. simulador', 'siop',
    (SELECT id FROM usuario.modulo WHERE siglas = 'op_csi'), true, now(), now()),
    ('Ver Menú Operador Vinculación', 'Ver listado y tab de vinculación', 'viop',
    (SELECT id FROM usuario.modulo WHERE siglas = 'op_vin'), true, now(), now());