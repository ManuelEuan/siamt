<?php

namespace app\models;
use Phalcon\Mvc\Model;
use App\Library\Db\Db;

class Module extends Model
{
	public function initialize() 
	{
		$this->setSource('modulo');
		$this->setSchema('usuario');
	}
}