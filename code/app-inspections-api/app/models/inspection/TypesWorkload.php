<?php
namespace App\Models\Inspection;

use Phalcon\Mvc\Model;

class TypesWorkload extends Model
{
    public function initialize()
    {
        $this->setSchema("inspeccion");
        $this->setSource("tbl_cat_carga_trabajo_tipo");
    }

    public static function getAllTypesWorkload($bactivo = true)
    {
        $parameters = [];

        if ($bactivo === true) {
            $parameters["activo"] = 't';
        } elseif ($bactivo === false) {
            $parameters["activo"] = 'f';
        }

        $conditions = "bactivo = :activo:";
        
        // Construir la consulta
        $query = [
            "conditions" => $conditions,
            "bind" => $parameters,
            "order" => "txtnombre",
            "columns" => [
                "iid AS iidcarga_trabajo_tipo",
                "txtnombre",
                "txtdescripcion",
                "breten",
                "bactivo AS activo",
                "TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion",
                "TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion",
            ],
        ];

        // Realizar la consulta utilizando el modelo
        $typesWorkload = self::find($query);

        return $typesWorkload;
    }
}
