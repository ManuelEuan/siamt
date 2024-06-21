<?php

namespace App\Controllers;

use Phalcon\Registry;
use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Http\Exceptions\ValidatorBoomException;
// MODELOS TERRITORIO
use App\Models\Territory\Colonies;
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
        return Colonies::getAllPostalCodes();
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
        $postalCode = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        return Colonies::getColoniesByPostalCode($postalCode);
    }

}
