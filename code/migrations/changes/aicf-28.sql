--liquibase formatted sql
--changeset aicf:28
--Perfil y permisos complementarios para operadores


BEGIN;

--Se crean nuevos permisos
INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo, activo, fecha_creacion, fecha_modificacion)
VALUES
    ('Imprimir Tarjetón', 'Imprimir Tarjetón', 'taim',
     (SELECT id FROM usuario.modulo WHERE siglas = 'op_gta' AND activo = true), true, now(), now()),
    ('Ver Datos Adicionales', 'Ver conjunto de datos Adicionales', 'vdaop',
     (SELECT id FROM usuario.modulo WHERE siglas = 'op_adm' AND activo = true), true, now(), now()),
    ('Ver Datos de Admisión', 'Ver conjunto de datos de Admisión', 'vaop',
     (SELECT id FROM usuario.modulo WHERE siglas = 'op_adm' AND activo = true), true, now(), now()),
    ('Ver Datos de Clínica', 'Ver conjunto de datos de Clínica', 'vclop',
     (SELECT id FROM usuario.modulo WHERE siglas = 'op_cli' AND activo = true), true, now(), now()),
    ('Ver Datos de Capacitación', 'Ver conjunto de datos de Capacitación', 'vcaop',
     (SELECT id FROM usuario.modulo WHERE siglas = 'op_cap' AND activo = true), true, now(), now()),
    ('Ver Datos de Vinculación', 'Ver conjunto de datos de Vinculación', 'vvop',
     (SELECT id FROM usuario.modulo WHERE siglas = 'op_vin' AND activo = true), true, now(), now()),
    ('Ver Historial de Estado del Operador', 'Ver Historial de Estado del Operador', 'veoop',
     (SELECT id FROM usuario.modulo WHERE siglas = 'op_vin' AND activo = true), true, now(), now());


--Se crean nuevos perfiles
INSERT INTO usuario.perfil (nombre, descripcion, activo, fecha_creacion, fecha_modificacion)
VALUES
    ('Coordinador_Operativo', 'Coordinador general de Vinculación y REPO', true, now(), now()),
    ('Responsable_Reclutamiento', 'Responsable de la operación del módulo de Admisión', true, now(), now()),
    ('Coordinador_Laboratorio', 'Responsable de laboratorio', true, now(), now()),
    ('Coordinador_Psicologia', 'Responsable de psicología', true, now(), now()),
    ('Coordinador_Nutricion', 'Responsable de nutrición', true, now(), now()),
    ('Coordinador_Oftalmologia', 'Responsable de oftalmología', true, now(), now()),
    ('Coord_Capacitacion_Teorica', 'Responsable de capacitación teórica', true, now(), now()),
    ('Coord_Capacitacion_Practica', 'Responsable de capacitación práctica', true, now(), now()),
    ('Coord_Capacitacion_Simulador', 'Responsable del simulador', true, now(), now()),
    ('Responsable_REPO', 'Responsable de la operación del modulo de REPO', true, now(), now()),
    ('Responsable_Tarjeton', 'Responsable de la operación del modulo de Gestión de Tarjetón', true, now(), now());


--Se agregan permisos faltantes al perfil "Admin Operadores"
WITH perfil AS (
    SELECT p.id
    FROM usuario.perfil AS p
             JOIN usuario.perfil_usuario AS pu ON p.id = pu.idperfil
             JOIN usuario.usuario AS u ON pu.idusuario = u.id
    WHERE u.usuario = 'admin.operadores'
    LIMIT 1
    ),
    permiso AS (
SELECT id FROM usuario.permiso
WHERE siglas IN('taim', 'vdaop', 'vaop', 'vclop', 'vcaop', 'vvop', 'veoop')
    )
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso)
SELECT perfil.id, permiso.id FROM perfil, permiso;


--Se agregan permisos al perfil "Coordinador_Operativo"
WITH perfil AS (
    SELECT id FROM usuario.perfil WHERE nombre = 'Coordinador_Operativo' LIMIT 1
    ),
    permiso AS (
SELECT id FROM usuario.permiso WHERE siglas IN('reop', 'viop', 'vdaop', 'vaop', 'vvop', 'veoop')
    )
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso)
SELECT perfil.id, permiso.id FROM perfil, permiso;


--Se agregan permisos al perfil "Responsable_Reclutamiento"
WITH perfil AS (
    SELECT id FROM usuario.perfil WHERE nombre = 'Responsable_Reclutamiento' LIMIT 1
    ),
    permiso AS (
SELECT id FROM usuario.permiso
WHERE siglas IN('adop', 'niop', 'seop', 'vdaop', 'vaop', 'crmp', 'vemp', 'edgp', 'vedp', 'crdp', 'eddp', 'vetp', 'crtp', 'edtp', 'veap', 'crap')
    )
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso)
SELECT perfil.id, permiso.id FROM perfil, permiso;


