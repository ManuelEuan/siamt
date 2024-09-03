<?php
namespace App\Models\Person;

use Phalcon\Mvc\Model;

class TypesPhone extends Model
{
    public function initialize()
    {
        $this->setSchema("persona");
        $this->setSource("tbl_cat_tipo_telefono");
    }

    public function getSequenceName()
    {
        return "persona.tbl_cat_tipo_telefono_iid_seq";
    }

    public static function getAllTypesPhone($bactivo = null)
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
                "iid AS iidtipo_telefono",
                "txtnombre",
                "txtdescripcion",
                "bactivo AS activo",
                "TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion",
                "TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion",
            ],
        ];

        // Realizar la consulta utilizando el modelo
        $typesPhone = self::find($query);

        return $typesPhone;
    }
}
