--liquibase formatted sql
--changeset aicf:23
--permisos de personas en perfil admin operadores


WITH
    domain AS (
        SELECT id FROM usuario.dominio AS d WHERE d.activo = TRUE LIMIT 1
    ),
    perfil AS (
SELECT id FROM usuario.perfil WHERE nombre = 'Admin Operadores'
    ),
    user_operadores AS (
SELECT id FROM usuario.usuario WHERE usuario = 'admin.operadores'
    ),
    modules AS (
SELECT id FROM usuario.modulo
WHERE siglas IN ('pel')
  AND activo = TRUE
    ),
    usuario_dominio_modulo AS (
INSERT INTO usuario.usuario_dominio_modulo (iddominio, idmodulo, idusuario)
SELECT domain.id, modules.id, user_operadores.id FROM domain, modules, user_operadores
    ),
    permisos AS (
SELECT id FROM usuario.permiso WHERE siglas IN ('crmp', 'vemp', 'edgp', 'vedp', 'crdp', 'eddp', 'vetp', 'crtp', 'edtp', 'veap', 'crap', 'edap')
    )

-- Inserción de permisos Persona al perfil [Admin Operadores]
INSERT INTO usuario.perfil_permiso (idperfil, idpermiso)
SELECT perfil.id, permisos.id FROM perfil, permisos;