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
                'md' => 6
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
                'array' => ['type' => 'object', 'info' => self::getAllInspector('Coordinador'), 'item_text' => 'txtnombre_completo', 'item_value' => 'iidinspector']
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
                'array' => ['type' => 'object', 'info' => self::getAllInspector('Inspector'), 'item_text' => 'txtnombre_completo', 'item_value' => 'iidinspector']
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
        $allForms = [
            'inputsGeneralForm'=>$inputsGeneralForm, 
            'inputsTurnsForm'=>$inputsTurnsForm, 
            'inputsInspectorsForm'=>$inputsInspectorsForm,
            'inputsWorksForm'=>$inputsWorksForm
        ];
        return $allForms;
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

    public function getAllShifts()
    {
        $sql = "SELECT 
                iidturno,
                txtnombre,
                thora_inicio,
                thora_fin,
                bactivo AS activo,
                TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
                TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
                FROM inspeccion.cat_turno
                WHERE bactivo='t'
        ";
        $shifts = Db::fetchAll($sql);
        return $shifts;
    }

    public function getAllTypesWorkload()
    {
        $sql = "SELECT 
                iidcarga_trabajo_tipo,
                txtnombre,
                txtdescripcion,
                breten,
                bactivo AS activo,
                TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
                TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
                FROM inspeccion.cat_carga_trabajo_tipo
                WHERE bactivo='t'
        ";
        $typesWorkload = Db::fetchAll($sql);
        return $typesWorkload;
    }

    

    public function getAllInspector($type = '')
    {
        $sql = "SELECT
                    i.iidinspector,
                    i.iidpersona,
                    i.iidetapa,
                    CASE 
                        WHEN p.txtapemat != '' THEN 
                            CONCAT(p.txtnombre, ' ', p.txtapepat, ' ', p.txtapemat)
                        ELSE 
                            CONCAT(p.txtnombre, ' ', p.txtapepat) 
                    END AS txtnombre_completo,
                    ca.txtnombre as txtinspector_etapa,
                    cas.txtnombre as txtinspector_subetapa,
                    i.txtfolio_inspector,
                    i.iidturno,
                    it.txtnombre as txtinspector_turno,
                    p.txtrfc,
                    p.txtcurp,
                    p.txtine,
                    i.iidinspector_categoria,
                    ic.txtnombre as txtinspector_categoria,
                    TO_CHAR(i.dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
                    TO_CHAR(i.dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
                FROM inspeccion.tbl_inspector i
                JOIN persona.tbl_persona p ON i.iidpersona = p.iidpersona
                JOIN inspeccion.cat_turno it ON it.iidturno = i.iidturno
                JOIN comun.cat_etapa ca ON ca.iidetapa = i.iidetapa
                JOIN comun.cat_subetapa cas ON cas.iidsubetapa = i.iidsubetapa
                JOIN inspeccion.cat_inspector_categoria ic ON ic.iidinspector_categoria = i.iidinspector_categoria
                WHERE i.bactivo='t'
        ";
        if($type){
            $sql = $sql . " AND ic.txtnombre ='" . $type."'";
        }
        $inspectors = Db::fetchAll($sql);
        return $inspectors;
    }

}
