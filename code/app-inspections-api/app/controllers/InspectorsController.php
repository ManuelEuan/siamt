<?php

namespace App\Controllers;

use Phalcon\Registry;
use Vokuro\GenericSQL\GenericSQL;
use App\Library\Misc\Utils;
use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Http\Exceptions\ValidatorBoomException;

// MODELOS TERRITORIO
use App\Models\Territory\Zones;
// MODELOS INSPECCIONES
use App\Models\Inspection\Inspectors;
use App\Models\Inspection\InspectorsCategories;
use App\Models\Inspection\Shifts;


// use App\Models\Users;
class InspectorsController extends BaseController
{


    private function hasClientAuthorized($permission)
    {
        $permissions = $this->token->getPermissions()['iin']; // Obtener permisos del token de usuario
        if (!in_array($permission, $permissions)) { // Comprobar si el permiso está presente en los permisos del usuario
            if ($permission === 'veii' && in_array('edii', $permissions)) return; // Permitir acceso si es edpe pero no vepe
            throw new HttpUnauthorizedException(401, 'Permisos insuficientes.'); // Excepción de no autorizado si no se tienen los permisos necesarios
        }
    }
    
    public function dep($data)
    {
        $format  = print_r('<pre>');
        $format .= print_r($data);
        $format .= print_r('</pre>');
        return $format;
    }

    public function getServiceVindenUrlDebitaciones()
    {
        if (!$_SESSION['vinden']['token']) {
            Utils::getTokenVinden();
        }
        $baseUrl = $_SESSION['vinden']['baseUrl'];
        $clientId = $_SESSION['vinden']['clientId'];
        $token = $_SESSION['vinden']['token'];
        $url = $baseUrl . '?client_id=' . $clientId . '&authorize=' . $token;
        return $url;
    }


    public function demoMultipleDemo(){
        return Inspectors::getMultipleConexion();
    }
    // Obtener inspectores
    public function getInspectors()
    {
        $data =  $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        return Inspectors::getAllFilteredAndPaginatedInspectors($data);
    }

    public function getAllCategoriesInspector()
    {
        return InspectorsCategories::getAllInspectorsCategories();
    }

    public function getAllFlowBySubStage($iidSubStage)
    {
        // $data = $this->request->getJsonRawBody();

        $sql = "WITH cte_flujo AS (
            SELECT iidsubetapa, iidsubetapa_siguiente
            FROM comun.cat_flujo
            WHERE iidsubetapa = :iidsubetapa -- Cambiar a la sintaxis de parámetro según tu entorno
              AND bactivo = true
        ),
        cte_subetapa_actual AS (
            SELECT 
                cs.iidsubetapa AS iidsubetapa_actual, cs.txtnombre AS nombre_subetapa_actual, cs.txtsigla AS sigla_subetapa_actual, 
                cs.txtdescripcion AS descripcion_subetapa_actual, cs.txtcolor AS color_subetapa_actual, 
                cs.txtpermiso AS permiso_subetapa_actual, cs.binicial AS inicial_subetapa_actual, 
                cs.bfinal AS final_subetapa_actual, cs.bcancelacion AS cancelacion_subetapa_actual, 
                cs.brequiere_motivo AS requiere_motivo_subetapa_actual, cs.iidetapa
            FROM comun.tbl_cat_subetapa cs
        ),
        cte_etapa AS (
            SELECT 
                e.iidetapa, e.iidproceso, e.txtnombre AS nombre_etapa, e.txtsigla AS sigla_etapa, 
                e.txtdescripcion AS descripcion_etapa, e.txtcolor AS color_etapa, 
                e.txtpermiso AS permiso_etapa, e.binicial AS inicial_etapa, 
                e.bfinal AS final_etapa, e.bcancelacion AS cancelacion_etapa, 
                e.brequiere_motivo AS requiere_motivo_etapa
            FROM comun.tbl_cat_etapa e
        )
        SELECT 
            f.iidsubetapa AS iidsubetapa_actual, f.iidsubetapa_siguiente, 
            currentSubStage.nombre_subetapa_actual, currentSubStage.sigla_subetapa_actual, currentSubStage.descripcion_subetapa_actual, 
            currentSubStage.color_subetapa_actual, currentSubStage.permiso_subetapa_actual, currentSubStage.inicial_subetapa_actual, 
            currentSubStage.final_subetapa_actual, currentSubStage.cancelacion_subetapa_actual, currentSubStage.requiere_motivo_subetapa_actual, 
            currentSubStage.iidetapa AS iidetapa_subetapa_actual,
            nextSubStage.iidsubetapa AS iidsubetapa_siguiente,
            nextSubStage.txtnombre AS nombre_subetapa_siguiente, nextSubStage.txtsigla AS sigla_subetapa_siguiente, nextSubStage.txtdescripcion AS descripcion_subetapa_siguiente, 
            nextSubStage.txtcolor AS color_subetapa_siguiente, nextSubStage.txtpermiso AS permiso_subetapa_siguiente, nextSubStage.binicial AS inicial_subetapa_siguiente, 
            nextSubStage.bfinal AS final_subetapa_siguiente, nextSubStage.bcancelacion AS cancelacion_subetapa_siguiente, nextSubStage.brequiere_motivo AS requiere_motivo_subetapa_siguiente, 
            nextSubStage.iidetapa AS iidetapa_subetapa_siguiente,
            etapa.nombre_etapa, etapa.sigla_etapa, etapa.descripcion_etapa, 
            etapa.color_etapa, etapa.permiso_etapa, etapa.inicial_etapa, 
            etapa.final_etapa, etapa.cancelacion_etapa, etapa.requiere_motivo_etapa,
            etapa.iidproceso
        FROM 
            cte_flujo f
            JOIN cte_subetapa_actual currentSubStage ON f.iidsubetapa = currentSubStage.iidsubetapa_actual
            JOIN cte_etapa etapa ON currentSubStage.iidetapa = etapa.iid
            JOIN comun.tbl_cat_subetapa nextSubStage ON f.iidsubetapa_siguiente = nextSubStage.iidsubetapa;
        