--Se agregan permisos al perfil "Coordinador_Laboratorio"
WITH perfil AS (
    SELECT id FROM usuario.perfil WHERE nombre = 'Coordinador_Laboratorio' LIMIT 1
    ),
    permiso AS (
SELECT id FROM usuario.permiso WHERE siglas IN('clop', 'laop', 'vclop')
    )
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso)
SELECT perfil.id, permiso.id FROM perfil, permiso;


--Se agregan permisos al perfil "Coordinador_Psicologia"
WITH perfil AS (
    SELECT id FROM usuario.perfil WHERE nombre = 'Coordinador_Psicologia' LIMIT 1
    ),
    permiso AS (
SELECT id FROM usuario.permiso WHERE siglas IN('clop', 'psop', 'vclop')
    )
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso)
SELECT perfil.id, permiso.id FROM perfil, permiso;


--Se agregan permisos al perfil "Coordinador_Nutricion"
WITH perfil AS (
    SELECT id FROM usuario.perfil WHERE nombre = 'Coordinador_Nutricion' LIMIT 1
    ),
    permiso AS (
SELECT id FROM usuario.permiso WHERE siglas IN('clop', 'nuop', 'vclop')
    )
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso)
SELECT perfil.id, permiso.id FROM perfil, permiso;


--Se agregan permisos al perfil "Coordinador_Oftalmologia"
WITH perfil AS (
    SELECT id FROM usuario.perfil WHERE nombre = 'Coordinador_Oftalmologia' LIMIT 1
    ),
    permiso AS (
SELECT id FROM usuario.permiso WHERE siglas IN('clop', 'ofop', 'vclop')
    )
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso)
SELECT perfil.id, permiso.id FROM perfil, permiso;


--Se agregan permisos al perfil "Coord_Capacitacion_Teorica"
WITH perfil AS (
    SELECT id FROM usuario.perfil WHERE nombre = 'Coord_Capacitacion_Teorica' LIMIT 1
    ),
    permiso AS (
SELECT id FROM usuario.permiso WHERE siglas IN('caop', 'teop', 'vcaop')
    )
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso)
SELECT perfil.id, permiso.id FROM perfil, permiso;


--Se agregan permisos al perfil "Coord_Capacitacion_Practica"
WITH perfil AS (
    SELECT id FROM usuario.perfil WHERE nombre = 'Coord_Capacitacion_Practica' LIMIT 1
    ),
    permiso AS (
SELECT id FROM usuario.permiso WHERE siglas IN('caop', 'prop', 'vcaop')
    )
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso)
SELECT perfil.id, permiso.id FROM perfil, permiso;


--Se agregan permisos al perfil "Coord_Capacitacion_Simulador"
WITH perfil AS (
    SELECT id FROM usuario.perfil WHERE nombre = 'Coord_Capacitacion_Simulador' LIMIT 1
    ),
    permiso AS (
SELECT id FROM usuario.permiso WHERE siglas IN('caop', 'siop', 'vcaop')
    )
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso)
SELECT perfil.id, permiso.id FROM perfil, permiso;


--Se agregan permisos al perfil "Responsable_REPO"
WITH perfil AS (
    SELECT id FROM usuario.perfil WHERE nombre = 'Responsable_REPO' LIMIT 1
    ),
    permiso AS (
SELECT id FROM usuario.permiso WHERE siglas IN('reop', 'taop', 'vdaop', 'vaop', 'vclop', 'vcaop', 'vvop', 'veoop')
    )
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso)
SELECT perfil.id, permiso.id FROM perfil, permiso;


--Se agregan permisos al perfil "Responsable_Tarjeton"
WITH perfil AS (
    SELECT id FROM usuario.perfil WHERE nombre = 'Responsable_Tarjeton' LIMIT 1
    ),
    permiso AS (
SELECT id FROM usuario.permiso WHERE siglas IN('taop', 'taim')
    )
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso)
SELECT perfil.id, permiso.id FROM perfil, permiso;


