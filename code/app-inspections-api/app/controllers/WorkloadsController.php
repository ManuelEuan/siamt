<?php

namespace App\Controllers;

use Phalcon\Registry;
use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Http\Exceptions\ValidatorBoomException;

class WorkloadsController extends BaseController
{

    private function hasClientAuthorized($permission)
    {
        $permissions = $this->token->getPermissions()['ica']; // Obtener permisos del token de usuario
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

    public function getStructureFormWorkloads(){
        $formulario = [
            'iidzona' => [
                'label' => 'Seleccione el módulo*',
                'type' => 'autocomplete',
                'model' => 'iidzona',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6,
                'array' => ['type' => 'object', 'info' => self::getAllZones(), 'item_text' => 'txtnombre', 'item_value' => 'iidzona']
            ],
            'txtnombre' => [
                'label' => 'Nombre',
                'type' => 'text',
                'model' => 'txtnombre',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6
            ],
            'dfecha_inicial' => (object)array(
                'label' => '´Fecha inicio',
                'type' => 'date',
                'model' => 'dfecha_inicial',
                'rules' => null,
                'cols' => 12,
                'md' => 4
            ),
            'dfecha_final' => (object)array(
                'label' => 'Fecha final',
                'type' => 'date',
                'model' => 'dfecha_final',
                'rules' => null,
                'cols' => 12,
                'md' => 4
            ),
            'txtcomentario' => [
                'label' => 'Nombre',
                'type' => 'textarea',
                'model' => 'txtcomentario',
                'rules' => 'required',
                'cols' => 12,
                'md' => 12
            ],
            // 'bactivo' => [
            //     'label' => 'Activo',
            //     'type' => 'boolean',
            //     'model' => 'bactivo',
            //     'cols' => 6,
            //     'md' => 4
            // ],
        ];
        return $formulario;
    }

    public function getAllZones()
    {
        $sql = "SELECT 
            iidzona,
            txtnombre,
            bactivo AS activo,
            TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
            TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
            FROM territorio.cat_zona
            WHERE bactivo='t'
        ";
        $zones = Db::fetchAll($sql);
        return $zones;
    }

}
