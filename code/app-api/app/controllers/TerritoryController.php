<?php

namespace App\Controllers;

use App\Library\Db\Db;
use App\Library\Http\Controllers\BaseController;
use App\Library\Http\Exceptions\HttpBadRequestException;
use App\Library\Http\Exceptions\ValidatorBoomException;
use App\Models\Territory\Colonies;
use App\Models\Territory\PostalCodes;
use Phalcon\Mvc\Controller;
use App\Models\Territory\LocalDistricts;
use App\Models\Territory\Townships;
use App\Models\Territory\Towns;
use App\Models\Territory\Sections;
use Vokuro\GenericSQL\GenericSQL;

class TerritoryController extends BaseController
{
    public function getEsatdos()
    {
        $sql = "SELECT iclave_estado, txtnombre as nombre
        FROM territorio.tbl_cat_estado WHERE bactivo = true
        ORDER BY txtnombre";
        return GenericSQL::getBySQL($sql);
    }

    public function getMunicipioByEstado($iclave_estado)
    {
        $sql = "SELECT iclave_municipio, txtnombre as nombre
        FROM territorio.tbl_cat_municipio WHERE bactivo = true and iclave_estado = $iclave_estado
        ORDER BY txtnombre";
        return GenericSQL::getBySQL($sql);
    }

    public function getLocalities($iclave_estado, $iclave_municipio)
    {
        $sql = 'SELECT 
                    iid AS id,
                    txtnombre AS nombre
                FROM 
                    territorio.tbl_cat_localidad
                WHERE 
                    bactivo = true
                and iclave_estado = '.$iclave_estado.' and iclave_municipio = '.$iclave_municipio.'
                ORDER BY txtnombre';

        $result = GenericSQL::getBySQL($sql);
        return $result;
    }
}
