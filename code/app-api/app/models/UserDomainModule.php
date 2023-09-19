<?php

namespace app\models;
use Phalcon\Mvc\Model;
use App\Library\Db\Db;

class UserDomainModule extends Model
{
	public function initialize() 
	{
		$this->setSource('usuario_dominio_modulo');
		$this->setSchema('usuario');
	}
}