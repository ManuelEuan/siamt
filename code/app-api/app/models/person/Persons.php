<?php

namespace App\Models\Person;

use Phalcon\Mvc\Model;
use App\Library\Db\Db;
// use App\Library\Db\Db;

class Persons extends Model
{
    public function initialize()
    {
        $this->setSchema("persona");
        $this->setSource("tbl_persona");
    }
    
}