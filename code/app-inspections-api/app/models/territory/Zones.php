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

    public static function getAllZones($bactivo = null)
    {
        $parameters = [];
        if ($bactivo === true) {
            $parameters["activo"] = 't';
        } elseif ($bactivo === false) {
            $parameters["activo"] = 'f';
        }

        return self::find([
            "bind" => $parameters,
            "order" => "txtnombre",
            "columns" => [
                "iid AS iidzona",
                "txtnombre",
                "bactivo AS activo",
                "TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion",
                "TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion",
            ],
        ]);
    }
}
