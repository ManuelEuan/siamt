<?php

namespace App\Controllers;

use Phalcon\Registry;
use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Http\Exceptions\ValidatorBoomException;

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

    // Método para depurar y mostrar datos
    public function dep($data)
    {
        $format  = print_r('<pre>');
        $format .= print_r($data);
        $format .= print_r('</pre>');
        return $format;
    }

    // Obtener inspectores
    public function getInspectors()
    {
        $data =  $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $itemsPerPage = $data->itemsPerPage; // Obtener número de ítems por página
        $offset = ($data->page - 1) * $itemsPerPage; // Calcular offset
        $sql = "
            WITH inspectores AS (
                        SELECT
                            i.iidinspector,
                            i.iidpersona,
                            i.iidetapa,
                            ca.txtnombre as txtinspector_etapa,
                            cas.txtnombre as txtinspector_subetapa,
                            i.txtfolio_inspector,
                            i.iidturno,
                            it.txtnombre as txtinspector_turno,
                            p.txtnombre,
                            p.txtapepat,
                            p.txtapemat,
                            p.txtrfc,
                            p.txtcurp,
                            p.txtine,
                            i.iidinspector_categoria,
                            ic.txtnombre as txtinspector_categoria,
                            i.txtcomentarios,
                            i.dvigencia,
                            i.dfecha_alta,
                            i.dfecha_baja,
                            i.bactivo as activo,
                            TO_CHAR(i.dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
                            TO_CHAR(i.dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
                        FROM inspeccion.tbl_inspector i
                        JOIN persona.tbl_persona p ON i.iidpersona = p.iidpersona
                        JOIN inspeccion.cat_turno it ON it.iidturno = i.iidturno
                        JOIN comun.cat_etapa ca ON ca.iidetapa = i.iidetapa
                        JOIN comun.cat_subetapa cas ON cas.iidsubetapa = i.iidsubetapa
                        JOIN inspeccion.cat_inspector_categoria ic ON ic.iidinspector_categoria = i.iidinspector_categoria
                    )
            "
        ; 
        $params = array();
        if ($data->filters) { // Aplicar filtros si están presentes en la solicitud
            list($sql2, $params2) = $this->filterInspectors($data->filters); // Aplicar filtros
            $sql .= $sql2; // Agregar filtros a la consulta principal
            $params += $params2; // Agregar parámetros de los filtros
        } else {
            $sql .= 'SELECT *, COUNT(inspectores.iidinspector) OVER() AS total_inspectores FROM inspectores '; // Obtener perfiles sin filtros
        }
        $sql .= $this->sortInspectors($data->sortBy, $data->sortDesc); // Ordenar inspectores

        if ($itemsPerPage > 0) { // Si se especifica un número de ítems por página
            $sql .= 'LIMIT :items OFFSET :offset'; // Limitar resultados por página
            $params['items'] = $itemsPerPage; // Añadir parámetro de ítems por página
            $params['offset'] = $offset; // Añadir parámetro de offset
        }
        $inspectors = Db::fetchAll($sql, $params); // Ejecutar consulta para obtener inspectores      
        $totalItems = $inspectors[0]->total_inspectores ?? 0; // Obtener total de inspectores
        $totalPages = ceil($totalItems / $itemsPerPage); // Calcular total de páginas

        return array(
            'inspectors' => $inspectors, // Devolver inspectores
            'totalPages' => $totalPages, // Devolver total de páginas
            'totalItems' => $totalItems, // Devolver total de ítems
        );
    }

    // Método para filtrar inspectores
    private function filterInspectors($filters)
    {
        $params = [];
        $sql = "SELECT *, COUNT(inspectores.iidinspector) OVER() AS total_inspectores FROM inspectores ";
        $sql2 = 'WHERE '; // Inicializar fragmento de consulta para filtros
        foreach ($filters as $filter => $value) { // Para cada filtro
            if (empty($value)) continue; // Si el valor del filtro está vacío o es para roles, continuar al siguiente filtro
            if ($sql2 !== 'WHERE ') $sql2 .= 'AND '; // Si no es el primer filtro, añadir "AND"

            switch ($filter) { // Según el filtro
                case 'name': // Filtro por nombre
                    $sql2 .= "inspectores.txtnombre ILIKE :name "; // Condición para nombre (ignorando mayúsculas y minúsculas)
                    $params['name'] = '%' . $filters->name . '%'; // Parámetro para nombre
                    break;
                case 'tarjeton': // Filtro por tarjeton
                    $sql2 .= "inspectores.txtfolio_inspector ILIKE :tarjeton "; // Condición para nombre (ignorando mayúsculas y minúsculas)
                    $params['tarjeton'] = '%' . $filters->tarjeton . '%'; // Parámetro para nombre
                    break;
                case 'etapa': // Filtro por etapa
                    $sql2 .= "inspectores.txtinspector_etapa ILIKE :etapa "; // Condición para nombre (ignorando mayúsculas y minúsculas)
                    $params['etapa'] = '%' . $filters->etapa . '%'; // Parámetro para nombre
                    break;
                case 'turno': // Filtro por turno
                    $sql2 .= "inspectores.txtinspector_turno ILIKE :turno "; // Condición para nombre (ignorando mayúsculas y minúsculas)
                    $params['turno'] = '%' . $filters->turno . '%'; // Parámetro para nombre
                    break;
                case 'categoria': // Filtro por categoria
                    $sql2 .= "inspectores.txtinspector_categoria ILIKE :categoria "; // Condición para nombre (ignorando mayúsculas y minúsculas)
                    $params['categoria'] = '%' . $filters->categoria . '%'; // Parámetro para nombre
                    break;
                case 'active': // Filtro por estado activo
                    $sql2 .= 'inspectores.activo = :active '; // Condición para estado activo
                    $params['active'] = $filters->active; // Parámetro para estado activo
                    break;
            }
        }
        if ($sql2 !== 'WHERE ') $sql .= $sql2; // Si se agregaron filtros, añadirlos a la consulta principal
        return array($sql, $params); // Devolver consulta y parámetros
    }

    // // Método para ordenar inspectores
    private function sortInspectors($sortBy, $sortDesc)
    {
        $sortCount = count($sortBy); // Contar cantidad de criterios de ordenamiento
        if ($sortCount === 0) return 'ORDER BY inspectores.iidinspector '; // Si no hay criterios, ordenar por ID por defecto

        $sql = 'ORDER BY '; // Inicializar fragmento de consulta para ordenamiento
        $comma = $sortCount - 1; // Último índice para agregar coma

        for ($i = 0; $i < $sortCount; $i++) { // Para cada criterio de ordenamiento
            $order = $sortDesc[$i] ? 'DESC ' : 'ASC '; // Determinar orden ascendente o descendente
            $column = $sortBy[$i]; // Obtener columna para ordenamiento

            switch ($column) { // Según la columna
                    case 'txtnombre': // Ordenar por nombre completo
                        $sql .= 'inspectores.txtnombre '; // Agregar columna de nombre completo
                        break;
                    case 'txtfolio_inspector': // Ordenar por usuario
                        $sql .= 'inspectores.txtfolio_inspector '; // Agregar columna de usuario
                        break;
                  
                    case 'txtinspector_etapa': // Ordenar por correo
                        $sql .= 'inspectores.txtinspector_etapa '; // Agregar columna de correo
                        break;
                    case 'txtinspector_turno': // Ordenar por correo
                        $sql .= 'inspectores.txtinspector_turno '; // Agregar columna de correo
                        break;
                    case 'txtinspector_categoria': // Ordenar por correo
                        $sql .= 'inspectores.txtinspector_categoria '; // Agregar columna de correo
                        break;
                    case 'activo': // Ordenar por estado activo
                        $sql .= 'inspectores.activo '; // Agregar columna de estado activo
                        break;
                default: // Si no se reconoce la columna
                    $sql .= 'inspectores.iidinspector '; // Ordenar por ID
            }

            $sql .= "$order NULLS LAST"; // Añadir orden y manejo de nulos
            $sql .= $i < $comma ? ', ' : ' '; // Agregar coma si no es el último criterio
        }

        return $sql; // Devolver fragmento de consulta para ordenamiento
    }

    public function getPersonByCurp()
    {
        $data =  $this->request->getJsonRawBody();

        $sql = "SELECT 
                p.iidpersona,
                p.bfisica,
                p.txtnombre,
                p.txtapepat,
                p.txtapemat,
                p.txtrfc,
                p.txtcurp,
                ec.txtnombre AS txtestado_civil,
                s.txtnombre AS txtsexo,
                p.bactivo AS activo,
                TO_CHAR(p.dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
                TO_CHAR(p.dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
            FROM persona.tbl_persona p 
            LEFT JOIN persona.cat_estado_civil ec ON p.iidestado_civil = ec.iidestado_civil
            LEFT JOIN persona.cat_sexo s ON p.iidsexo = s.iidsexo
            WHERE p.txtcurp=:curp
        ";
        $params = array('curp' => $data->curp);
        $persona = Db::fetchOne($sql, $params);

        if(!$persona){
            return 0;
        }
        $sql2 = "SELECT iidinspector, iidinspector, txtfolio_inspector
            FROM inspeccion.tbl_inspector
            WHERE iidpersona=:iidpersona
        ";
        $params2 = array('iidpersona' => $persona->iidpersona);
        $inspector = Db::fetchOne($sql2, $params2);

        if(!$inspector){
            $persona->isInspector = false;
        }else{
            $persona->iidinspector = $inspector->iidinspector;
            $persona->isInspector = true;
        }
        return $persona;
    }

    public function getAllCategoriesInspector()
    {
        $sql = "SELECT 
            iidinspector_categoria,
            txtnombre,
            bgenera_boleta,
            bactivo AS activo,
            TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
            TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
            FROM inspeccion.cat_inspector_categoria
            WHERE bactivo='t'
        ";
        $categories = Db::fetchAll($sql);
        return $categories;
    }

    public function getAllStagesInspector()
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

    public function getAllShiftsInspector()
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
    // Obtener información para editar un inspector
    public function getInspectorInfo()
    {
        $this->hasClientAuthorized('veii'); // Verificar si el cliente tiene autorización
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        if (empty($data->id)) throw new ValidatorBoomException(422, 'Id requerido.'); // Lanzar excepción si el ID está vacío
        $params = array('id' => $data->id); // Parámetros para la consulta

        // Obtener información del inspector
        // $sql = 'SELECT 
        //         id, 
        //         nombre, 
        //         descripcion, 
        //         activo,
        //         TO_CHAR(fecha_creacion, \'DD-MM-YYYY HH24:MI:SS\') AS fecha_creacion,
        //         TO_CHAR(fecha_modificacion, \'DD-MM-YYYY HH24:MI:SS\') AS fecha_modificacion
        //         FROM usuario.inspector
        //         WHERE id=:id
        // ';
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
                p.txtapepat,
                p.txtapemat,
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
            JOIN persona.tbl_persona p ON i.iidpersona = p.iidpersona
            JOIN inspeccion.cat_turno it ON it.iidturno = i.iidturno
            JOIN comun.cat_etapa ca ON ca.iidetapa = i.iidetapa
            JOIN inspeccion.cat_inspector_categoria ic ON ic.iidinspector_categoria = i.iidinspector_categoria
            WHERE iidinspector=:id
        "
        ; 
        $inspector = Db::fetchOne($sql, $params);
        return $inspector; // Devolver información del inspector
    }

    // // Método para crear un inspector
    public function createInspector()
    {
        $this->hasClientAuthorized('crii'); // Verificar si el cliente tiene autorización

        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $this->validRequiredData($data); // Validar datos requeridos
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
        
        $this->insert('tbl_inspector', $params);

        Db::commit(); // Confirmar transacción en la base de datos
        return array('message' => 'El inspector ha sido creado.'); // Devolver mensaje de éxito
    }

    // // Método para actualizar un inspector
    public function updateInspector()
    {
        $this->hasClientAuthorized('edii'); // Verificar si el cliente tiene autorización
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $this->validRequiredData($data); // Validar datos requeridos
        // var_dump($data->activo);exit;
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
            WHERE iidinspector=:iidinspector
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

    // // Método para verificar si el nombre del inspector está en uso
    private function curpInUse($curp)
    {
        $person = '';
        $sql = 'SELECT txtcurp FROM persona.tbl_persona WHERE txtcurp=:curp'; // Consulta para verificar curp de inspector
        $params = array('curp' => $curp); // Parámetros para la consulta
        $person = Db::fetchColumn($sql, $params);
        return $person;  // Devolver resultado de la consulta
    }

    // // Método para insertar datos en la base de datos
    private function insert($table, $params)
    {
        $cols = implode(', ', array_keys($params)); // Obtener nombres de columnas
        $phs = ':' . str_replace(', ', ', :', $cols); // Obtener marcadores de posición para los valores
        $sql = "INSERT INTO inspeccion.$table ($cols) VALUES ($phs)"; // Consulta de inserción
        Db::execute($sql, $params); // Ejecutar inserción en la base de datos
    }

    // // Método para validar datos requeridos
    private function validRequiredData($data)
    {
        $requiredKeys = array('iidpersona', 'iidturno', 'iidetapa', 'iidinspector_categoria'); // Claves requeridas
        $actualKeys = array_keys(get_object_vars($data)); // Claves presentes en los datos
        $missingKeys = array_diff($requiredKeys, $actualKeys); // Claves faltantes
        $message = 'Faltan valores requeridos.';

        if (!empty($missingKeys)) throw new ValidatorBoomException(422, $message);
    
        foreach ($data as $key => $value) {
            if (!in_array($key, $requiredKeys)) continue;
            // Validar tipos de valores según la clave
            switch ($key) {
                case 'iidpersona':
                case 'iidturno':
                case 'iidetapa':
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
