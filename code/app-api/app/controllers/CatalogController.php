<?php

namespace App\Controllers;
use App\Library\Http\Controllers\BaseController;
use Vokuro\GenericSQL\GenericSQL;
use \App\Library\Http\Exceptions\HttpBadRequestException;


    class CatalogController extends BaseController
    {
    public function getCompanies()
    {
        $sql = 'SELECT 
                    s.iid AS id,
                    TRIM(e.nombre_completo) AS "nombre"
                FROM 
                    transporte.tbl_empresa s
                INNER JOIN 
                    persona.tbl_persona e ON s.iidpersona = e.iid
                WHERE 
                    s.bactivo = true
                ORDER BY e.nombre_completo';

        $result = GenericSQL::getBySQL($sql);

        if (empty($result)) {
            throw new HttpBadRequestException(404, 'No se encontró información para las empresas solicitadas.');
        }

        return $result;
    }

    public function getVehicles($iidempresa = null)
    {
        if ($iidempresa !== null) {
            if (!is_numeric($iidempresa)) {
                throw new HttpBadRequestException(400, 'El valor de idEmpresa no es válido. Debe ser un número.');
            }
        }

        $sql = 'SELECT
                    a.iid AS "id",
                    a.iidvehiculo AS "idVehiculo",
                    a.iidempresa AS "idEmpresa",
                    TRIM(i.nombre_completo) AS "nombreEmpresa",
                    a.vnomenclatura || \'-\' || a.inumero_economico AS "numeroEconomico"
                FROM 
                    transporte.tbl_empresa_vehiculo a
                INNER JOIN 
                    transporte.tbl_empresa e ON a.iidempresa = e.iid
                INNER JOIN 
                    persona.tbl_persona i ON e.iidpersona = i.iid
                WHERE 
                    a.bactivo = true';
    
        if ($iidempresa !== null) {
            $sql .= ' AND a.iidempresa = ' . (int)$iidempresa;
        }
    
        $sql .= ' ORDER BY i.nombre_completo';
    
        $result = GenericSQL::getBySQL($sql);
    
        if (empty($result)) {
            throw new HttpBadRequestException(404, 'No se encontró información para el ID de empresa proporcionado.');
        }
    
        return $result;
    }
    

    

    public function getConcessions($iidempresa = null)
    {

        if ($iidempresa !== null) {
            if (!is_numeric($iidempresa)) {
                throw new HttpBadRequestException(400, 'El valor de iidempresa no es válido. Debe ser un número.');
            }
        }
        
        $sql = 'SELECT iid AS id, txtnombre AS nombre, iidempresa AS "idEmpresa"
                FROM transporte.tbl_concesion 
                WHERE bactivo = true';

        if ($iidempresa !== null) {
            $sql .= ' AND iidempresa = ' . (int)$iidempresa;
        }

        $sql .= ' ORDER BY txtnombre';

        $result = GenericSQL::getBySQL($sql);

        if (empty($result)) {
            throw new HttpBadRequestException(404, 'No se encontró información para el ID de empresa proporcionado.');
        }
        return $result;
    }

}