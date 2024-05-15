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
    public function dinamycRegisterInProcess()
    {
        $data =  $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP

        $itemsPerPage = $data->itemsPerPage; // Obtener número de ítems por página
        $offset = ($data->page - 1) * $itemsPerPage; // Calcular offset
        $typeRegister = $data->filters->typeRegister ? $data->filters->typeRegister : 'Proceso';
        switch ($typeRegister) {
            case 'Proceso':
                $sql = "WITH registers AS (
                        SELECT 
                            dinamyc.iidproceso AS iidOfType,
                            dinamyc.iidmodulo,
                            dinamyc.txtnombre,
                            dinamyc.txtdescripcion,
                            dinamyc.txtsigla,
                            dinamyc.bactivo,
                            TO_CHAR(dinamyc.dtfecha_creacion, 'YYYY-MM-DD HH24:MI') AS dtfecha_creacion,
                            TO_CHAR(dinamyc.dtfecha_modificacion, 'YYYY-MM-DD HH24:MI') AS dtfecha_modificacion
                        FROM comun.cat_proceso AS dinamyc)
                        ";
                break;
            case 'Etapa':
                $sql = "WITH registers AS (
                            SELECT 
                                dinamyc.iidetapa AS iidOfType,
                                dinamyc.iidproceso,
                                dinamyc.txtnombre,
                                dinamyc.txtsigla,
                                dinamyc.txtdescripcion,
                                dinamyc.txtcolor,
                                dinamyc.txtpermiso,
                                dinamyc.binicial,
                                dinamyc.bfinal,
                                dinamyc.bcancelacion,
                                dinamyc.brequiere_motivo,
                                dinamyc.bactivo,
                                TO_CHAR(dinamyc.dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS dtfecha_creacion,
                                TO_CHAR(dinamyc.dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS dtfecha_modificacion
                            FROM comun.cat_etapa AS dinamyc)
                        ";
                break;
            case 'Subetapa':
                $sql = "WITH registers AS (
                            SELECT 
                                dinamyc.iidsubetapa AS iidOfType,
                                dinamyc.iidetapa,
                                dinamyc.txtnombre,
                                dinamyc.txtsigla,
                                dinamyc.txtdescripcion,
                                dinamyc.txtcolor,
                                dinamyc.txtpermiso,
                                dinamyc.binicial,
                                dinamyc.bfinal,
                                dinamyc.bcancelacion,
                                dinamyc.brequiere_motivo,
                                dinamyc.bactivo,
                                TO_CHAR(dinamyc.dtfecha_creacion, 'YYYY-MM-DD HH24:MI') AS dtfecha_creacion,
                                TO_CHAR(dinamyc.dtfecha_modificacion, 'YYYY-MM-DD HH24:MI') AS dtfecha_modificacion
                            FROM comun.cat_subetapa dinamyc)
                        ";
                break;
        }
        $params = array();
        if ($data->filters) { // Aplicar filtros si están presentes en la solicitud
            list($sql2, $params2) = $this->filterRegisters($data->filters); // Aplicar filtros
            $sql .= $sql2; // Agregar filtros a la consulta principal
            $params += $params2; // Agregar parámetros de los filtros
        } else {
            $sql .= 'SELECT *, COUNT(registers.iidOfType) OVER() AS total_registers FROM registers '; // Obtener perfiles sin filtros
        }
        $sql .= $this->sortRegisters($data->sortBy, $data->sortDesc); // Ordenar inspectores

        if ($itemsPerPage > 0) { // Si se especifica un número de ítems por página
            $sql .= 'LIMIT :items OFFSET :offset'; // Limitar resultados por página
            $params['items'] = $itemsPerPage; // Añadir parámetro de ítems por página
            $params['offset'] = $offset; // Añadir parámetro de offset
        }
        // self::dep($sql);
        // exit;
        $registers = Db::fetchAll($sql, $params); // Ejecutar consulta para obtener inspectores      
        $totalItems = $registers[0]->total_registers ?? 0; // Obtener total de inspectores
        $totalPages = ceil($totalItems / $itemsPerPage); // Calcular total de páginas

        return array(
            'dinamycRegisterInProcess' => $registers, // Devolver inspectores
            'totalPages' => $totalPages, // Devolver total de páginas
            'totalItems' => $totalItems, // Devolver total de ítems
        );
    }

    private function filterRegisters($filters)
    {
        $params = [];
        $sql = "SELECT *, COUNT(registers.iidOfType) OVER() AS total_registers FROM registers ";
        $sql2 = 'WHERE '; // Inicializar fragmento de consulta para filtros
        foreach ($filters as $filter => $value) { // Para cada filtro
            if (empty($value) || $filter == 'typeRegister') continue; // Si el valor del filtro está vacío o es para roles, continuar al siguiente filtro
            if ($sql2 !== 'WHERE ') $sql2 .= 'AND '; // Si no es el primer filtro, añadir "AND"
            switch ($filter) { // Según el filtro
                case 'typeRegister': // Filtro por nombre
                    break;
                case 'name': // Filtro por nombre
                    $sql2 .= "registers.txtnombre ILIKE :name "; // Condición para nombre (ignorando mayúsculas y minúsculas)
                    $params['name'] = '%' . $filters->name . '%'; // Parámetro para nombre
                    break;
                case 'turno': // Filtro por turno
                    $sql2 .= "registers.txtinspector_turno ILIKE :turno "; // Condición para nombre (ignorando mayúsculas y minúsculas)
                    $params['turno'] = '%' . $filters->turno . '%'; // Parámetro para nombre
                    break;
                case 'categoria': // Filtro por categoria
                    $sql2 .= "registers.txtinspector_categoria ILIKE :categoria "; // Condición para nombre (ignorando mayúsculas y minúsculas)
                    $params['categoria'] = '%' . $filters->categoria . '%'; // Parámetro para nombre
                    break;
                case 'active': // Filtro por estado activo
                    $sql2 .= 'registers.bactivo = :active '; // Condición para estado activo
                    $params['active'] = $filters->active; // Parámetro para estado activo
                    break;
            }
        }
        if ($sql2 !== 'WHERE ') $sql .= $sql2; // Si se agregaron filtros, añadirlos a la consulta principal
        return array($sql, $params); // Devolver consulta y parámetros
    }

    // // Método para ordenar inspectores
    private function sortRegisters($sortBy, $sortDesc)
    {
        $sortCount = count($sortBy); // Contar cantidad de criterios de ordenamiento
        if ($sortCount === 0) return 'ORDER BY registers.iidOfType '; // Si no hay criterios, ordenar por ID por defecto

        $sql = 'ORDER BY '; // Inicializar fragmento de consulta para ordenamiento
        $comma = $sortCount - 1; // Último índice para agregar coma

        for ($i = 0; $i < $sortCount; $i++) { // Para cada criterio de ordenamiento
            $order = $sortDesc[$i] ? 'DESC ' : 'ASC '; // Determinar orden ascendente o descendente
            $column = $sortBy[$i]; // Obtener columna para ordenamiento

            switch ($column) { // Según la columna
                case 'txtnombre': // Ordenar por nombre completo
                    $sql .= 'registers.txtnombre '; // Agregar columna de nombre completo
                    break;
                case 'txtdescripcion': // Ordenar por usuario
                    $sql .= 'registers.txtdescripcion '; // Agregar columna de usuario
                    break;

                case 'txtsigla': // Ordenar por correo
                    $sql .= 'registers.txtsigla '; // Agregar columna de correo
                    break;
                case 'activo': // Ordenar por estado activo
                    $sql .= 'registers.bactivo '; // Agregar columna de estado activo
                    break;
                default: // Si no se reconoce la columna
                    $sql .= 'registers.iidOfType '; // Ordenar por ID
            }

            $sql .= "$order NULLS LAST"; // Añadir orden y manejo de nulos
            $sql .= $i < $comma ? ', ' : ' '; // Agregar coma si no es el último criterio
        }

        return $sql; // Devolver fragmento de consulta para ordenamiento
    }

    public function getAllModules()
    {
        // $default = 50; // Mérida
        // $params = array('iclave_municipio' => $default);
        $sql = "SELECT 
                    id, nombre
                FROM 
                    usuario.modulo
                WHERE 
                    activo='t';
        ";
        $modules = Db::fetchAll($sql);
        return $modules;
    }

    public function getAllSubStages()
    {
        // $default = 50; // Mérida
        // $params = array('iclave_municipio' => $default);
        $sql = "SELECT 
                    iidsubetapa, txtnombre
                FROM 
                    comun.cat_subetapa
                WHERE 
                    activo='t';
        ";
        $subStages = Db::fetchAll($sql);
        return $subStages;
    }

    public function getAllProcess()
    {
        $sql = "SELECT 
            iidproceso,
            iidmodulo,
            txtnombre,
            txtdescripcion,
            txtsigla,
            bactivo AS activo,
            TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
            TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
            FROM comun.cat_proceso
            WHERE bactivo='t'
        ";
        $processes = Db::fetchAll($sql);
        return $processes;
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
        $currentFlow = ['currentSubStage' => $currentSubStage, 'nextSubStage' => $nextSubStage];
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
        if (count($getStagesByProcess) > 0) {
            foreach ($getStagesByProcess as $key => $stage) {
                $subStages = $this->getSubStagesByStage($stage->iidetapa);
                foreach ($subStages as $keySubStage => $subStage) {
                    if (in_array($subStage->iidsubetapa, $followUp['onlySubStages'])) {
                        // echo 'el: '.$subStage->iidsubetapa. ' se ha encontrado';
                        $historicStatus = 'pasado';
                    } elseif ($subStage->iidsubetapa == $currentFlow['currentSubStage']->iidsubetapa) {
                        // echo 'es la actual: '.$subStage->iidsubetapa. ' ';
                        $historicStatus = 'actualmente';
                    } else {
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

    public function getProcessWithStagesAndSubstages()
    {
        // PROCESO GENERAL
        $data = $this->request->getJsonRawBody();
        $getStagesByProcess = $this->getStagesByProcess($data->iidproceso);
        if (count($getStagesByProcess) > 0) {
            foreach ($getStagesByProcess as $key => $stage) {
                $subStages = $this->getSubStagesByStage($stage->iidetapa);
                // self::dep($subStages);
                //   foreach ($subStages as $keySubStage => $subStage) {
                //   if (in_array($subStage->iidsubetapa, $followUp['onlySubStages'])) {
                //       // echo 'el: '.$subStage->iidsubetapa. ' se ha encontrado';
                //       $historicStatus = 'pasado';
                //   } elseif ($subStage->iidsubetapa == $currentFlow['currentSubStage']->iidsubetapa) {
                //       // echo 'es la actual: '.$subStage->iidsubetapa. ' ';
                //       $historicStatus = 'actualmente';
                //   } else {
                //       $historicStatus = 'pendiente';
                //       // echo 'el: '.$subStage->iidsubetapa. ' no se ha encontrado';
                //   }
                //   $subStages[$keySubStage]->historicStatus = $historicStatus;
                //   }
                $getStagesByProcess[$key]->subStages = $subStages;
            }
        }
        // self::dep($getStagesByProcess);
        // exit;
        return $getStagesByProcess;
    }


    // $objetoInicial= [
    //     "iidsubetapa"=> 1,
    //     "iidetapa"=> 1,
    //     "txtnombre"=> "Entrevista",
    //     "txtsigla"=> "MJC1",
    //     "txtdescripcion"=> "Ejemplo subetapa 1",
    //     "txtcolor"=> "orange",
    //     "txtpermiso"=> null,
    //     "binicial"=> true,
    //     "bfinal"=> false,
    //     "bcancelacion"=> false,
    //     "brequiere_motivo"=> false,
    //     "bactivo"=> true,
    //     "dtfecha_creacion"=> "2024-03-28 11=>25",
    //     "dtfecha_modificacion"=> "2024-03-28 11=>25",
    //     "total_registers"=> 12
    // ];
    // $objetoInicial = json_decode(json_encode($objetoInicial));
    public function getFlowByProcess()
    {
        $data = $this->request->getJsonRawBody();
        $getStagesByProcess = $this->getStagesByProcess($data->iidproceso);
        $objetoInicial = null;

        foreach ($getStagesByProcess as $stage) {
            $subStages = $this->getSubStagesByStage($stage->iidetapa);
            foreach ($subStages as $subStage) {
                if ($subStage->binicial) {
                    $objetoInicial = $this->construirArbol($subStage, $subStage->iidsubetapa);
                    break 2; // Salir de ambos bucles
                }
            }
        }

        if (!$objetoInicial) {
            return ['success' => true, 'message' => 'No se ha encontrado una etapa inicial, favor de configurar'];
        }

        $formattedObject = $this->formatObjectForJavaScript($objetoInicial);

        return ['success' => true, 'message' => 'Flujo encontrado.', 'info' => $objetoInicial, 'info2' => $formattedObject];
    }

    // Función para convertir el objeto PHP en un array asociativo
    function objectToArray($object)
    {
        return json_decode(json_encode($object), true);
    }

    // Función para formatear el objeto en el formato JavaScript deseado
    function formatObjectForJavaScript($object)
    {
        $formattedItems = [];

        foreach ($object->children as $child) {
            $formattedChild = [
                'id' => $child->iidsubetapa,
                'name' => $child->subetapa_nombre,
                'children' => $this->formatObjectForJavaScript($child)
            ];

            $formattedItems[] = $formattedChild;
        }

        return $formattedItems;
    }


    public function getNextSubStageFromFlow($iidSubStage)
    {
        $sql = "SELECT iidsubetapa_siguiente
                FROM comun.cat_flujo
                WHERE iidsubetapa = :iidsubetapa
                AND bactivo = true";
        $params = array('iidsubetapa' => $iidSubStage);
        $currentFlow = Db::fetchAll($sql, $params);

        $nextSubStages = array();
        foreach ($currentFlow as $row) {
            $nextSubStages[] = $this->subStage($row->iidsubetapa_siguiente);
        }

        return $nextSubStages;
    }

    // Función para construir el árbol
    function construirArbol($objetoInicial, $getNextSubStageFunction, $processedSubStages = array())
    {
        $nextSubStages = $this->getNextSubStageFromFlow($getNextSubStageFunction);

        // Si no hay subetapas siguientes o ya hemos procesado esta subetapa, retornamos el objeto inicial
        if (empty($nextSubStages) || in_array($objetoInicial->iidsubetapa, $processedSubStages)) {
            return $objetoInicial;
        }

        // Añadimos la subetapa actual al conjunto de subetapas procesadas
        $processedSubStages[] = $objetoInicial->iidsubetapa;

        $objetoInicial->children = array();
        foreach ($nextSubStages as $subStage) {
            // Llamamos recursivamente a construirArbol solo si no hemos procesado esta subetapa antes
            $objetoInicial->children[] = $this->construirArbol($subStage, $subStage->iidsubetapa, $processedSubStages);
        }
        return $objetoInicial;
    }

    // Función para imprimir el árbol en formato JSON
    function imprimirArbol($arbol)
    {
        echo json_encode($arbol, JSON_PRETTY_PRINT);
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

    public function getSubStagesByStage($iidStage)
    {
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

    public function getProcessBySubStage($iidSubStage)
    {
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
        if (!$type && !$idOfSearch) {
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
        $onlyStages = [];
        $onlySubStages = [];
        foreach ($foundRequest as $key => $found) {
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
                'type' => $type, //type-dinamyc
                'idOfType' => $iidsubetapa_nueva, //iid-dinamyc
                'idOfSubStage' => 0, //iidsubStage
                'idOfNextSubStage' => 0, //iidsubStage
                'finalizeProcess' => false,
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

    public function newRegisterInProcess()
    {
        // Obtener datos de la solicitud HTTP
        $data = $this->request->getJsonRawBody();


        // Verifica que exista un tipo
        if (!isset($data->typeRegister)) {
            throw new \Exception('Tipo de solicitud no válido');
        }

        $this->validRequiredData($data, $data->typeRegister); // Validar datos requeridos
        // self::dep($data);
        // exit;
        try {
            Db::begin(); // Iniciar transacción en la base de datos

            switch ($data->typeRegister) {
                case 'Proceso':
                    $table = 'comun.cat_proceso';
                    $params = array(
                        'iidmodulo'  => $data->iidmodulo,
                        'txtnombre' => $data->txtnombre,
                        'txtdescripcion' => $data->txtdescripcion,
                        'txtsigla' => $data->txtsigla,
                        'dtfecha_creacion' => date('Y-m-d H:i:s'),
                    );
                    break;
                case 'Etapa':
                    $table = 'comun.cat_etapa';
                    $params = array(
                        'iidproceso'  => $data->iidproceso,
                        'txtnombre' => $data->txtnombre,
                        'txtdescripcion' => $data->txtdescripcion,
                        'txtsigla' => $data->txtsigla,
                        'txtcolor' => $data->txtcolor,
                        'txtpermiso' => $data->txtpermiso,
                        'binicial' => $data->binicial,
                        'bfinal' => $data->bfinal,
                        'bcancelacion' => $data->bcancelacion,
                        'brequiere_motivo' => $data->brequiere_motivo,
                        'dtfecha_creacion' => date('Y-m-d H:i:s'),
                    );
                    break;
                case 'Subetapa':
                    $table = 'comun.cat_subetapa';
                    $params = array(
                        'iidetapa'  => $data->iidetapa,
                        'txtnombre' => $data->txtnombre,
                        'txtdescripcion' => $data->txtdescripcion,
                        'txtsigla' => $data->txtsigla,
                        'txtcolor' => $data->txtcolor,
                        'txtpermiso' => $data->txtpermiso,
                        'binicial' => $data->binicial,
                        'bfinal' => $data->bfinal,
                        'bcancelacion' => $data->bcancelacion,
                        'brequiere_motivo' => $data->brequiere_motivo,
                        'dtfecha_creacion' => date('Y-m-d H:i:s'),
                    );
                    break;
                default:
                    $message = "Tipo de dato no capturado, contacte al administrador.";
                    throw new ValidatorBoomException(422, $message);
                    break;
            }


            $iidDinamyc = $this->insert($table, $params, true);

            Db::commit(); // Confirmar transacción en la base de datos
            return ['success' => true, 'message' => 'Registro exitoso.', 'info' => $iidDinamyc];
        } catch (\Exception $e) {
            // Revertir transacción en caso de error
            Db::rollback();
            // Lanzar excepción para manejo adicional
            throw $e;
        }
    }

    public function updateRegisterInProcess()
    {
        // $this->hasClientAuthorized('edtp'); // Verificar si el cliente tiene autorización
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        // Verifica que exista un tipo
        if (!isset($data->typeRegister)) {
            throw new \Exception('Tipo de solicitud no válido');
        }

        $this->validRequiredData($data, $data->typeRegister); // Validar datos requeridos
        // self::dep($data);
        // exit;
        try {
            Db::begin();
            switch ($data->typeRegister) {
                case 'Proceso':
                    $sql = 'UPDATE comun.cat_proceso SET 
                                iidmodulo=:iidmodulo,
                                txtnombre=:txtnombre,
                                txtdescripcion=:txtdescripcion,
                                txtsigla=:txtsigla,
                                bactivo=:bactivo,
                                dtfecha_modificacion=:dtfecha_modificacion
                            WHERE iidproceso=:iidproceso
                    ';
                    $params = array(
                        'iidmodulo'  => $data->iidmodulo,
                        'txtnombre' => $data->txtnombre,
                        'txtdescripcion' => $data->txtdescripcion,
                        'txtsigla' => $data->txtsigla,
                        'bactivo' => $data->bactivo ? 't' : 'f',
                        'dtfecha_modificacion' => date('Y-m-d H:i:s'), // Formato de fecha correcto
                        'iidproceso'      => $data->iidoftype,
                    );
                    break;
                case 'Etapa':
                    $sql = 'UPDATE comun.cat_etapa SET 
                                    iidproceso=:iidproceso,
                                    txtnombre=:txtnombre,
                                    txtdescripcion=:txtdescripcion,
                                    txtsigla=:txtsigla,
                                    txtcolor=:txtcolor,
                                    txtpermiso=:txtpermiso,
                                    binicial=:binicial,
                                    bfinal=:bfinal,
                                    bcancelacion=:bcancelacion,
                                    brequiere_motivo=:brequiere_motivo,
                                    bactivo=:bactivo,
                                    dtfecha_modificacion=:dtfecha_modificacion
                                WHERE iidetapa=:iidetapa
                        ';
                    $params = array(
                        'iidproceso'  => $data->iidproceso,
                        'txtnombre' => $data->txtnombre,
                        'txtdescripcion' => $data->txtdescripcion,
                        'txtsigla' => $data->txtsigla,
                        'txtcolor' => $data->txtcolor,
                        'txtpermiso' => $data->txtpermiso,
                        'binicial' => $data->binicial ? 't' : 'f',
                        'bfinal' => $data->bfinal ? 't' : 'f',
                        'bcancelacion' => $data->bcancelacion ? 't' : 'f',
                        'brequiere_motivo' => $data->brequiere_motivo ? 't' : 'f',
                        'bactivo' => $data->bactivo ? 't' : 'f',
                        'dtfecha_modificacion' => date('Y-m-d H:i:s'), // Formato de fecha correcto
                        'iidetapa'      => $data->iidoftype,
                    );
                    break;
                case 'Subetapa':
                    $sql = 'UPDATE comun.cat_subetapa SET 
                                        iidetapa=:iidetapa,
                                        txtnombre=:txtnombre,
                                        txtdescripcion=:txtdescripcion,
                                        txtsigla=:txtsigla,
                                        txtcolor=:txtcolor,
                                        txtpermiso=:txtpermiso,
                                        binicial=:binicial,
                                        bfinal=:bfinal,
                                        bcancelacion=:bcancelacion,
                                        brequiere_motivo=:brequiere_motivo,
                                        bactivo=:bactivo,
                                        dtfecha_modificacion=:dtfecha_modificacion
                                    WHERE iidsubetapa=:iidsubetapa
                            ';
                    $params = array(
                        'iidetapa'  => $data->iidetapa,
                        'txtnombre' => $data->txtnombre,
                        'txtdescripcion' => $data->txtdescripcion,
                        'txtsigla' => $data->txtsigla,
                        'txtcolor' => $data->txtcolor,
                        'txtpermiso' => $data->txtpermiso,
                        'binicial' => $data->binicial ? 't' : 'f',
                        'bfinal' => $data->bfinal ? 't' : 'f',
                        'bcancelacion' => $data->bcancelacion ? 't' : 'f',
                        'brequiere_motivo' => $data->brequiere_motivo ? 't' : 'f',
                        'bactivo' => $data->bactivo ? 't' : 'f',
                        'dtfecha_modificacion' => date('Y-m-d H:i:s'), // Formato de fecha correcto
                        'iidsubetapa'      => $data->iidoftype,
                    );
                    break;
            }
            // Parámetros para la actualización del teléfono
            // $this->dep($data);exit;
            Db::execute($sql, $params); // Ejecutar actualización del teléfono en la base de datos
            Db::commit(); // Confirmar transacción en la base de datos

            return array('message' => 'El registro ha sido actualizado.'); // Devolver mensaje de éxito

        } catch (\Exception $e) {
            // Revertir transacción en caso de error
            Db::rollback();
            // Lanzar excepción para manejo adicional
            throw $e;
        }
        // Actualización de telefono
    }

    // // Método para validar datos requeridos
    private function validRequiredData($data, $typeRegister)
    {
        switch ($typeRegister) {
            case 'Proceso':
                $requiredKeys = array('iidmodulo', 'txtnombre', 'txtsigla'); // Claves requeridas
                break;
            case 'Etapa':
                $requiredKeys = array('iidproceso', 'txtnombre', 'txtsigla'); // Claves requeridas
                break;
            case 'Subetapa':
                $requiredKeys = array('iidetapa', 'txtnombre', 'txtsigla'); // Claves requeridas
                break;
            default:
                $message = "Tipo de registro no reconocido.";
                throw new ValidatorBoomException(422, $message);
                break;
        }

        $actualKeys = array_keys(get_object_vars($data)); // Claves presentes en los datos
        $missingKeys = array_diff($requiredKeys, $actualKeys); // Claves faltantes
        $message = 'Faltan valores requeridos.';

        if (!empty($missingKeys)) throw new ValidatorBoomException(422, $message);

        foreach ($data as $key => $value) {
            if (!in_array($key, $requiredKeys)) continue;
            // Validar tipos de valores según la clave
            switch ($key) {
                case 'iidmodulo':
                case 'iidproceso':
                case 'iidetapa':
                    $message = "Tipo de valor incorrectos en $key.";
                    if (!is_int($value)) throw new ValidatorBoomException(422, $message);
                    break;
                case 'binicial':
                case 'bfinal':
                case 'bcancelacion':
                case 'brequiere_motivo':
                    $message = "Tipo de valor incorrecto en $key.";
                    if (!is_bool($value)) throw new ValidatorBoomException(422, $message);
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
