<?php

namespace App\Db;

use App\Library\Db\Db;
use App\Models\CensusCat;
use App\Models\User;
use App\Models\Module;
use App\Models\UserDomainModule;

class App
{

	// ESTE ES UN EJEMPLO
	// public static function getDomainConfigAsJson($domain)
	// {
	// 	$sql = '
	// 			WITH single_domain AS (SELECT id FROM usuario.dominio d WHERE d.nombre = :domain AND d.activo IS TRUE)
	// 			SELECT COALESCE(config,\'{}\'::jsonb) AS config
	// 			FROM usuario.dominio d, (
	// 				SELECT
	// 					jsonb_object_agg(c.clave,
	// 						CASE c.tipo
	// 							WHEN \'string\' THEN to_jsonb(c.valor)
	// 							ELSE c.valor::jsonb
	// 						END
	// 				) AS config
	// 				FROM usuario.dominio_configuracion c WHERE iddominio in (SELECT id FROM single_domain)
	// 			) AS c WHERE d.id IN (SELECT id FROM single_domain)';

	// 	return Db::fetchColumn($sql, ['domain' => $domain]);
	}
}
