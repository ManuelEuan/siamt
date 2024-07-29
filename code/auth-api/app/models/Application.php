<?php
namespace App\Models;

use Phalcon\Mvc\Model;

class Application extends Model
{

    public function initialize()
    {
        $this->setSource('aplicacion');
        $this->setSchema('usuario');
    }

}
