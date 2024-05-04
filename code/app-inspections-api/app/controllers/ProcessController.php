<?php

namespace App\Controllers;

use Phalcon\Registry;
use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Http\Exceptions\ValidatorBoomException;

class ProcessController extends BaseController
{

    // private function hasClientAuthorized($permission)
    // {

    //     $permissions = $this->token->getPermissions()['iin']; // Obtener permisos del token de usuario
    //     if (!in_array($permission, $permissions)) { // Comprobar si el permiso está presente en los permisos del usuario
    //         if ($permission === 'veii' && in_array('edii', $permissions)) return; // Permitir acceso si es edpe pero no vepe
    //         throw new HttpUnauthorizedException(401, 'Permisos insuficientes.'); // Excepción de no autorizado si no se tienen los permisos necesarios
    //     }
    // }

    // Método para depurar y mostrar datos
    public function dep($data)
    {
        $format  = print_r('<pre>');
        $format .= print_r($data);
        $format .= print_r('</pre>');
        return $format;
    }

    public function newDinamycSubStage()
    {
        // self::dep('lleguuuue');exit;
        // $this->hasClientAuthorized('edii'); // Verificar si el cliente tiene autorización
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        // exit;
        $this->validRequiredData($data, 'updateInspectorSubStage'); // Validar datos requeridos
        Db::begin(); // Iniciar transacción en la base de datos

        // Actualización de inspector
        $sql = 'UPDATE inspeccion.tbl_inspector SET 
                iidetapa=:iidetapa,
                iidsubetapa=:iidsubetapa,
                dtfecha_modificacion=:dtfecha_modificacion
            WHERE iidinspector=:iidinspector
        ';
        $params = array(
            'iidetapa' => $data->iidetapa,
            'iidsubetapa' => $data->iidsubetapa,
            'dtfecha_modificacion' => date('Y-m-d H:i:s'), // Formato de fecha correcto
            'iidinspector'      => $data->iidinspector,
        ); // Parámetros para la actualización de una sub etapa

        Db::execute($sql, $params); // Ejecutar actualización del inspector en la base de datos
        Db::commit(); // Confirmar transacción en la base de datos

        return array('success' => true, 'message' => 'La sub etapa ha sido actualizada.'); // Devolver mensaje de éxito
    }


}
