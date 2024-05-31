<?php

namespace App\Models;

use Phalcon\Mvc\Model;
use App\Library\Db\Db;

class Modules extends Model 
{
	public function initialize() 
	{
		$this->setSource('modulo');
		$this->setSchema('usuario');
		
		$this->skipAttributes(
			[
				'busqueda'
			]
		);
	}
	
	public static function remove(array $ids)
	{
		$in = join(',', array_fill(0, count($ids), '?'));
		$sql = "DELETE FROM usuario.modulo WHERE id IN ($in)";
		
		return Db::execute($sql, array_merge($ids));
	}
	
	public static function activate(array $ids)
	{
		return self::updateActivo($ids, true);
	}
	
	public static function deactivate(array $ids)
	{
		return self::updateActivo($ids, false);
	}
	
	public static function updateActivo(array $ids, bool $value)
	{
		$boolValue = var_export($value, 1);
		$in = join(',', array_fill(0, count($ids), '?'));
		$sql = "UPDATE usuario.modulo SET activo = $boolValue WHERE id IN ($in)";
		
		return Db::execute($sql, array_merge($ids));
	}
}