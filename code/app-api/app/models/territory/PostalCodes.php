<?php

namespace App\Models\Territory;

use Phalcon\Mvc\Model;
use App\Library\Db\Db;

class PostalCodes extends Model
{
    public function initialize()
    {
        $this->setSchema("territorio");
        $this->setSource("tbl_cp");
    }

    public function getSequenceName()
    {
        return "territorio.tbl_cp_iid_seq";
    }

    public static function getAllPostalCodes($bactivo = null, $defaultMunicipality = 50, $defaultEntity = 31)
    {
        $params = array('icve_municipio' => $defaultMunicipality, 'iclave_estado' => $defaultEntity);
        $sql = "SELECT DISTINCT icp as icodigo_postal FROM territorio.tbl_cp WHERE
                icve_municipio = :icve_municipio AND iclave_estado = :iclave_estado";

        $postalCodes = Db::fetchAll($sql, $params);
        return $postalCodes;
    }

    public static function getMunicipalityAndEntityByPostalCode($icp)
    {
        $params = array('icp' => $icp);
        $sql = "SELECT txtmunicipio AS municipality, txtestado AS entity FROM territorio.tbl_cp WHERE
                icp = :icp";

        $municipalityAndEntity = Db::fetchOne($sql, $params);
        return $municipalityAndEntity;
    }
    
    public static function getColoniesByPostalCode($postalCode)
    {
        $parameters = [
            'icp' => $postalCode,
        ];

        $conditions = 'icp = :icp:';

        $query = [
            'columns' => [
                'iid AS iidcolonia',
                'txtasentamiento',
                'icp',
            ],
            'conditions' => $conditions,
            'bind' => $parameters,
        ];

        $colonies = self::find($query);

        return $colonies;
    }
}
