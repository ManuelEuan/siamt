<?php

namespace Vokuro\GenericSQL\Person;

use App\Library\Db\SiamtDb as Db;

class TypesRoad
{

    public static function getAll()
    {
        try {
            $sql = "SELECT iid AS iidtipo_vialidad, txtnombre FROM persona.tbl_cat_tipo_vialidad WHERE bactivo='t'";
            $types = Db::fetchAll($sql);
            return $types;
        } catch (\Exception $e) {
            // Aquí puedes manejar la excepción de acuerdo a tus necesidades
            // Por ejemplo, lanzar una excepción personalizada o registrar el error
            throw new \Exception('Error al consultar: ' . $e->getMessage());
        }
    }

}
