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

    public static function getAllPostalCodes($bactivo = null, $defaultMunicipality = 50)
    {
        $parameters = [
            'iclave_municipio' => $defaultMunicipality,
        ];

        $conditions = 'iclave_municipio = :iclave_municipio:';
        
        if ($bactivo === true) {
            $conditions .= ' AND bactivo = :activo:';
            $parameters['activo'] = 't';
        } elseif ($bactivo === false) {
            $conditions .= ' AND bactivo = :activo:';
            $parameters['activo'] = 'f';
        } elseif ($bactivo !== null) {
            throw new \InvalidArgumentException("El valor de bactivo debe ser true, false o null.");
        }

        $query = [
            'columns' => 'icodigo_postal',
            'conditions' => $conditions,
            'bind' => $parameters,
            'group' => 'icodigo_postal',
        ];

        $postalCodes = self::find($query);

        return $postalCodes->toArray();
    }

    public static function getColoniesByPostalCode($postalCode)
    {
        $parameters = [
            'icodigo_postal' => $postalCode,
            'activo' => 't',
        ];

        $conditions = 'icodigo_postal = :icodigo_postal: AND bactivo = :activo:';

        $query = [
            'columns' => [
                'iid AS iidcolonia',
                'txtnombre',
                'icodigo_postal',
                'bactivo AS activo',
                'TO_CHAR(dtfecha_creacion, \'DD-MM-YYYY HH24:MI:SS\') AS fecha_creacion',
                'TO_CHAR(dtfecha_modificacion, \'DD-MM-YYYY HH24:MI:SS\') AS fecha_modificacion'
            ],
            'conditions' => $conditions,
            'bind' => $parameters,
        ];

        $colonies = self::find($query);

        return $colonies->toArray();
    }
}
