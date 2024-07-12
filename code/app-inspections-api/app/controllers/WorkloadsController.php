<?php

namespace App\Controllers;

use Phalcon\Registry;
use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Http\Exceptions\ValidatorBoomException;

// MODELOS COMUNES - TERRITORIO
use Vokuro\GenericSQL\Territory\Zones;

// MODELOS INSPECCIONES
use App\Models\Inspection\Shifts;
use App\Models\Inspection\TypesWorkload;
use App\Models\Inspection\Inspectors;

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
        $inputsGeneralForm = [
            'txtnombre' => [
                'label' => 'Nombre',
                'type' => 'text',
                'model' => 'txtnombre',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6
            ],
            'iidzona' => [
                'label' => 'Seleccione la zona*',
                'type' => 'autocomplete',
                'model' => 'iidzona',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6,
                'array' => ['type' => 'object', 'info' => self::getAllZones(), 'item_text' => 'txtnombre', 'item_value' => 'iidzona']
            ],
            'dfecha_inicial' => (object)array(
                'label' => 'Fecha inicio',
                'type' => 'date',
                'model' => date("Y-m-d"),
                'rules' => null,
                'cols' => 12,
                'md' => 6,
                'min' => date("Y-m-d")
            ),
            'dfecha_final' => (object)array(
                'label' => 'Fecha final',
                'type' => 'date',
                'model' => 'dfecha_final',
                'rules' => null,
                'cols' => 12,
                'md' => 6,
                'min' => date("Y-m-d")
            ),
            'txtdescripcion' => [
                'label' => 'Descripción',
                'type' => 'textarea',
                'model' => 'txtdescripcion',
                'rules' => 'required',
                'cols' => 12,
                'md' => 12
            ],
        ];
        $inputsTurnsForm = [
            'iidturno' => [
                'label' => 'Seleccione el turno*',
                'type' => 'autocomplete',
                'model' => 'iidturno',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6,
                'array' => ['type' => 'object', 'info' => self::getAllShifts(), 'item_text' => 'txtnombre', 'item_value' => 'iidturno']
            ],
            'iidinspector' => [
                'label' => 'Seleccione el coordinador*',
                'type' => 'autocomplete',
                'model' => 'iidinspector',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6,
                'array' => ['type' => 'object', 'info' => self::getAllInspectorByType('Coordinador'), 'item_text' => 'txtnombre_completo', 'item_value' => 'iidinspector']
            ],
        ];
        $inputsInspectorsForm = [
            'iidturno' => [
                'label' => 'Seleccione el turno*',
                'type' => 'autocomplete',
                'model' => 'iidturno',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6,
                'array' => ['type' => 'object', 'info' => self::getAllShifts(), 'item_text' => 'txtnombre', 'item_value' => 'iidturno']
            ],
            'iidinspector' => [
                'label' => 'Seleccione el inspector*',
                'type' => 'autocomplete',
                'model' => 'iidinspector',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6,
                'array' => ['type' => 'object', 'info' => self::getAllInspectorByType('Inspector'), 'item_text' => 'txtnombre_completo', 'item_value' => 'iidinspector']
            ],
        ];
        $inputsWorksForm = [
            'iidcarga_trabajo_tipo' => [
                'label' => 'Seleccione la zona*',
                'type' => 'autocomplete',
                'model' => 'iidcarga_trabajo_tipo',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6,
                'array' => ['type' => 'object', 'info' => self::getAllTypesWorkload(), 'item_text' => 'txtnombre', 'item_value' => 'iidcarga_trabajo_tipo']
            ],
            'txtdescripcion' => [
                'label' => 'Descripción',
                'type' => 'textarea',
                'model' => 'txtdescripcion',
                'rules' => 'required',
                'cols' => 12,
                'md' => 12
            ],
            'txtlatitud' => [
                'label' => 'Latitud',
                'type' => 'text',
                'model' => 'txtlatitud',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6
            ],
            'txtlongitud' => [
                'label' => 'Longitud',
                'type' => 'text',
                'model' => 'txtlongitud',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6
            ],
            'dtfecha_hora_inicio' => [
                'label' => 'Fecha hora inicio',
                'type' => 'datetime',
                'model' => 'dtfecha_hora_inicio',
                'rules' => null,
                'cols' => 12,
                'md' => 6
            ],
            'dtfecha_hora_fin' => [
                'label' => 'Fecha hora fin',
                'type' => 'datetime',
                'model' => 'dtfecha_hora_fin',
                'rules' => null,
                'cols' => 12,
                'md' => 6
            ],
           
        ];
        $inputsAforosForm = [
            'iidcarga_trabajo_tipo' => [
                'label' => 'Seleccione la zona*',
                'type' => 'autocomplete',
                'model' => 'iidcarga_trabajo_tipo',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6,
                'array' => ['type' => 'object', 'info' => self::getAllTypesWorkload(), 'item_text' => 'txtnombre', 'item_value' => 'iidcarga_trabajo_tipo']
            ],
            'txtdescripcion' => [
                'label' => 'Descripción',
                'type' => 'textarea',
                'model' => 'txtdescripcion',
                'rules' => 'required',
                'cols' => 12,
                'md' => 12
            ],
            'txtlatitud' => [
                'label' => 'Latitud',
                'type' => 'text',
                'model' => 'txtlatitud',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6
            ],
            'txtlongitud' => [
                'label' => 'Longitud',
                'type' => 'text',
                'model' => 'txtlongitud',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6
            ],
            'dtfecha_hora_inicio' => [
                'label' => 'Fecha hora inicio',
                'type' => 'datetime',
                'model' => 'dtfecha_hora_inicio',
                'rules' => null,
                'cols' => 12,
                'md' => 6
            ],
            'dtfecha_hora_fin' => [
                'label' => 'Fecha hora fin',
                'type' => 'datetime',
                'model' => 'dtfecha_hora_fin',
                'rules' => null,
                'cols' => 12,
                'md' => 6
            ], 
        ];
        $allForms = [
            'inputsGeneralForm'=>$inputsGeneralForm, 
            'inputsTurnsForm'=>$inputsTurnsForm, 
            'inputsInspectorsForm'=>$inputsInspectorsForm,
            'inputsWorksForm'=>$inputsWorksForm,
            'inputsAforosForm'=>$inputsAforosForm
        ];
        return $allForms;
    }

    public function getAllZones()
    {
        return Zones::getDemoModel();
    }

    public function getAllShifts()
    {
        return Shifts::getAllShifts();
    }

    public function getAllTypesWorkload()
    {
        return TypesWorkload::getAllTypesWorkload();
    }

    public function getAllInspectorByType($type = '')
    {
        
        return Inspectors::getAllInspectorByType($type);

    }

}
