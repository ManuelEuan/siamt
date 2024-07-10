<?php

namespace App\Models\Territory;

use Phalcon\Mvc\Model;

class Colonies extends Model
{
    public function initialize()
    {
        $this->setSchema("territorio");
        $this->setSource("tbl_cat_colonia");
    }

    public function getSequenceName()
    {
        return "persona.tbl_cat_colonia_iid_seq";
    }
    
}
