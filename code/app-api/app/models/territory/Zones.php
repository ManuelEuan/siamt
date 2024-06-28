<?php
namespace App\Models\Territory;

use Phalcon\Mvc\Model;

class Zones extends Model {

    public function initialize() {
        $this->setSchema("territorio");
        $this->setSource("tbl_cat_zona");
    }

    public static function getSequenceName()
    {
        return "territorio.tbl_cat_zona_iid_seq";
    }
}
