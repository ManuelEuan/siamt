<?php

namespace App\Controllers;
use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use Vokuro\GenericSQL\GenericSQL;
use \App\Library\Http\Exceptions\HttpBadRequestException;


class CatalogController extends BaseController
{
    public function getCompanies()
    {
        $sql = 'SELECT 
                    e.iid AS id,
                    TRIM(p.nombre_completo) AS "nombre"
                FROM 
                    transporte.tbl_empresa e
                INNER JOIN 
                    persona.tbl_persona p ON e.iidpersona = p.iid
                WHERE 
                    e.bactivo = true
                ORDER BY p.nombre_completo';

        $result = GenericSQL::getBySQL($sql);
        return $result;
    }

    public function getVehicles($iidempresa = null)
    {
        if ($iidempresa !== null) {
            if (!is_numeric($iidempresa)) {
                throw new HttpBadRequestException(202, 'El valor de idEmpresa no es válido. Debe ser un número.');
            }
        }

        $sql = 'SELECT
                    ev.iid AS "id",
                    ev.iidvehiculo AS "idVehiculo",
                    ev.iidempresa AS "idEmpresa",
                    vp.txtplaca AS "placa",
                    TRIM(p.nombre_completo) AS "nombreEmpresa",
                    ev.vnomenclatura || \'-\' || ev.inumero_economico AS "numeroEconomico"
                FROM 
                    transporte.tbl_empresa_vehiculo ev
                INNER JOIN 
                    transporte.tbl_empresa e ON ev.iidempresa = e.iid
                INNER JOIN 
                    persona.tbl_persona p ON e.iidpersona = p.iid
                LEFT JOIN 
                    vehiculo.tbl_vehiculo_placa vp ON ev.iidvehiculo = vp.iidvehiculo AND vp.bactual= true AND vp.bactivo= true
                WHERE 
                    ev.bactivo = true';
    
        if ($iidempresa !== null) {
            $sql .= ' AND ev.iidempresa = ' . $iidempresa;
        }
    
        $sql .= ' ORDER BY p.nombre_completo';
        $result = GenericSQL::getBySQL($sql);
        return $result;
    }
    
    public function getConcessions($iidempresa = null)
    {

        if ($iidempresa !== null) {
            if (!is_numeric($iidempresa)) {
                throw new HttpBadRequestException(202, 'El valor de idEmpresa no es válido. Debe ser un número.');
            }
        }
        
        $sql = 'SELECT iid AS id, txtnombre AS nombre, iidempresa AS "idEmpresa"
                FROM transporte.tbl_concesion 
                WHERE bactivo = true';

        if ($iidempresa !== null) {
            $sql .= ' AND iidempresa = ' . $iidempresa;
        }
        $sql .= ' ORDER BY txtnombre';

        $result = GenericSQL::getBySQL($sql);
        return $result;
    }


    public function getOperators($idEmpresa = null)
    {

        if ($idEmpresa !== null) {
            if (!is_numeric($idEmpresa)) {
                throw new HttpBadRequestException(202, 'El valor de idEmpresa no es válido. Debe ser un número.');
            }
        }
        
        $operatorsJson = '[
        {
            "id": 1,
            "nombre": "Operador 1",
            "teléfono": 9998722222,
            "email": "email1@gmmail.com",
            "idEmpresa": 1,
            "nombreEmpresa": "empresa 1",
            "licencias": [
                {
                    "id": 1,
                    "numero": "12345678",
                    "idTipo": "1",
                    "tipoLicencia": "A"
                },
                {
                    "id": 2,
                    "numero": "87654321",
                    "idTipo": "2",
                    "tipoLicencia": "B"
                }
            ]
        },

        {
            "id": 2,
            "nombre": "Operador 2",
            "teléfono": 9998922222,
            "email": "email2@gmmail.com",
            "idEmpresa": 2,
            "nombreEmpresa": "empresa 2",
            "licencias": [
                {
                    "id": 1,
                    "numero": "123378",
                    "idTipo": "3",
                    "tipoLicencia": "C"
                },
                {
                    "id": 2,
                    "numero": "876344321",
                    "idTipo": "4",
                    "tipoLicencia": "D"
                }
            ]
        },
        {
            "id": 3,
            "nombre": "Operador 3",
            "teléfono": 9992722232,
            "email": "email3@gmmail.com",
            "idEmpresa": 3,
            "nombreEmpresa": "empresa 3",
            "licencias": [
                {
                    "id": 1,
                    "numero": "1235478",
                    "idTipo": "1",
                    "tipoLicencia": "A"
                },
                {
                    "id": 2,
                    "numero": "8763221",
                    "idTipo": "2",
                    "tipoLicencia": "B"
                },
                {
                    "id": 3,
                    "numero": "8763221",
                    "idTipo": "3",
                    "tipoLicencia": "C"
                }   
              ]
            }
        ]';

        $operatorsData = json_decode($operatorsJson, true);

        if ($operatorsData === null) {
            throw new HttpBadRequestException(202, 'Error al decodificar el JSON de operadores.');
        }

        return $idEmpresa !== null 
        ? current(array_filter($operatorsData, fn($operator) => $operator['idEmpresa'] == $idEmpresa)) 
        : $operatorsData;
    }

    public function routes()
    {
        $routesJson = '[
            {
                "id": 1,
                "nombre": "Ruta 1"
            },
            {
                "id": 2,
                "nombre": "Ruta 2"
            },
            {
                "id": 3,
                "nombre": "Ruta 3"
            },
            {
                "id": 4,
                "nombre": "Ruta 4"
            },
            {
                "id": 5,
                "nombre": "Ruta 5"
            },
            {
                "id": 6,
                "nombre": "Ruta 6"
            }
        ]';

        $routesData = json_decode($routesJson, true);

        if ($routesData === null) {
            throw new HttpBadRequestException(202, 'Error al decodificar el JSON de rutas.');
        }
        return $routesData;
    }

    public function tipovehicles()
    {
        $sql = 'SELECT
                tv.iid AS id, 
                tv.txtnombre AS nombre
            FROM
                vehiculo.tbl_cat_tipo_vehiculo AS tv
            WHERE 
                tv.bactivo = true';

        $process = Db::fetchAll($sql);
        return $process;
    }
}