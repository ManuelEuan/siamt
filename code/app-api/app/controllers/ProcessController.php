<?php

namespace App\Controllers;

use Phalcon\Registry;
use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Http\Exceptions\ValidatorBoomException;
use \App\Library\Http\Exceptions\HttpBadRequestException;

// MODELOS COMUNES - COMMON
use Vokuro\GenericSQL\Common\Process;
use Vokuro\GenericSQL\Common\Stages;
use Vokuro\GenericSQL\Common\SubStages;
use Vokuro\GenericSQL\User\Modules;
use App\Models\Person\Inspectors;
use Vokuro\GenericSQL\GenericSQL;

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
    public function getStructureFormDinamycProcess()
    {
        $typesRegister = [
            ["type" => 'Proceso', "name" => "Proceso"],
            ["type" => 'Etapa', "name" => "Etapa"],
            ["type" => 'Subetapa', "name" => "Subetapa"],
            ["type" => 'Flujo', "name" => "Flujo"]
        ];

        $formulario =  [
            'typeRegister' => [
                'label' => 'Seleccione su tipo de registro*',
                'type' => 'autocomplete',
                'model' => 'typeRegister',
                'rules' => 'required',
                'cols' => 12,
                'md' => 12,
                'inputClass' => 'mx-auto',
                'inputStyle' => 'max-width: 50%',
                'array' => [
                    'type' => 'object',
                    'info' => $typesRegister,
                    'item_text' => 'name',
                    'item_value' => 'type'
                ]
            ],
            'iidmodulo' => [
                'label' => 'Seleccione el módulo*',
                'type' => 'autocomplete',
                'model' => 'iidmodulo',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6,
                'array' => [
                    'type' => 'object',
                    'info' => Modules::getAllModules(true),
                    'item_text' => 'nombre',
                    'item_value' => 'id'
                ]
            ],
            'iidproceso' => [
                'label' => 'Seleccione el proceso*',
                'type' => 'autocomplete',
                'model' => 'iidproceso',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6,
                'array' => [
                    'type' => 'object',
                    'info' => Process::getAllProcess(),
                    'item_text' => 'txtnombre',
                    'item_value' => 'iidproceso'
                ]
            ],
            'iidetapa' => [
                'label' => 'Seleccione la etapa*',
                'type' => 'autocomplete',
                'model' => 'iidetapa',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6,
                'array' => [
                    'type' => 'object',
                    'info' => Stages::getAllStages(),
                    'item_text' => 'txtetapa_nombre',
                    'item_value' => 'iidetapa'
                ]
            ],
            'iidsubetapa' => [
                'label' => 'Seleccione la subetapa*',
                'type' => 'autocomplete',
                'model' => 'iidsubetapa',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6,
                'array' => [
                    'type' => 'object',
                    'info' => Substages::getAll(),
                    'item_text' => 'txtnombre',
                    'item_value' => 'iidsubetapa'
                ]
            ],
            'iidsubetapa_siguiente' => [
                'label' => 'Seleccione la subetapa siguiente*',
                'type' => 'autocomplete',
                'model' => 'iidsubetapa_siguiente',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6,
                'array' => [
                    'type' => 'object',
                    'info' => '',
                    'item_text' => 'txtnombre',
                    'item_value' => 'iidsubetapa'
                ]
            ],
           'vclave' => [
                'label' => 'Clave',
                'type' => 'text',
                'model' => 'vclave',
                'rules' => 'required|max5chars',
                'cols' => 12,
                'md' => 6
            ],
            'txtnombre' => [
                'label' => 'Nombre',
                'type' => 'text',
                'model' => 'txtnombre',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6
            ],
            'txtaccion' => [
                'label' => 'Acción',
                'type' => 'text',
                'model' => 'txtaccion',
                'rules' => 'required',
                'cols' => 12,
                'md' => 6
            ],
            'txtdescripcion' => [
                'label' => 'Descripción',
                'type' => 'text',
                'model' => 'txtdescripcion',
                'rules' => null,
                'cols' => 12,
                'md' => 6
            ],
            
            'txtcolor' => [
                'label' => 'Color',
                'type' => 'color',
                'model' => 'txtcolor',
                'rules' => null,
                'cols' => 12,
                'md' => 6
            ],
            'txtpermiso' => [
                'label' => 'Permiso',
                'type' => 'text',
                'model' => 'txtpermiso',
                'rules' => null,
                'cols' => 12,
                'md' => 6
            ],
            'binicial' => [
                'label' => 'Inicial',
                'type' => 'boolean',
                'model' => 'binicial',
                'rules' => null,
                'cols' => 6,
                'md' => 3
            ],
            'bfinal' => [
                'label' => 'Final',
                'type' => 'boolean',
                'model' => 'bfinal',
                'rules' => null,
                'cols' => 6,
                'md' => 3
            ],
            'bcancelacion' => [
                'label' => 'Cancelacion',
                'type' => 'boolean',
                'model' => 'bcancelacion',
                'rules' => null,
                'cols' => 6,
                'md' => 3
            ],
            'brequiere_motivo' => [
                'label' => 'Motivo',
                'type' => 'boolean',
                'model' => 'brequiere_motivo',
                'rules' => null,
                'cols' => 6,
                'md' => 3
            ],
            'dtfecha_creacion' => [
                'label' => 'Fecha de creación',
                'type' => 'datetime',
                'model' => 'dtfecha_creacion',
                'rules' => null,
                'cols' => 12,
                'md' => 4
            ],
            'dtfecha_modificacion' => [
                'label' => 'Fecha de modificación',
                'type' => 'datetime',
                'model' => 'dtfecha_modificacion',
                'rules' => null,
                'cols' => 12,
                'md' => 4
            ],
            'bactivo' => [
                'label' => 'Activo',
                'type' => 'boolean',
                'model' => 'bactivo',
                'rules' => null,
                'cols' => 6,
                'md' => 4
            ]
        ];

        return json_encode($formulario);
    }

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
        // $typeRegister = $data->filters->typeRegister;
        switch ($typeRegister) {
            case 'Proceso':
                $sql = "WITH registers AS (
                        SELECT 
                            dinamyc.iid AS iidOfType,
                            dinamyc.iidmodulo,
                            dinamyc.txtnombre,
                            dinamyc.txtaccion,
                            dinamyc.bactivo,
                            TO_CHAR(dinamyc.dtfecha_creacion, 'YYYY-MM-DD HH24:MI') AS dtfecha_creacion,
                            TO_CHAR(dinamyc.dtfecha_modificacion, 'YYYY-MM-DD HH24:MI') AS dtfecha_modificacion
                        FROM comun.tbl_cat_proceso AS dinamyc)
                        ";
                break;
            case 'Etapa':
                $sql = "WITH registers AS (
                            SELECT 
                                dinamyc.iid AS iidOfType,
                                dinamyc.iidproceso,
                                dinamyc.txtnombre,
                                dinamyc.vclave,
                                dinamyc.txtdescripcion,
                                dinamyc.txtcolor,
                                dinamyc.bactivo,
                                TO_CHAR(dinamyc.dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS dtfecha_creacion,
                                TO_CHAR(dinamyc.dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS dtfecha_modificacion
                            FROM comun.tbl_cat_etapa AS dinamyc)
                        ";
                break;
            case 'Subetapa':
                $sql = "WITH registers AS (
                            SELECT 
                                dinamyc.iid AS iidOfType,
                                dinamyc.iidetapa,
                                dinamyc.txtnombre,
                                dinamyc.vclave,
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
                            FROM comun.tbl_cat_subetapa dinamyc)
                        ";
                break;
            case 'Flujo':
                $sql = "WITH registers AS (
                            SELECT 
                                dinamyc.iid AS iidOfType,
                                dinamyc.iidsubetapa,
                                dinamyc.iidsubetapa_siguiente,
                                dinamyc.bactivo,
                                TO_CHAR(dinamyc.dtfecha_creacion, 'YYYY-MM-DD HH24:MI') AS dtfecha_creacion,
                                TO_CHAR(dinamyc.dtfecha_modificacion, 'YYYY-MM-DD HH24:MI') AS dtfecha_modificacion,
                                subetapa.txtnombre AS txtnombre,
                                siguiente.txtnombre AS txtnombre_siguiente
                            FROM comun.tbl_flujo dinamyc
                            LEFT JOIN comun.tbl_cat_subetapa AS subetapa ON dinamyc.iidsubetapa = subetapa.iid
                            LEFT JOIN comun.tbl_cat_subetapa AS siguiente ON dinamyc.iidsubetapa_siguiente = siguiente.iid
                            )
                        ";
                break;
            default:
                $message = "Tipo de registro no habilitado, contacte al administrador.";
                throw new ValidatorBoomException(422, $message);
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

                case 'vclave': // Ordenar por correo
                    $sql .= 'registers.vclave '; // Agregar columna de correo
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

   

   

    public function getInfoBySubStage()
    {
        $data = $this->request->getJsonRawBody();
        
        $currentSubStage = SubStages::get($data->idOfSubStage);
        
        $nextSubStage = $this->getNextSubStageFromFlow($data->idOfSubStage);
        $currentFlow = ['currentSubStage' => $currentSubStage, 'nextSubStage' => $nextSubStage];

        $followUp = []; // ACA SE VA A RECUPERAR EL HISTORIAL POR EL QUE PASÓ O SE ESCOGIÓ, NO ES OBLIGATORIO
        $boletas = [];
        if ($data->idOfType) {
            $followUp = $this->getDinamycTrace($data->type, $data->idOfType);
            $boletas = $followUp['hasBoleta'];
        }
        $checkSubStages = $followUp['onlySubStages'];
        $checkCurrentSubStage =  $currentFlow['currentSubStage']->iidsubetapa;
        $markers = ['checkSubStages' => $checkSubStages, 'checkCurrentSubStage' => $checkCurrentSubStage];
        $getProcessBySubStage = $this->getProcessBySubStage($data->idOfSubStage);
        $flowComplete = self::getFlowByProcess($getProcessBySubStage->iidproceso, $markers);
        $getProcessBySubStage->etapas = $flowComplete;
        $allFlow = $getProcessBySubStage;
        $allData = ['currentFlow' => $currentFlow, 'followUp' => $followUp, 'allFlow' => $allFlow, 'boletas' => $boletas];
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
                $getStagesByProcess[$key]->subStages = $subStages;
            }
            return ['info' => $getStagesByProcess, 'message' => 'Proceso encontrado'];
        } else {
            return ['info' => $getStagesByProcess, 'message' => 'Proceso sin configuración, favor de verificar'];
        }
    }

    public function getFlowByProcess($iidproceso = 0, $markers = [])
    {
        if (!$iidproceso) {
            $data = $this->request->getJsonRawBody();
            $getStagesByProcess = $this->getStagesByProcess($data->iidproceso);
        } else {
            $getStagesByProcess = $this->getStagesByProcess($iidproceso);
        }
        // $insertIcons=self::leerChildrenDinamicamente($info[0],$markers);
        $objetoInicial = null;
        foreach ($getStagesByProcess as $stage) {
            $subStages = $this->getSubStagesByStage($stage->iidetapa);
            foreach ($subStages as $subStage) {
                if ($markers) {
                    if (in_array($subStage->iidsubetapa, $markers['checkSubStages']) && $subStage->iidsubetapa != $markers['checkCurrentSubStage']) {
                        $subStage->textIcon = 'Encontrado en flujo' . $subStage->iidsubetapa;
                        $subStage->icon = 'mdi-checkbox-blank-circle';
                    } elseif ($subStage->iidsubetapa == $markers['checkCurrentSubStage']) {
                        $subStage->textIcon = 'Encontrado en flujo actual' . $subStage->iidsubetapa;
                        $subStage->icon = 'mdi-check-circle';
                    } else {
                        $subStage->textIcon = 'No encontrado en flujo' . $subStage->iidsubetapa;
                        $subStage->icon = 'mdi-checkbox-blank-circle-outline';
                    }
                }
                if ($subStage->binicial) {
                    $objetoInicial = $this->construirArbol($subStage, $subStage->iidsubetapa, [], $markers);
                    break 2; // Salir de ambos bucles
                }
            }
        }
        if (!$objetoInicial) {
            return ['success' => true, 'message' => 'No se ha encontrado una etapa inicial, verifique la configuración del proceso'];
        }
        $prueba = [
            [
                'id' => $objetoInicial->iidsubetapa,
                'name' => $objetoInicial->txtnombre . ' (Inicio de flujo)',
                'icon' => 'mdi-check-circle',
                'children' => $this->formatObjectForJavaScript($objetoInicial)
            ]
        ];
        return ['success' => true, 'message' => '', 'info' => $objetoInicial, 'info2' => $prueba];
    }

    public function getAllNextSubStagesEnabled()
    {
        $data = $this->request->getJsonRawBody();

        $process = $this->getProcessBySubStage($data->iidsubetapa);
        $getStagesByProcess = $this->getStagesByProcess($process->iidproceso);
        $onlySubStages = [];
        foreach ($getStagesByProcess as $stage) {
            $subStages = $this->getSubStagesByStage($stage->iidetapa);
            foreach ($subStages as $keySubStage => $subStage) {
                if ($subStage->iidsubetapa != $data->iidsubetapa) {
                    $onlySubStages[] = $subStage;
                }
            }
        }
        if (!$onlySubStages) {
            return ['success' => true, 'message' => 'No hay subetapas configuradas en este proceso.'];
        } else {
            return ['success' => true, 'message' => 'Subetapas disponibles.', 'info' => $onlySubStages];
        }
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
        // self::dep($object);
        foreach ($object->children as $child) {
            // self::dep($child);
            if ($child->icon) {
                $formattedChild = [
                    'id' => $child->iidsubetapa,
                    'name' => $child->subetapa_nombre,
                    'icon' => $child->icon,
                    'children' => $this->formatObjectForJavaScript($child)
                ];
            } else {
                $formattedChild = [
                    'id' => $child->iidsubetapa,
                    'name' => $child->subetapa_nombre,
                    'icon' => 'mdi-check-circle',
                    'children' => $this->formatObjectForJavaScript($child)
                ];
            }
            $formattedItems[] = $formattedChild;
        }
        return $formattedItems;
    }


    public function getNextSubStageFromFlow($iidSubStage, $markers = [])
    {
        $sql = "SELECT iidsubetapa_siguiente
                FROM comun.tbl_flujo
                WHERE iidsubetapa = :iidsubetapa
                AND bactivo = true";
        $params = array('iidsubetapa' => $iidSubStage);
        $currentFlow = Db::fetchAll($sql, $params);

        $nextSubStages = array();
        foreach ($currentFlow as $row) {
            $nextSubStages[] = SubStages::get($row->iidsubetapa_siguiente, $markers);
        }

        return $nextSubStages;
    }

    // Función para construir el árbol
    function construirArbol($objetoInicial, $getNextSubStageFunction, $processedSubStages = array(), $markers = [])
    {
        $nextSubStages = $this->getNextSubStageFromFlow($getNextSubStageFunction, $markers);
        if (empty($nextSubStages) || in_array($objetoInicial->iidsubetapa, $processedSubStages)) {
            return $objetoInicial;
        }

        // Añadimos la subetapa actual al conjunto de subetapas procesadas
        $processedSubStages[] = $objetoInicial->iidsubetapa;
        $objetoInicial->children = array();
        foreach ($nextSubStages as $subStage) {
            // Llamamos recursivamente a construirArbol solo si no hemos procesado esta subetapa antes
            $objetoInicial->children[] = $this->construirArbol($subStage, $subStage->iidsubetapa, $processedSubStages, $markers);
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
                    etapa.iid AS iidetapa, 
                    etapa.txtnombre AS nombre_etapa, 
                    etapa.vclave AS sigla_etapa, 
                    etapa.txtdescripcion AS descripcion_etapa, 
                    etapa.txtcolor AS color_etapa
                    -- etapa.txtpermiso AS permiso_etapa
                FROM
                    comun.tbl_cat_etapa AS etapa
                WHERE bactivo='t' AND iidproceso = :iidproceso
        ";
        $params = array('iidproceso' => $iidproceso);
        $stages = Db::fetchAll($sql, $params);
        return $stages;
    }

    //Funcion para obtener la etapa por la clave del proceso
    public function stages($processClave)
    {
        $sql = 'SELECT
                    etapa.iid AS id, 
                    etapa.txtnombre AS nombre
                FROM
                    comun.tbl_cat_etapa AS etapa
                INNER JOIN
                    comun.tbl_cat_proceso AS proceso ON etapa.iidproceso = proceso.iid
                WHERE 
                    LOWER(proceso.vclave) = LOWER(:processClave)
                    AND etapa.bactivo = true
                    AND proceso.bactivo = true
        ';
        $params = array(
            'processClave' => $processClave
        );
        
        $stage = Db::fetchAll($sql, $params);
        return $stage;
    }

    public function getSubStagesByStage($iidStage)
    {
        $sql = "SELECT 
                s.iid AS iidsubetapa,
                s.txtnombre,
                s.vclave,
                s.txtdescripcion,
                s.txtcolor,
                s.txtpermiso,
                s.binicial,
                s.bfinal,
                s.bcancelacion,
                s.brequiere_motivo,
                s.iidetapa
            FROM 
                comun.tbl_cat_subetapa s
            JOIN 
                comun.tbl_cat_etapa e ON s.iidetapa = e.iid
            WHERE 
                s.bactivo = 't' AND e.iid = :iidStage
        ";
        $params = array('iidStage' => $iidStage);
        $subStage = Db::fetchAll($sql, $params);
        return $subStage;
    }

    //funcion para obtener subetapa por el id de la etapa
    public function substages($stageId)
    {
        $sql = 'SELECT 
                s.iid AS id,
                s.txtnombre AS nombre
            FROM 
                comun.tbl_cat_subetapa s
            JOIN 
                comun.tbl_cat_etapa e ON s.iidetapa = e.iid
            WHERE 
                s.bactivo = true 
                AND s.iidetapa = :stageId
                AND e.bactivo = true
            ';
        $params = array('stageId' => $stageId);
        $subStages = Db::fetchAll($sql, $params);
        return $subStages;
    }

    public function getProcessBySubStage($iidSubStage)
    {
        $sql = "SELECT
                    tbl_cat_proceso.iid AS iidproceso, 
                    tbl_cat_proceso.iidmodulo, 
                    tbl_cat_proceso.txtnombre, 
                    tbl_cat_proceso.bactivo
                FROM
                    comun.tbl_cat_proceso
                    INNER JOIN
                    comun.tbl_cat_etapa ON tbl_cat_proceso.iid = tbl_cat_etapa.iidproceso
                    INNER JOIN
                    comun.tbl_cat_subetapa ON tbl_cat_etapa.iid = tbl_cat_subetapa.iidetapa
                WHERE tbl_cat_proceso.bactivo = 't' AND tbl_cat_subetapa.iid = :iidsubetapa;
        ";
        $params = array('iidsubetapa' => $iidSubStage);
        
        $process = Db::fetch($sql, $params);
        return $process;
    }

    //funcion para obtener el proceso por el id de la subetapa
    public function process($subStageId)
    {
        $sql = 'SELECT
                proceso.iid AS id, 
                proceso.txtnombre AS nombre
            FROM
                comun.tbl_cat_proceso AS proceso
            INNER JOIN
                comun.tbl_cat_etapa AS etapa ON proceso.iid = etapa.iidproceso
            INNER JOIN
                comun.tbl_cat_subetapa AS subetapa ON etapa.iid = subetapa.iidetapa
            WHERE 
                proceso.bactivo = true 
                AND subetapa.iid = :subStageId
                AND subetapa.bactivo = true';
        
        $params = array('subStageId' => $subStageId);
        
        $process = Db::fetchAll($sql, $params);
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
            $foundRequest = Inspectors::getFlowInspector($idOfSearch);
        }

        return $foundRequest; // Devolver información del inspector
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
        try {
            Db::begin(); // Iniciar transacción en la base de datos

            switch ($data->typeRegister) {
                case 'Proceso':
                    $table = 'comun.tbl_cat_proceso';
                    $params = array(
                        'iidmodulo'  => $data->iidmodulo,
                        'txtnombre' => $data->txtnombre,
                        'dtfecha_creacion' => date('Y-m-d H:i:s'),
                    );
                    break;
                case 'Etapa':
                    $table = 'comun.tbl_cat_etapa';
                    $params = array(
                        'iidproceso'  => $data->iidproceso,
                        'txtnombre' => $data->txtnombre,
                        'txtdescripcion' => $data->txtdescripcion,
                        'vclave' => $data->vclave,
                        'txtcolor' => $data->txtcolor,
                        // 'txtpermiso' => $data->txtpermiso,
                        // 'binicial' => !empty($data->binicial) ? $data->binicial : 'f',
                        // 'bfinal' => !empty($data->bfinal) ? $data->bfinal : 'f',
                        // 'bcancelacion' => !empty($data->bcancelacion) ? $data->bcancelacion : 'f',
                        // 'brequiere_motivo' => !empty($data->brequiere_motivo) ? $data->brequiere_motivo : 'f',
                        'dtfecha_creacion' => date('Y-m-d H:i:s'),
                    );
                    break;
                case 'Subetapa':
                    $table = 'comun.tbl_cat_subetapa';
                    $params = array(
                        'iidetapa'  => $data->iidetapa,
                        'txtnombre' => $data->txtnombre,
                        'txtdescripcion' => $data->txtdescripcion,
                        'vclave' => $data->vclave,
                        'txtcolor' => $data->txtcolor,
                        'txtpermiso' => $data->txtpermiso,
                        'binicial' => !empty($data->binicial) ? $data->binicial : 'f',
                        'bfinal' => !empty($data->bfinal) ? $data->bfinal : 'f',
                        'bcancelacion' => !empty($data->bcancelacion) ? $data->bcancelacion : 'f',
                        'brequiere_motivo' => !empty($data->brequiere_motivo) ? $data->brequiere_motivo : 'f',
                        'dtfecha_creacion' => date('Y-m-d H:i:s'),
                    );
                    break;
                case 'Flujo':
                    $table = 'comun.tbl_flujo';
                    $params = array(
                        'iidsubetapa'  => $data->iidsubetapa,
                        'iidsubetapa_siguiente' => $data->iidsubetapa_siguiente,
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
        try {
            Db::begin();
            switch ($data->typeRegister) {
                case 'Proceso':
                    $sql = 'UPDATE comun.tbl_cat_proceso SET 
                                iidmodulo=:iidmodulo,
                                txtnombre=:txtnombre,
                                txtaccion=:txtaccion,
                                bactivo=:bactivo,
                                dtfecha_modificacion=:dtfecha_modificacion
                            WHERE iid=:iidproceso
                    ';
                    $params = array(
                        'iidmodulo'  => $data->iidmodulo,
                        'txtnombre' => $data->txtnombre,
                        'txtaccion' => $data->txtaccion,
                        'bactivo' => $data->bactivo ? 't' : 'f',
                        'dtfecha_modificacion' => date('Y-m-d H:i:s'), // Formato de fecha correcto
                        'iidproceso'      => $data->iidoftype,
                    );
                    break;
                case 'Etapa':
                    $sql = 'UPDATE comun.tbl_cat_etapa SET 
                                    iidproceso=:iidproceso,
                                    txtnombre=:txtnombre,
                                    txtdescripcion=:txtdescripcion,
                                    vclave=:vclave,
                                    txtcolor=:txtcolor,
                                    bactivo=:bactivo,
                                    dtfecha_modificacion=:dtfecha_modificacion
                                WHERE iid=:iidetapa
                        ';
                    $params = array(
                        'iidproceso'  => $data->iidproceso,
                        'txtnombre' => $data->txtnombre,
                        'txtdescripcion' => $data->txtdescripcion,
                        'vclave' => $data->vclave,
                        'txtcolor' => $data->txtcolor,
                        'bactivo' => $data->bactivo ? 't' : 'f',
                        'dtfecha_modificacion' => date('Y-m-d H:i:s'), // Formato de fecha correcto
                        'iidetapa'      => $data->iidoftype,
                    );
                    break;
                case 'Subetapa':
                    $sql = 'UPDATE comun.tbl_cat_subetapa SET 
                                        iidetapa=:iidetapa,
                                        txtnombre=:txtnombre,
                                        txtdescripcion=:txtdescripcion,
                                        vclave=:vclave,
                                        txtcolor=:txtcolor,
                                        txtpermiso=:txtpermiso,
                                        binicial=:binicial,
                                        bfinal=:bfinal,
                                        bcancelacion=:bcancelacion,
                                        brequiere_motivo=:brequiere_motivo,
                                        bactivo=:bactivo,
                                        dtfecha_modificacion=:dtfecha_modificacion
                                    WHERE iid=:iidsubetapa
                            ';
                    $params = array(
                        'iidetapa'  => $data->iidetapa,
                        'txtnombre' => $data->txtnombre,
                        'txtdescripcion' => $data->txtdescripcion,
                        'vclave' => $data->vclave,
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
                $requiredKeys = array('iidmodulo', 'txtnombre'); // Claves requeridas
                break;
            case 'Etapa':
                $requiredKeys = array('iidproceso', 'txtnombre', 'vclave'); // Claves requeridas
                break;
            case 'Subetapa':
                $requiredKeys = array('iidetapa', 'txtnombre', 'vclave'); // Claves requeridas
                break;
            case 'Flujo':
                $requiredKeys = array('iidsubetapa', 'iidsubetapa_siguiente'); // Claves requeridas
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
                case 'iidsubetapa':
                case 'iidsubetapa_siguiente':
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

    public function getTracing($vclave, $iidfolio)
    {
        if ($iidfolio !== null) {
            if (!is_numeric($iidfolio)) {
                throw new HttpBadRequestException(202, 'El valor de idFolio no es válido. Debe ser un número.');
            }
        }
    
        $sql = 'SELECT
                    s.iid AS "id",
                    p.vclave  AS "claveProceso",
                    e.txtnombre AS "nombreEtapa",
                    se.txtnombre AS "nombreSubetapa",
                    s.iidfolio AS "idFolio",
                    s.txtmotivo AS "motivo",
                    u.usuario,
                    TO_CHAR(s.dtfecha_creacion, \'DD/MM/YYYY HH24:MI\') AS "fecha"
                FROM 
                    comun.tbl_seguimiento s  
                LEFT JOIN 
                    comun.tbl_cat_proceso p ON s.iidproceso = p.iid
                LEFT JOIN 
                    comun.tbl_cat_etapa e ON s.iidetapa = e.iid
                LEFT JOIN 
                    comun.tbl_cat_subetapa se ON s.iidsubetapa = se.iid
                LEFT JOIN 
                    usuario.usuario u ON s.iidusuarioautorizo = u.id
                WHERE 
                    s.bactivo = true
                    AND p.vclave = \'' . $vclave . '\'
                    AND s.iidfolio = ' . intval($iidfolio) . '
                ORDER BY s.dtfecha_creacion DESC';

        $result = GenericSQL::getBySQL($sql);
        return $result;
    }
}