--Se crean usuarios y relaciones de dominio y aplicación
WITH
    domain AS (
        SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1
    ),
    users_added AS (
INSERT INTO usuario.usuario (usuario, clave, nombre, apepat, apemat, correo, admin, activo, fecha_creacion, fecha_modificacion)
VALUES
    ('coord.operativo', encode(sha256('coord.operativo'), 'hex'), 'Coordinador', 'Operativo', '', '', 'f', 't', now(), now()),
    ('resp.reclutamiento', encode(sha256('resp.reclutamiento'), 'hex'), 'Responsable', 'Reclutamiento', '', '', 'f', 't', now(), now()),
    ('coord.laboratorio', encode(sha256('coord.laboratorio'), 'hex'), 'Coordinador', 'Laboratorio', '', '', 'f', 't', now(), now()),
    ('coord.psicologia', encode(sha256('coord.psicologia'), 'hex'), 'Coordinador', 'Psicologia', '', '', 'f', 't', now(), now()),
    ('coord.nutricion', encode(sha256('coord.nutricion'), 'hex'), 'Coordinador', 'Nutricion', '', '', 'f', 't', now(), now()),
    ('coord.oftalmologia', encode(sha256('coord.oftalmologia'), 'hex'), 'Coordinador', 'Oftalmologia', '', '', 'f', 't', now(), now()),
    ('coord.cap.teorica', encode(sha256('coord.cap.teorica'), 'hex'), 'Coordinador', 'Capacitación', 'Teórica', '', 'f', 't', now(), now()),
    ('coord.cap.practica', encode(sha256('coord.cap.practica'), 'hex'), 'Coordinador', 'Capacitación', 'Práctica', '', 'f', 't', now(), now()),
    ('coord.cap.simulador', encode(sha256('coord.cap.simulador'), 'hex'), 'Coordinador', 'Capacitación', 'Simulador', '', 'f', 't', now(), now()),
    ('resp.repo', encode(sha256('resp.repo'), 'hex'), 'Responsable', 'REPO', '', '', 'f', 't', now(), now()),
    ('resp.tarjeton', encode(sha256('resp.tarjeton'), 'hex'), 'Responsable', 'Tarjetón', '', '', 'f', 't', now(), now())
    RETURNING id
    ),
    usuario_dominio AS (
INSERT INTO usuario.usuario_dominio (iddominio, idusuario)
SELECT domain.id, users_added.id FROM domain, users_added
    ),
    aplicacion AS (
SELECT iid FROM usuario.aplicacion WHERE txtnombre = 'EGIT' LIMIT 1
    )
-- Inserción en usuario.usuario_aplicacion
INSERT INTO usuario.usuario_aplicacion (iidusuario, iidaplicacion, bactivo, dtfecha_creacion, dtfecha_modificacion)
SELECT users_added.id, aplicacion.iid, true, now(), now()
FROM users_added, aplicacion;


--Se asignan módulos y dominios a usuarios
INSERT INTO usuario.usuario_dominio_modulo (iddominio, idmodulo, idusuario)
VALUES
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
    (SELECT id FROM usuario.modulo WHERE siglas = 'op_rep' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.operativo' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_vin' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.operativo' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_adm' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'resp.reclutamiento' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_ani' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'resp.reclutamiento' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_ase' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'resp.reclutamiento' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'pel' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'resp.reclutamiento' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_cli' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.laboratorio' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_cla' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.laboratorio' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_cli' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.psicologia' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_cps' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.psicologia' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_cli' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.nutricion' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_cnu' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.nutricion' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_cli' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.oftalmologia' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_cof' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.oftalmologia' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_cap' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.cap.teorica' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_cte' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.cap.teorica' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_cap' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.cap.practica' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_cpr' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.cap.practica' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_cap' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.cap.simulador' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_csi' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.cap.simulador' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_rep' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'resp.repo' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_gta' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'resp.repo' LIMIT 1)),
    ((SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1),
        (SELECT id FROM usuario.modulo WHERE siglas = 'op_gta' AND activo = true), (SELECT id FROM usuario.usuario WHERE usuario = 'resp.tarjeton' LIMIT 1));


--Se asignan perfiles a usuarios
INSERT INTO usuario.perfil_usuario (idperfil, idusuario)
VALUES
    ((SELECT id FROM usuario.perfil WHERE nombre = 'Coordinador_Operativo'), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.operativo')),
    ((SELECT id FROM usuario.perfil WHERE nombre = 'Responsable_Reclutamiento'), (SELECT id FROM usuario.usuario WHERE usuario = 'resp.reclutamiento')),
    ((SELECT id FROM usuario.perfil WHERE nombre = 'Coordinador_Laboratorio'), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.laboratorio')),
    ((SELECT id FROM usuario.perfil WHERE nombre = 'Coordinador_Psicologia'), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.psicologia')),
    ((SELECT id FROM usuario.perfil WHERE nombre = 'Coordinador_Nutricion'), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.nutricion')),
    ((SELECT id FROM usuario.perfil WHERE nombre = 'Coordinador_Oftalmologia'), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.oftalmologia')),
    ((SELECT id FROM usuario.perfil WHERE nombre = 'Coord_Capacitacion_Teorica'), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.cap.teorica')),
    ((SELECT id FROM usuario.perfil WHERE nombre = 'Coord_Capacitacion_Practica'), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.cap.practica')),
    ((SELECT id FROM usuario.perfil WHERE nombre = 'Coord_Capacitacion_Simulador'), (SELECT id FROM usuario.usuario WHERE usuario = 'coord.cap.simulador')),
    ((SELECT id FROM usuario.perfil WHERE nombre = 'Responsable_REPO'), (SELECT id FROM usuario.usuario WHERE usuario = 'resp.repo')),
    ((SELECT id FROM usuario.perfil WHERE nombre = 'Responsable_Tarjeton'), (SELECT id FROM usuario.usuario WHERE usuario = 'resp.tarjeton'));


COMMIT;
