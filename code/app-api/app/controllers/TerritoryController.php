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

    public function getLocalities($iclave_estado=null, $iclave_municipio= null)
    {
        $sql = 'SELECT  
                    iclave_estado,
                    iclave_municipio,
                    iid AS id,
                    txtnombre AS nombre
                FROM 
                    territorio.tbl_cat_localidad
                WHERE 
                    bactivo = true';

        if ($iclave_estado !== null) {
            $sql .= ' AND iclave_estado = ' . $iclave_estado;
        }

        if ($iclave_municipio !== null) {
            $sql .= ' AND iclave_municipio = ' . $iclave_municipio;
        }
        $result = GenericSQL::getBySQL($sql);
        return $result;
    }

    public function getAllPostalCodes()
    {
        try {
            // return Colonies::getAllPostalCodes();
            return PostalCodes::getAllPostalCodes();
        } catch (\Exception $e) {
            $message = 'Error en cp: ' . $e->getMessage();
            throw new ValidatorBoomException(422, $message);
        }
        
    }

    public function getMunicipalityAndEntityByPostalCode()
    {
        $postalCode = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        return PostalCodes::getMunicipalityAndEntityByPostalCode($postalCode);
    }

    public function getColoniesByPostalCode()
    {
        $postalCode = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        return PostalCodes::getColoniesByPostalCode($postalCode);
    } 
}
