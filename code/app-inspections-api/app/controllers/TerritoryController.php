<?php

namespace App\Controllers;

use Phalcon\Registry;
use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Http\Exceptions\ValidatorBoomException;

class TerritoryController extends BaseController
{

    private function hasClientAuthorized($permission)
    {

        $permissions = $this->token->getPermissions()['iin']; // Obtener permisos del token de usuario
        if (!in_array($permission, $permissions)) { // Comprobar si el permiso está presente en los permisos del usuario
            if ($permission === 'veii' && in_array('edii', $permissions)) return; // Permitir acceso si es edpe pero no vepe
            throw new HttpUnauthorizedException(401, 'Permisos insuficientes.'); // Excepción de no autorizado si no se tienen los permisos necesarios
        }
    }

    // Método para depurar y mostrar datos
    public function dep($data)
    {
        $format  = print_r('<pre>');
        $format .= print_r($data);
        $format .= print_r('</pre>');
        return $format;
    }

    public function getAllPostalCodes()
    {
        $default = 50; // Mérida
        $params = array('iclave_municipio' => $default);
        $sql = "SELECT 
                    icodigo_postal
                FROM 
                    territorio.tbl_cat_colonia
                WHERE 
                    bactivo='t' AND iclave_municipio = :iclave_municipio
                GROUP BY 
                    icodigo_postal;
        ";
        $postalCodes = Db::fetchAll($sql, $params);
        return $postalCodes;
    }

    public function getMunicipalityAndEntityByPostalCode()
    {
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $params = array('icodigo_postal' => $data);
        $sql = "SELECT DISTINCT ON (m.txtnombre)
                    m.txtnombre AS entity,
                    e.txtnombre AS municipality
                FROM
                    territorio.tbl_cat_colonia AS c
                JOIN
                    territorio.tbl_cat_municipio AS m ON c.iclave_municipio = m.iclave_municipio
                JOIN
                    territorio.tbl_cat_estado AS e ON m.iclave_estado = e.iclave_estado
                WHERE
                    c.icodigo_postal = :icodigo_postal";
        $municipalityAndEntity = Db::fetchOne($sql, $params);
        return $municipalityAndEntity;
    }

    public function getColoniesByPostalCode()
    {
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $params = array('icodigo_postal' => $data);
        $sql = "SELECT 
                    iid AS iidcolonia,
                    txtnombre,
                    icodigo_postal,
                    bactivo AS activo,
                    TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
                    TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
                FROM 
                    territorio.tbl_cat_colonia
                WHERE 
                    bactivo='t' AND icodigo_postal = :icodigo_postal";

        $colonies = Db::fetchAll($sql, $params);
        return $colonies;
    }

}
