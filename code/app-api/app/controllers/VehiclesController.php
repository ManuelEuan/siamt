<?php

namespace App\Controllers;
use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use Vokuro\GenericSQL\GenericSQL;
use \App\Library\Http\Exceptions\HttpBadRequestException;

class VehiclesController extends BaseController
{

    public function typeVehicles()
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

    public function getVehicles($iidempresa = null)
    {
        set_time_limit(0);
        ini_set('memory_limit', '-1');
        
        $data = $this->request->getJsonRawBody();
        $where = ''; 
        $conditions = []; 
        if (isset($data->idConcesion) && is_numeric($data->idConcesion) && $data->idConcesion !== "") {
            $conditions[] = 'ev.iidconcesion = ' . (int)$data->idConcesion;
        }
        
        if (isset($data->idMarca) && is_numeric($data->idMarca) && $data->idMarca !== "") {
            $conditions[] = 'ma.iid = ' . (int)$data->idMarca;
        }
        
        if (isset($data->idModelo) && is_numeric($data->idModelo) && $data->idModelo !== "") {
            $conditions[] = 'mo.iid = ' . (int)$data->idModelo;
        }

        // Unir las condiciones con AND
        if (!empty($conditions)) {
            $where = implode(' AND ', $conditions);
        }

        $sql = 'SELECT
                        ev.iid AS "id",
                        ev.iidvehiculo AS "idVehiculo",
                        vp.txtplaca AS "placa",
                        ma.iid AS "idMarca",
                        ma.txtnombre AS "nombreMarca",
                        ev.iidempresa AS "idEmpresa",
                        TRIM(p.nombre_completo) AS "nombreEmpresa",
                        ev.vnomenclatura || \'-\' || ev.inumero_economico AS "numeroEconomico",

                        v.txtnumero_serie AS "serie",
                        v.txtnumero_chasis AS "chasis",
                        vm.txtnumero AS "motor",
                        mo.txtnombre AS "modelo",
                        -- mo.iid AS "idModelo",
                        v.ianio AS "anio",
                        v.ikm_actual AS "km",
                        c.txtnombre AS "nombreConcesion",
                        -- c.iid AS "idConcesion",
                        tv.txtnombre AS "tipoVehiculo",
                        vc.txtnombre AS "tipoCombustible",
                        ver.npeso AS "peso",
                        ver.nlargo AS "largo",
                        ver.nancho AS "ancho",
                        ver.ipasajeros_sentados AS "pasajerosSentados",
                        ver.ipasajeros_pie AS "pasajerosPie",
                        ver.ipasajeros AS "totalPasajeros"

                FROM 
                    transporte.tbl_empresa_vehiculo ev
                INNER JOIN 
                    transporte.tbl_empresa e ON ev.iidempresa = e.iid
                INNER JOIN 
                    transporte.tbl_concesion c ON ev.iidconcesion = c.iid
                LEFT JOIN
                    vehiculo.tbl_vehiculo_motor vm ON ev.iidvehiculo = vm.iidvehiculo
                LEFT JOIN
                    vehiculo.tbl_cat_tipo_combustible vc ON vm.iidtipo_combustible = vm.iid
                INNER JOIN 
                    persona.tbl_persona p ON e.iidpersona = p.iid
                INNER JOIN
                    vehiculo.tbl_vehiculo v ON ev.iidvehiculo = v.iid
                INNER JOIN
                    vehiculo.tbl_cat_version ver ON v.iidversion = ver.iid
                INNER JOIN 
                    vehiculo.tbl_cat_tipo_vehiculo tv ON v.iidtipo = tv.iid
                INNER JOIN 
                    vehiculo.tbl_cat_modelo mo ON v.iidmodelo = mo.iid
                INNER JOIN
                    vehiculo.tbl_cat_marca ma ON mo.iidmarca = ma.iid
                INNER JOIN 
                    vehiculo.tbl_vehiculo_placa vp ON ev.iidvehiculo = vp.iidvehiculo AND vp.bactual = true AND vp.bactivo = true
                WHERE ev.bactivo=true';
        
        
        if (!empty($where)) {
            $sql .= ' WHERE ' . $where;
        }

        if ($iidempresa !== null) {
            $sql .= ' AND ev.iidempresa = ' . $iidempresa;
        }

        $sql .= ' ORDER BY p.nombre_completo';
        $result = GenericSQL::getBySQL($sql);
        // echo $sql;
        // die;

        return $result;
    }


    public function getBrand()
    {

        $sql = 'SELECT
                    iid AS "id",
                    txtnombre AS "nombre"  
                FROM 
                    vehiculo.tbl_cat_marca
                WHERE 
                    bactivo = true';

        $sql .= ' ORDER BY txtnombre';
        $result = GenericSQL::getBySQL($sql);
        return $result;
    }

    public function getModel()
    {

        $sql = 'SELECT
                    mo.iid AS "id",
                    mo.txtnombre AS "nombreModelo",
                    ma.iid AS "idMarca",
                    ma.txtnombre AS "nombreMarca"
                FROM 
                    vehiculo.tbl_cat_modelo mo
                INNER JOIN
                    vehiculo.tbl_cat_marca ma ON mo.iidmarca = ma.iid
                WHERE 
                    mo.bactivo = true and ma.bactivo = true';

        $sql .= ' ORDER BY mo.txtnombre';
        $result = GenericSQL::getBySQL($sql);
        return $result;
    }

    public function getFuelType()
    {

        $sql = 'SELECT
                    iid AS "id",
                    txtnombre AS "nombre"  
                FROM 
                    vehiculo.tbl_cat_tipo_combustible
                WHERE 
                    bactivo = true';

        $sql .= ' ORDER BY txtnombre';
        $result = GenericSQL::getBySQL($sql);
        return $result;
    }
}



