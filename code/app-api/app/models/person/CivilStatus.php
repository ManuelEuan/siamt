<?php
namespace App\Models\Person;

use Phalcon\Mvc\Model;

class CivilStatus extends Model
{
    public function initialize()
    {
        $this->setSchema("persona");
        $this->setSource("tbl_cat_estado_civil");
    }

    public function getSequenceName()
    {
        return "persona.tbl_cat_estado_civil_iid_seq";
    }

    public static function getAllCivilStatus($bactivo = null)
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
                "iid AS iidestado_civil",
                "txtnombre",
                "txtdescripcion",
                "bactivo AS activo",
                "TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion",
                "TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion",
            ],
        ];

        // Realizar la consulta utilizando el modelo
        $sexes = self::find($query);

        return $sexes;
    }
}