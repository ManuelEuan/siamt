<?php
namespace App\Models\Inspection;

use Phalcon\Mvc\Model;

class Shifts extends Model
{
    public function initialize()
    {
        // $this->setSchema("inspeccion");
        $this->setConnectionService('db_inspecciones');
        $this->setSchema("inspeccion");
        $this->setSource("tbl_cat_turno");
    }

    public function getSequenceName()
    {
        return "inspeccion.tbl_cat_turno_iid_seq";
    }

    public static function getAllShifts($bactivo = null)
    {
        $parameters = [];
        $conditions = [];

        if ($bactivo === true) {
            $conditions[] = "bactivo = :activo:";
            $parameters["activo"] = 't';
        } elseif ($bactivo === false) {
            $conditions[] = "bactivo = :activo:";
            $parameters["activo"] = 'f';
        } elseif ($bactivo !== null) {
            throw new \InvalidArgumentException("El valor de bactivo debe ser true, false o null.");
        }

        // Construir la consulta
        $query = [
            "conditions" => implode(" AND ", $conditions),
            "bind" => $parameters,
            "order" => "txtnombre",
            "columns" => [
                "iid AS iidturno",
                "txtnombre",
                "thora_inicio",
                "thora_fin",
                "bactivo AS activo",
                "TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion",
                "TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion",
            ],
        ];

        // Realizar la consulta utilizando el modelo
        $shifts = self::find($query);

        return $shifts;
    }
}
