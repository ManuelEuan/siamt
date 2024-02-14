<?php

namespace App\Db;

use App\Library\Db\Db;
use App\Models\CensusCat;
use App\Models\User;
use App\Models\Module;
use App\Models\UserDomainModule;

class App
{
	
    public static function getDomainConfigAsJson($domain)
    {
        $sql = '
WITH single_domain AS (SELECT id FROM usuario.dominio d WHERE d.nombre = :domain AND d.activo IS TRUE)
SELECT COALESCE(config,\'{}\'::jsonb) AS config
FROM usuario.dominio d, (
	SELECT
		jsonb_object_agg(c.clave,
			CASE c.tipo
				WHEN \'string\' THEN to_jsonb(c.valor)
				ELSE c.valor::jsonb
			END
	) AS config
	FROM usuario.dominio_configuracion c WHERE iddominio in (SELECT id FROM single_domain)
) AS c WHERE d.id IN (SELECT id FROM single_domain)';

        return Db::fetchColumn($sql, ['domain' => $domain]);
    }

    public static function getDomainConfigAsJson2($domainId)
    {
        $sql = '
SELECT
	COALESCE(jsonb_object_agg(c.clave,
		CASE c.tipo
			WHEN \'string\' THEN to_jsonb(c.valor)
			ELSE c.valor::jsonb
		END
	),\'{}\'::jsonb) as config
FROM usuario.dominio_configuracion c WHERE iddominio = :domainId';

        return Db::fetchColumn($sql, ['domainId' => $domainId]);
    }

    public static function getUserConfigAsJson($userId, $domainId)
    {
        $sql = '
SELECT
	COALESCE(jsonb_object_agg(c.clave,
		CASE c.tipo
			WHEN \'string\' THEN to_jsonb(c.valor)
			ELSE c.valor::jsonb
		END
	),\'{}\'::jsonb) as config
FROM usuario.usuario_dominio_configuracion c WHERE idusuario = :userId and iddominio = :domainId';

        return Db::fetchColumn($sql, ['userId' => $domainId, 'domainId' => $domainId]);
    }

    public static function getModules($ids)
    {
        $in = join(',', array_fill(0, count($ids), '?'));
        $sql = "WITH 
		modules AS (	SELECT * FROM usuario.modulo WHERE siglas IN ($in) AND activo = true ),
		l1 AS ( SELECT * FROM modules WHERE idpadre is NULL ORDER BY orden ASC),
		l2 AS ( SELECT * FROM modules WHERE idpadre IN (SELECT id FROM l1) ORDER BY orden ASC),
		l3 AS ( SELECT * FROM modules WHERE idpadre IN (SELECT id FROM l2) ORDER BY orden ASC),
		l2c AS ( SELECT b.*, c.childs FROM l2 AS b LEFT JOIN (
		SELECT idpadre, json_agg(json_build_object('name', nombre, 'desc', descripcion, 'code', siglas,'icon', icono, 'config', configuracion, 'items', '')) as childs from l3 GROUP BY idpadre
		) AS c ON (b.id=c.idpadre))
		 
		SELECT json_agg(json_build_object('name', seccion, 'items', childs)) FROM (
		
		SELECT seccion, json_agg(json_build_object('name', nombre, 'desc', descripcion, 'code', siglas,'icon', icono, 'config', configuracion, 'items', b.childs)) as childs FROM l1 AS a
		LEFT JOIN
		(
			SELECT idpadre, json_agg(json_build_object('name', nombre, 'desc', descripcion, 'code', siglas,'icon', icono, 'config', configuracion, 'items', childs)) AS childs FROM l2c AS b GROUP BY b.idpadre
		) AS b ON (a.id=b.idpadre)
		GROUP BY a.seccion ORDER BY a.seccion desc
		) AS s";

        return Db::fetchColumn($sql, array_merge($ids));
    }


    public static function getModulesAll($ids)
    {
        $in = join(',', array_fill(0, count($ids), '?'));
        $sql = "WITH 
		modules AS (	SELECT * FROM usuario.modulo WHERE siglas IN ($in) AND activo = true ),
		l1 AS ( SELECT * FROM modules WHERE idpadre is NULL ORDER BY orden ASC),
		l2 AS ( SELECT * FROM modules WHERE idpadre IN (SELECT id FROM l1) ORDER BY orden ASC),
		l3 AS ( SELECT * FROM modules WHERE idpadre IN (SELECT id FROM l2) ORDER BY orden ASC),
		l2c AS ( SELECT b.*, c.childs FROM l2 AS b LEFT JOIN (
		SELECT idpadre, json_agg(json_build_object('name', nombre, 'desc', descripcion, 'code', siglas,'icon', icono, 'config', configuracion, 'items', '')) as childs from l3 GROUP BY idpadre
		) AS c ON (b.id=c.idpadre))
		 
		SELECT json_agg(json_build_object('name', seccion, 'items', childs)) FROM (
		
		SELECT seccion, json_agg(json_build_object('name', nombre, 'desc', descripcion, 'code', siglas,'icon', icono, 'config', configuracion, 'items', b.childs)) as childs FROM l1 AS a
		LEFT JOIN
		(
			SELECT idpadre, json_agg(json_build_object('name', nombre, 'desc', descripcion, 'code', siglas,'icon', icono, 'config', configuracion, 'items', childs)) AS childs FROM l2c AS b GROUP BY b.idpadre
		) AS b ON (a.id=b.idpadre)
		GROUP BY a.seccion ORDER BY a.seccion desc
		) AS s";

        return Db::fetchColumn($sql, array_merge($ids));
    }

    public static function getModuleUserDomainConfig($user,$module,$domainId) {
        $users = User::findFirst([
            "conditions"=> "usuario = :user:",
            "bind" => [
                "user" => $user
            ]
        ]);


        $modules = Module::findFirst([
          "conditions"=>"siglas = :module:",
            "bind" => [
                "module" => $module
            ]
        ]);

        $config = UserDomainModule::findFirst([
            "columns"   => "config",
            "conditions"=> "idusuario = :user: AND iddominio = :domain: AND idmodulo = :module:",
            "bind" => [
                "user" => $users->id,
                "domain" => $domainId,
                "module" => $modules->id
            ]
        ]);

        return $config;
    }
	
	public static function findUsersByDomain($domainId) {
		$sql = "SELECT u.id, u.usuario, u.nombre, u.apepat, u.apemat, u.correo, u.activo, u.fecha_creacion, u.fecha_modificacion FROM usuario.usuario_dominio AS ud LEFT JOIN usuario.usuario AS u ON (ud.idusuario=u.id) WHERE ud.iddominio = :domainId";
		
		return Db::fetchAll($sql, ['domainId' => $domainId]);
	}

	public static function findProfilesByDomain($domainId) {
		$sql = "SELECT u.id, u.usuario, u.nombre, u.apepat, u.apemat, u.correo, u.activo, u.fecha_creacion, u.fecha_modificacion FROM usuario.usuario_dominio AS ud LEFT JOIN usuario.usuario AS u ON (ud.idusuario=u.id) WHERE ud.iddominio = :domainId";
		
		return Db::fetchAll($sql, ['domainId' => $domainId]);
	}
}