<?php

namespace app\models;
use Phalcon\Mvc\Model;
use App\Library\Db\Db;

class User extends Model
{
	public function initialize() 
	{
		$this->setSource('usuario');
		$this->setSchema('usuario');
	}
	
	public static function findByDomain($domainId) {
		$sql = "SELECT u.id, u.usuario, u.nombre, u.apepat, u.apemat, u.correo, u.activo, u.fecha_creacion, u.fecha_modificacion FROM usuario.usuario_dominio AS ud LEFT JOIN usuario.usuario AS u ON (ud.idusuario=u.id) WHERE ud.iddominio = :domainId";
		
		return Db::fetchAll($sql, ['domainId' => $domainId]);
	}
}