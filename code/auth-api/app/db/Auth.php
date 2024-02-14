<?php

namespace App\Db;

use App\Library\Db\Db;

class Auth
{
	public static function login($username, $password, $domain)
	{
		$sql = '
SELECT t.idusuario,usr.nombre,t.iddominio,dmn.nombre AS dominio FROM usuario.usuario_dominio AS t 
INNER JOIN
(
    SELECT id, CONCAT_WS(\' \',nombre,apepat,apemat) as nombre FROM usuario.usuario WHERE usuario = ? AND clave = encode(sha256(?),\'hex\') AND activo = true
) AS usr ON t.idusuario = usr.id
INNER JOIN
(
    SELECT id, nombre FROM usuario.dominio WHERE nombre = ? AND activo = true
) AS dmn ON t.iddominio = dmn.id
WHERE t.activo = true';

		return Db::fetch($sql, [$username, $password, $domain]);
	}

	public static function getUserPermissionsAsJson($userId, $domainId)
	{
		$sql = "
		SELECT idusuario, json_object_agg(siglas, permisos) as permisos 
		FROM (	
				SELECT t.idusuario, mod.siglas, COALESCE(json_agg(prm.siglas) FILTER (WHERE prm.siglas IS NOT NULL ),'[]') AS permisos 
				FROM 
				(
					SELECT idusuario, idmodulo FROM usuario.usuario_dominio_modulo AS t WHERE idusuario = :userId AND iddominio = :domainId AND activo = true
				) AS t
				LEFT JOIN
				(
					SELECT siglas,idmodulo FROM usuario.permiso AS t 
					INNER JOIN 
					(
						SELECT idpermiso FROM usuario.usuario_permiso WHERE idusuario = :userId
					) AS upr ON upr.idpermiso = t.id
					UNION
					SELECT siglas, idmodulo FROM usuario.permiso AS t
					INNER JOIN
					(
						SELECT idpermiso FROM usuario.perfil_permiso AS t
						INNER JOIN 
						(
							SELECT idperfil FROM usuario.perfil_usuario WHERE idusuario = :userId
						) AS psr ON psr.idperfil = t.idperfil 
					) AS upr ON upr.idpermiso = t.id
				) AS prm ON t.idmodulo = prm.idmodulo 
				LEFT JOIN
				(
					SELECT id,siglas FROM usuario.modulo
				) AS mod ON t.idmodulo = mod.id 
				GROUP BY t.idusuario, mod.siglas
		) AS sq GROUP BY sq.idusuario;";

		return Db::fetch($sql, ['userId' => $userId, 'domainId' => $domainId]);
	}



	public static function changePassword($user, $pass)
	{
		$sql = 'UPDATE usuario.usuario SET clave = encode(sha256(\'' . $pass . '\'),\'hex\') WHERE usuario LIKE \'' . $user . '\'';
		return Db::fetchAll($sql);
	}

	public static function getUsers()
	{
		$sql = 'SELECT * FROM usuario.usuario WHERE activo = true';
		return Db::fetchAll($sql);
	}
}