        ";
        $params = array('iidsubetapa' => $iidSubStage);

        $allFlow = Db::fetchOne($sql, $params);
        return $allFlow;
    }

    public function hasFlowAfter()
    {
        $data = $this->request->getJsonRawBody();
        $sql = "SELECT 
            iidsubetapa,
            bactivo AS activo
            FROM comun.cat_flujo
            WHERE bactivo='t' AND iidsubetapa = :iidsubetapa
        ";
        $params = array('iidsubetapa' => $data->iidsubetapa);
        $registro = Db::fetch($sql, $params);
        return $registro;
    }

    public function getDinamycFollow($type, $idOfType){
        if ($type == 'Inspector') {
            // Buscar en el seguimiento de inspectores (iidinspector)
            $sql = "SELECT 
                iseg.iidinspector_seguimiento,
                iseg.iidinspector,
                iseg.iidetapa_anterior,
                iseg.iidetapa_actual,
                iseg.bactivo,

                sub_ant.iidetapa AS iidetapa_anterior,
                etapa_ant.txtnombre AS nombre_etapa_anterior,
                sub_ant.iidsubetapa AS iidsubetapa_anterior,
                sub_ant.txtnombre AS nombre_subetapa_anterior,
                sub_ant.txtsigla AS sigla_subetapa_anterior,
                sub_ant.txtdescripcion AS descripcion_subetapa_anterior,
                sub_ant.txtcolor AS color_subetapa_anterior,

                sub_act.iidetapa AS iidetapa_actual,
                etapa_act.txtnombre AS nombre_etapa_actual,
                sub_act.iidsubetapa AS iidsubetapa_actual,
                sub_act.txtnombre AS nombre_subetapa_actual,
                sub_act.txtsigla AS sigla_subetapa_actual,
                sub_act.txtdescripcion AS descripcion_subetapa_actual,
                sub_act.txtcolor AS color_subetapa_actual
            FROM 
                inspeccion.tbl_inspector_seguimiento AS iseg
            JOIN 
                comun.tbl_cat_subetapa AS sub_ant ON iseg.iidsubetapa_anterior = sub_ant.iidsubetapa
            JOIN 
                comun.tbl_cat_subetapa AS sub_act ON iseg.iidsubetapa_actual = sub_act.iidsubetapa
            JOIN 
                comun.tbl_cat_etapa AS etapa_ant ON iseg.iidetapa_anterior = etapa_ant.iidetapa
            JOIN 
                comun.tbl_cat_etapa AS etapa_act ON iseg.iidetapa_actual = etapa_act.iidetapa
            WHERE  
                -- iseg.iidinspector = 3
                iseg.bactivo = 't' AND iseg.iidinspector = :iidinspector
            ";
            $params = array('iidinspector' => $idOfType);
            return Db::fetch($sql, $params);
        }
    }

    public function getAllSubStagesInspector()
    {
        $this->hasClientAuthorized('veii'); // Verificar si el cliente tiene autorización
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        if (empty($data->stage)) throw new ValidatorBoomException(422, 'Etapa requerida.'); // Lanzar excepción si el ID está vacío
        $params = array('iidetapa' => $data->stage); // Parámetros para la consulta
        $sql = "
            SELECT
                i.iidinspector,
                i.iidpersona,
                i.iidetapa,
                ca.txtnombre as txtinspector_etapa,
                i.txtfolio_inspector,
                i.iidturno,
                i.txtcomentarios,
                it.txtnombre as txtinspector_turno,
                p.txtnombre,
                p.txtapellido_paterno,
                p.txtapellido_materno,
                p.txtrfc,
                p.txtcurp,
                p.txtine,
                i.iidinspector_categoria,
                ic.txtnombre as txtinspector_categoria,
                i.dvigencia,
                i.dfecha_alta,
                i.dfecha_baja,
                i.bactivo as activo,
                TO_CHAR(i.dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
                TO_CHAR(i.dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
            FROM inspeccion.tbl_inspector i
            JOIN persona.tbl_persona p ON i.iidpersona = p.iid
            JOIN inspeccion.tbl_cat_turno it ON i.iidturno = it.iid
            JOIN comun.tbl_cat_etapa ca ON i.iidetapa = ca.iid
            JOIN inspeccion.tbl_cat_inspector_categoria ic ON i.iidinspector_categoria = ic.iid
            WHERE iid=:id
        ";
        $inspector = Db::fetchOne($sql, $params);
        return $inspector; // Devolver información del inspector
    }

    public function getAllShiftsInspector()
    {
        return Shifts::getAllShifts();
    }
    // Obtener información de un inspector
    public function getInspectorInfo()
    {
        $this->hasClientAuthorized('veii'); // Verificar si el cliente tiene autorización
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        return Inspectors::getInspectorInfo($data->id);
    }

    // // Método para crear un inspector
    public function createInspector()
    {
        $this->hasClientAuthorized('crii'); // Verificar si el cliente tiene autorización

        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $this->validRequiredData($data, 'createInspector'); // Validar datos requeridos
        Db::begin(); // Iniciar transacción en la base de datos

        $params = array(
            'iidpersona'  => $data->iidpersona,
            'iidturno' => $data->iidturno,
            'iidetapa' => $data->iidetapa,
            'iidsubetapa' => $data->iidsubetapa,
            'iidinspector_categoria' => $data->iidinspector_categoria,
            'txtfolio_inspector' => $data->txtfolio_inspector,
            'dvigencia' => $data->dvigencia,
            'dfecha_alta' => $data->dfecha_alta !== '' ? $data->dfecha_alta : null,
            'dfecha_baja' => $data->dfecha_baja !== '' ? $data->dfecha_baja : null,
            'txtcomentarios' => $data->txtcomentarios,
        );

        $iidinspector = $this->insert('tbl_inspector', $params, true);
        
        $params = array(
            'iidinspector' => $iidinspector,
            'iidetapa_anterior' => 1,
            'iidsubetapa_anterior' => 1,
            'iidetapa_actual' => 1,
            'iidsubetapa_actual' => 1,
        );

        $this->insert('tbl_inspector_seguimiento', $params);

        Db::commit(); // Confirmar transacción en la base de datos
        return array('message' => 'El inspector ha sido creado.'); // Devolver mensaje de éxito
    }

    // // Método para crear el seguimiento del proceso de captura de inspector
    public function insertInspectorTrace()
    {
        $this->hasClientAuthorized('crii'); // Verificar si el cliente tiene autorización
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $data = $data->dataTrace;
        $this->validRequiredData($data, 'insertInspectorTrace'); // Validar datos requeridos
        Db::begin(); // Iniciar transacción en la base de datos

        $params = array(
            'iidinspector' => $data->iidinspector,
            'iidetapa_anterior' => $data->iidetapa_anterior,
            'iidsubetapa_anterior' => $data->iidsubetapa_anterior,
            'iidetapa_actual' => $data->iidetapa_actual,
            'iidsubetapa_actual' => $data->iidsubetapa_actual,
        );

        $this->insert('tbl_inspector_seguimiento', $params);

        Db::commit(); // Confirmar transacción en la base de datos
        return array('success' => true, 'message' => 'El seguimiento del inspector se ha guardado con éxito.'); // Devolver mensaje de éxito
    }

    // // Método para actualizar un inspector
    public function updateInspector()
    {
        $this->hasClientAuthorized('edii'); // Verificar si el cliente tiene autorización
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $this->validRequiredData($data, 'updateInspector'); // Validar datos requeridos
        Db::begin(); // Iniciar transacción en la base de datos

        // Actualización de inspector
        $sql = 'UPDATE inspeccion.tbl_inspector SET 
                iidturno=:iidturno,
                txtfolio_inspector=:txtfolio_inspector,
                iidinspector_categoria=:iidinspector_categoria,
                iidetapa=:iidetapa,
                txtcomentarios=:txtcomentarios,
                dvigencia=:dvigencia,
                dfecha_baja=:dfecha_baja,
                bactivo=:bactivo,
                dfecha_alta=:dfecha_alta,
                dtfecha_modificacion=:dtfecha_modificacion
            WHERE iid=:iidinspector
        ';
        $params = array(
            'iidturno'  => $data->iidturno,
            'txtfolio_inspector' => $data->txtfolio_inspector,
            'iidinspector_categoria' => $data->iidinspector_categoria,
            'iidetapa' => $data->iidetapa,
            'txtcomentarios' => $data->txtcomentarios,
            'dvigencia' => $data->dvigencia,
            'dfecha_baja' => $data->dfecha_baja !== '' ? $data->dfecha_baja : null,
            'bactivo' => $data->activo ? 't' : 'f',
            'dfecha_alta' => $data->dfecha_alta !== '' ? $data->dfecha_alta : null,
            'dtfecha_modificacion' => date('Y-m-d H:i:s'), // Formato de fecha correcto
            'iidinspector'      => $data->iidinspector,
        ); // Parámetros para la actualización del inspector

        Db::execute($sql, $params); // Ejecutar actualización del inspector en la base de datos
        Db::commit(); // Confirmar transacción en la base de datos

        return array('message' => 'El inspector ha sido actualizado.'); // Devolver mensaje de éxito
    }

    // // Método para eliminar un inspector
    public function deleteInspector($iidinspector)
    {
        $this->hasClientAuthorized('boii'); // Verificar si el cliente tiene autorización

        $sql = "SELECT bactivo FROM inspeccion.tbl_inspector WHERE iidinspector=:iidinspector"; // Consulta para obtener estado activo del inspector
        $params = array('iidinspector' => $iidinspector); // Parámetros para la consulta
        $bactivo = Db::fetchColumn($sql, $params); // Obtener estado activo del inspector
        $sql = "UPDATE inspeccion.tbl_inspector SET bactivo=:bactivo WHERE iidinspector=:iidinspector"; // Consulta para actualizar estado activo del inspector
        $params = array('bactivo' => $bactivo ? 'f' : 't', 'iidinspector' => $iidinspector); // Si esta activo lo pone en falso, y viceversa
        Db::execute($sql, $params); // Ejecutar actualización del estado activo del inspector
        $msg = $bactivo ? 'desactivado' : 'activado'; // Mensaje de confirmación
        return array('message' => "El inspector ha sido $msg."); // Devolver mensaje de éxito
    }

   
    // // Método para insertar datos en la base de datos
    private function insert($table, $params)
    {
        $cols = implode(', ', array_keys($params)); // Obtener nombres de columnas
        $phs = ':' . str_replace(', ', ', :', $cols); // Obtener marcadores de posición para los valores
        $sql = "INSERT INTO inspeccion.$table ($cols) VALUES ($phs)"; // Consulta de inserción
        return Db::execute($sql, $params); // Ejecutar inserción en la base de datos
    }

    // // Método para validar datos requeridos
    private function validRequiredData($data, $from)
    {
        switch ($from) {
            case 'createInspector':
            case 'updateInspector':
                $requiredKeys = array('iidpersona', 'iidturno', 'iidetapa', 'iidinspector_categoria'); // Claves requeridas
                break;
            case 'updateInspectorSubStage':
                $requiredKeys = array('iidinspector', 'iidetapa', 'iidsubetapa'); // Claves requeridas
                break;
            case 'insertInspectorTrace':
                $requiredKeys = array('iidinspector', 'iidetapa_anterior', 'iidsubetapa_anterior', 'iidetapa_actual', 'iidsubetapa_actual'); // Claves requeridas
                break;
            default:
                $message = "Falta de información.";
                throw new ValidatorBoomException(422, $message);
                break;
        }

        // $requiredKeys = array('iidpersona', 'iidturno', 'iidetapa', 'iidinspector_categoria'); // Claves requeridas
        $actualKeys = array_keys(get_object_vars($data)); // Claves presentes en los datos
        $missingKeys = array_diff($requiredKeys, $actualKeys); // Claves faltantes
        $message = 'Faltan valores requeridos.';

        if (!empty($missingKeys)) throw new ValidatorBoomException(422, $message);

        foreach ($data as $key => $value) {
            if (!in_array($key, $requiredKeys)) continue;
            // Validar tipos de valores según la clave
            switch ($key) {
                case 'iidinspector':
                case 'iidpersona':
                case 'iidturno':
                case 'iidetapa':
                case 'iidsubetapa':
                case 'iidetapa_anterior':
                case 'iidsubetapa_anterior':
                case 'iidetapa_actual':
                case 'iidsubetapa_actual':
                case 'iidinspector_categoria':
                    $message = "Tipo de valor incorrectos en $key.";
                    if (!is_int($value)) throw new ValidatorBoomException(422, $message);
                    break;
                default:
                    $message = "Tipo de valor incorrecto en $key.";
                    if (!is_string($value)) throw new ValidatorBoomException(422, $message);
                    $message = "Valor vacío en $key.";
                    if (empty(trim($value))) throw new ValidatorBoomException(422, $message);
                    break;
            }
        }
    }
}
