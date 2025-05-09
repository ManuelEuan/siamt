<?php

namespace App\Controllers;

use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use Vokuro\GenericSQL\Common\Configuration;
use Vokuro\GenericSQL\GenericSQL;
use Phalcon\Registry;
use \App\Library\Http\Exceptions\HttpBadRequestException;

class RightController extends BaseController
{
    
    public function right($vclave = null)
    {
        $valorUma = 0;
        $conf = Configuration::findFirst("txtclave = 'VALORUMA' and bactivo");
        if($conf)
            $valorUma = floatval($conf->txtvalor);
        $sql = 'SELECT 
                    ctd.iid AS "idTramiteDerecho",
                    ctd.iidderecho AS "idDerecho",
                    cd.vclave AS "claveDerecho",
                    cd.txtnombre AS "nombreDerecho",
                    cd.txtdescripcion AS "descripcionDerecho",
                    cd.numa_maximo AS "UMAMaximo",
                    cd.numa_minimo AS "UMAMinimo",
                    '.$valorUma.' AS "UMAValor"
                FROM 
                    comun.tbl_cat_tramite_derecho ctd
                INNER JOIN comun.tbl_cat_derecho cd ON ctd.iidderecho = cd.iid
                INNER JOIN comun.tbl_cat_tramite ct ON ctd.iidtramite = ct.iid
                WHERE
                    ctd.bactivo = true and cd.bactivo = true and ct.bactivo= true';

        if ($vclave !== null) {
            $sql .= " AND ct.vclave = '" . $vclave . "'";
        }

        $sql .= ' ORDER BY cd.txtnombre';
        $result = GenericSQL::getBySQL($sql);
        return $result;
    }

}