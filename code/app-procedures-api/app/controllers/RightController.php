<?php

namespace App\Controllers;

use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use Vokuro\GenericSQL\GenericSQL;
use Phalcon\Registry;
use \App\Library\Http\Exceptions\HttpBadRequestException;

class RightController extends BaseController
{
    
    public function right($vclave=null)
    {
        $sql = 'SELECT 
                    ctd.iid AS "idTramiteDerecho",
                    ctd.iidderecho AS "idDerecho",
                    cd.vclave AS "claveDerecho",
                    cd.txtnombre AS "nombreDerecho",
                    cd.txtdescripcion AS "descripcionDerecho",
                    cd.numa_maximo AS "UMAMaximo",
                    cd.numa_minimo AS "UMAMinimo",
                    150.00 AS "UMAValor"
                   FROM 
                    comun.tbl_cat_tramite_derecho ctd
                LEFT JOIN comun.tbl_cat_derecho cd ON ctd.iidderecho = cd.iid
                WHERE
                    ctd.bactivo = true';
        
        if ($vclave !== null) {
            $sql .= ' AND cd.vclave = ' . $vclave;
        }
        $sql .= ' ORDER BY cd.txtnombre';
        $result = GenericSQL::getBySQL($sql);
        return $result;
    }
}