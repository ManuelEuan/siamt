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

    public function getAllStages()
    {
        $sql = "SELECT 
                ce.iidetapa,
                ce.txtnombre AS txtetapa_nombre,
                ce.txtdescripcion,
                ce.txtsigla,
                ce.iidproceso,
                tp.txtnombre AS txtproceso_nombre,
                ce.txtcolor,
                ce.txtpermiso,
                ce.binicial,
                ce.bfinal,
                ce.bcancelacion,
                ce.brequiere_motivo,
                ce.bactivo AS activo,
                TO_CHAR(ce.dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
                TO_CHAR(ce.dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion,
                tp.iidmodulo,
                m.nombre AS txtproceso_modulo_nombre,
                m.descripcion AS txtproceso_modulo_descripcion
            FROM 
                comun.cat_etapa ce
            JOIN 
                comun.cat_proceso tp ON ce.iidproceso = tp.iidproceso
            JOIN 
                usuario.modulo m ON tp.iidmodulo = m.id
            WHERE 
                ce.bactivo = 't';
        ";
        $stages = Db::fetchAll($sql);
        return $stages;
    }

    public function getInfoBySubStage()
    {
        $data = $this->request->getJsonRawBody();

        // PROCESOS CON DATA
        // VERIFICAR SI ES LA ÚLTIMA DEL FLUJO
        $currentSubStage = $this->subStage($data->idOfSubStage);
        // ---------------------------------------------------------- UN FLUJO ----------------------------------------------------------
        // $nextSubStage = $this->getNextSubStageFromFlow($data->idOfSubStage);
        // $currentFlow=['currentSubStage' => $currentSubStage, 'nextSubStage'=>$nextSubStage];
        // ---------------------------------------------------------- MAS DE UN FLUJO ----------------------------------------------------------
        // $getNextsSubStages = $this->getNextSubStageFromFlow($data->idOfSubStage);
        // if(count($getNextsSubStages) == 1){
        //     self::dep('SOLO 1');
        //     $nextSubStage = $this->getNextSubStageFromFlow($data->idOfSubStage);
        // }elseif(count($getNextsSubStages)>1){
        //     self::dep('mas de 1');
        // }
        // ---------------------------------------------------------- demos ----------------------------------------------------------
        $nextSubStage = $this->getNextSubStageFromFlow($data->idOfSubStage);
        // self::dep($nextSubStage);
        // exit;
        $currentFlow=['currentSubStage' => $currentSubStage, 'nextSubStage'=>$nextSubStage];
        // else{
        //     self::dep('ninguno');
        // }
        // self::dep($data);
        // self::dep($nextSubStage);
        // exit;
        $followUp = []; // ACA SE VA A RECUPERAR EL HISTORIAL POR EL QUE PASÓ O SE ESCOGIÓ, NO ES OBLIGATORIO
        if ($data->idOfType) {
            $followUp = $this->getDinamycTrace($data->type, $data->idOfType);
        }
        // self::dep($currentFlow['currentSubStage']->iidsubetapa);exit;
        $getProcessBySubStage = $this->getProcessBySubStage($data->idOfSubStage);
        
        // PROCESO GENERAL
        $getStagesByProcess = $this->getStagesByProcess($getProcessBySubStage->iidproceso);
        if(count($getStagesByProcess)>0){
            foreach($getStagesByProcess as $key => $stage){
                $subStages = $this->getSubStagesByStage($stage->iidetapa);
                foreach($subStages as $keySubStage => $subStage){
                    if(in_array($subStage->iidsubetapa, $followUp['onlySubStages'])){
                        // echo 'el: '.$subStage->iidsubetapa. ' se ha encontrado';
                        $historicStatus = 'pasado';
                    }elseif($subStage->iidsubetapa == $currentFlow['currentSubStage']->iidsubetapa){
                        // echo 'es la actual: '.$subStage->iidsubetapa. ' ';
                        $historicStatus = 'actualmente';
                    }else{
                        $historicStatus = 'pendiente';
                        // echo 'el: '.$subStage->iidsubetapa. ' no se ha encontrado';
                    }
                    $subStages[$keySubStage]->historicStatus = $historicStatus;
                }
                $getStagesByProcess[$key]->subStages = $subStages;
            }
        }
        // self::dep($getStagesByProcess);exit;

        $getProcessBySubStage->etapas = $getStagesByProcess;
        // self::dep($getProcessBySubStage->etapas);exit;
        $allFlow = $getProcessBySubStage;
        $allData = ['currentFlow' => $currentFlow, 'followUp' => $followUp, 'allFlow' => $allFlow];
        // self::dep($allData);
        // exit;
        return $allData;
    }

    public function getStagesByProcess($iidproceso)
    {
        $sql = "SELECT
                    etapa.iidetapa, 
                    etapa.txtnombre AS nombre_etapa, 
                    etapa.txtsigla AS sigla_etapa, 
                    etapa.txtdescripcion AS descripcion_etapa, 
                    etapa.txtcolor AS color_etapa, 
                    etapa.txtpermiso AS permiso_etapa
                FROM
                    comun.cat_etapa AS etapa
                WHERE bactivo='t' AND iidproceso = :iidproceso
        ";
        $params = array('iidproceso' => $iidproceso);
        $stages = Db::fetchAll($sql, $params);
        return $stages;
    }

    public function getSubStagesByStage($iidStage){
        $sql = "SELECT 
                s.iidsubetapa,
                s.txtnombre,
                s.txtsigla,
                s.txtdescripcion,
                s.txtcolor,
                s.txtpermiso,
                s.binicial,
                s.bfinal,
                s.bcancelacion,
                s.brequiere_motivo,
                s.iidetapa
            FROM 
                comun.cat_subetapa s
            JOIN 
                comun.cat_etapa e ON s.iidetapa = e.iidetapa
            WHERE 
                s.bactivo = 't' AND e.iidetapa = :iidStage
        ";
        $params = array('iidStage' => $iidStage);
        $subStage = Db::fetchAll($sql, $params);
        return $subStage;
    }

    public function getProcessBySubStage($iidSubStage){
        $sql = "SELECT
                    cat_proceso.iidproceso, 
                    cat_proceso.iidmodulo, 
                    cat_proceso.txtnombre, 
                    cat_proceso.txtsigla, 
                    cat_proceso.txtdescripcion, 
                    cat_proceso.bactivo
                FROM
                    comun.cat_proceso
                    INNER JOIN
                    comun.cat_etapa ON cat_proceso.iidproceso = cat_etapa.iidproceso
                    INNER JOIN
                    comun.cat_subetapa ON cat_etapa.iidetapa = cat_subetapa.iidetapa
                WHERE cat_proceso.bactivo = 't' AND cat_subetapa.iidsubetapa = :iidsubetapa;
        ";
        $params = array('iidsubetapa' => $iidSubStage);
        $process = Db::fetch($sql, $params);
        return $process;
    }

    public function getDinamycTrace($type, $idOfSearch)
    {
        // $this->hasClientAuthorized('veii'); // Verificar si el cliente tiene autorización
        if(!$type && !$idOfSearch){
            $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
            $type = $data->request->type;
            $idOfSearch = $data->request->idOfSearch;
        }
        if ($type == 'Inspector') {
            $sql = "SELECT 
                        insp.iidinspector_seguimiento,
                        insp.iidinspector,
                        insp.iidetapa_anterior,
                        insp.iidsubetapa_anterior,
                        insp.iidetapa_actual,
                        insp.iidsubetapa_actual,
                        etapa_anterior.txtnombre AS nombre_etapa_anterior,
                        subetapa_anterior.txtnombre AS nombre_subetapa_anterior,
                        etapa_actual.txtnombre AS nombre_etapa_actual,
                        subetapa_actual.txtnombre AS nombre_subetapa_actual
                    FROM 
                        inspeccion.tbl_inspector_seguimiento AS insp
                    JOIN 
                        comun.cat_etapa AS etapa_anterior ON insp.iidetapa_anterior = etapa_anterior.iidetapa
                    JOIN 
                        comun.cat_etapa AS etapa_actual ON insp.iidetapa_actual = etapa_actual.iidetapa
                    JOIN 
                        comun.cat_subetapa AS subetapa_anterior ON insp.iidsubetapa_anterior = subetapa_anterior.iidsubetapa
                    JOIN 
                        comun.cat_subetapa AS subetapa_actual ON insp.iidsubetapa_actual = subetapa_actual.iidsubetapa
                    WHERE 
                        insp.iidinspector = :idOfSearch
                        AND insp.bactivo = 't';
            ";
        }

        $params = array('idOfSearch' => $idOfSearch); // Parámetros para la consulta
        $foundRequest = Db::fetchAll($sql, $params);
        $onlyStages=[];
        $onlySubStages=[];
        foreach($foundRequest as $key => $found){
            array_push($onlyStages, $found->iidetapa_anterior);
            array_push($onlySubStages, $found->iidsubetapa_anterior);
        }
        $foundRequest['onlyStages'] = $onlyStages;
        $foundRequest['onlySubStages'] = $onlySubStages;
        // self::dep($foundRequest);exit;
        return $foundRequest; // Devolver información del inspector
    }

    public function subStage($iidSubStage)
    {
        $sql = "SELECT 
                    s.iidsubetapa,
                    s.txtnombre AS subetapa_nombre,
                    s.txtsigla,
                    s.txtdescripcion,
                    s.txtcolor,
                    s.txtpermiso,
                    s.binicial,
                    s.bfinal,
                    s.bcancelacion,
                    s.brequiere_motivo,
                    s.iidetapa,
                    e.iidproceso,
                    e.txtnombre AS etapa_nombre
                FROM 
                    comun.cat_subetapa s
                JOIN 
                    comun.cat_etapa e ON s.iidetapa = e.iidetapa
                WHERE 
                    s.bactivo = 't' AND s.iidsubetapa = :iidsubetapa
        ";
        $params = array('iidsubetapa' => $iidSubStage);
        return Db::fetch($sql, $params);
    }

    public function getNextSubStageFromFlow($iidSubStage, $allFlow = false){
        $sql = "SELECT iidsubetapa_siguiente
                FROM comun.cat_flujo
                WHERE iidsubetapa = :iidsubetapa
                AND bactivo = true";
        $params = array('iidsubetapa' => $iidSubStage);
        $currentFlow = Db::fetchAll($sql, $params);
    
        // Inicializamos un arreglo para almacenar los valores
        $nextSubStages = array();
    
        // Recorremos los resultados y extraemos los valores
        foreach ($currentFlow as $row) {
            
            // $nextSubStages[] = $row->iidsubetapa_siguiente;
            $nextSubStages[] = $this->subStage($row->iidsubetapa_siguiente);
        }
        // self::dep($nextSubStages);
        // self::dep($nextSubStages); -----------
        // exit;
        // Devolvemos el arreglo con los valores extraídos
        return $nextSubStages;
    }
    
    

    public function newDinamycSubStage()
    {
        // Obtener datos de la solicitud HTTP
        $data = $this->request->getJsonRawBody();

        // Mapeo de propiedades entre Vue y PHP
        $propertyMappings = [
            'Inspector' => ['iidColumn' => 'iidinspector', 'primaryTable' => 'inspeccion.tbl_inspector', 'trackingTable' => 'inspeccion.tbl_inspector_seguimiento'],
            'Boleta' => ['iidColumn' => 'iidboleta', 'primaryTable' => 'inspeccion.tbl_boleta', 'trackingTable' => 'inspeccion.tbl_boleta_seguimiento'],
            // Agrega más mapeos aquí si es necesario
        ];

        // Verifica que exista un tipo
        if (!isset($data->type) || !isset($propertyMappings[$data->type])) {
            throw new \Exception('Tipo de solicitud no válido');
        }

        $type = $data->type;
        $idOfType = $data->idOfType;
        $iidetapa_anterior = $data->iidetapa_anterior;
        $iidsubetapa_anterior = $data->iidsubetapa_anterior;
        $iidetapa_nueva = $data->iidetapa_nueva;
        $iidsubetapa_nueva = $data->iidsubetapa_nueva;

        // Iniciar transacción en la base de datos
        Db::begin();

        try {
            // Actualización de la tabla principal
            $sqlPrimaryTable = "UPDATE {$propertyMappings[$type]['primaryTable']} SET 
                    iidetapa=:iidetapa,
                    iidsubetapa=:iidsubetapa,
                    dtfecha_modificacion=:dtfecha_modificacion
                WHERE {$propertyMappings[$type]['iidColumn']}=:idOfType";

            $paramsPrimaryTable = [
                'iidetapa' => $iidetapa_nueva,
                'iidsubetapa' => $iidsubetapa_nueva,
                'dtfecha_modificacion' => date('Y-m-d H:i:s'),
                'idOfType' => $idOfType,
            ];

            // Ejecutar consulta SQL para actualizar la tabla principal
            Db::execute($sqlPrimaryTable, $paramsPrimaryTable);

            $params = array(
                $propertyMappings[$type]['iidColumn'] => $idOfType,
                'iidetapa_anterior' => $iidetapa_anterior,
                'iidsubetapa_anterior' => $iidsubetapa_anterior,
                'iidetapa_actual' => $iidetapa_nueva,
                'iidsubetapa_actual' => $iidsubetapa_nueva,
            );

            // $idOfTracking = $this->insert('tbl_persona', $params);
            $this->insert($propertyMappings[$type]['trackingTable'], $params);


            // Confirmar transacción en la base de datos
            Db::commit();

            // Devolver mensaje de éxito
            $info = [
                'type'=> $type, //type-dinamyc
                'idOfType'=> $iidsubetapa_nueva, //iid-dinamyc
                'idOfSubStage'=> 0, //iidsubStage
                'idOfNextSubStage'=> 0, //iidsubStage
                'finalizeProcess'=> false,
            ];
            return ['success' => true, 'message' => 'Actualización satisfactoria.', 'info' => $iidsubetapa_nueva];
        } catch (\Exception $e) {
            // Revertir transacción en caso de error
            Db::rollback();
            // Lanzar excepción para manejo adicional
            throw $e;
        }
    }

    // Método para insertar datos en la base de datos
    private function insert($table, $params)
    {
        $cols = implode(', ', array_keys($params)); // Obtener nombres de columnas
        $phs = ':' . str_replace(', ', ', :', $cols); // Obtener marcadores de posición para los valores
        $sql = "INSERT INTO $table ($cols) VALUES ($phs)"; // Consulta de inserción
        return Db::execute($sql, $params); // Ejecutar inserción en la base de datos
    }
}
