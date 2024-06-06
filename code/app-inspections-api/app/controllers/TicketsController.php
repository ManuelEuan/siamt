<?php

namespace App\Controllers;

use Phalcon\Registry;
use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Http\Exceptions\ValidatorBoomException;

class TicketsController extends BaseController
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

    public function getTickets()
    {
        $data =  $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $itemsPerPage = $data->itemsPerPage; // Obtener número de ítems por página
        $offset = ($data->page - 1) * $itemsPerPage; // Calcular offset
        $sql = "WITH tickets AS (
                SELECT
                b.iidboleta,
                b.dtfecha_hora_infraccion,
                b.txtlugar_infraccion,
                b.txtdireccion,
                b.imonto_total,
                CONCAT(p_inf.txtnombre, ' ', p_inf.txtapepat, CASE WHEN p_inf.txtapemat <> '' THEN ' ' || p_inf.txtapemat ELSE '' END) AS nombre_infractor,
                CONCAT(p_emp.txtnombre, ' ', p_emp.txtapepat, CASE WHEN p_emp.txtapemat <> '' THEN ' ' || p_emp.txtapemat ELSE '' END) AS nombre_empleado,
                br.txtnombre AS nombre_rol,
                b.txtlicencia,
                b.txtunidad,
                b.tarjeta_circulacion_id,
                b.txtreporte_especial_id,
                b.txtinspeccion_fisica,
                b.bretencion_vehiculo,
                b.bretencion_documento,
                b.txtobservaciones,
                b.bapercibimiento,
                b.dapercibimiento_fecha,
                b.dfecha_limite_comparecencia,
                b.dfecha_limite_resolucion,
                b.dfecha_limite_notificacion,
                b.bno_ha_lugar,
                b.bsuspension,
                b.isuspension_dias,
                b.dsuspension_fecha,
                b.bactivo as activo,
                b.dtfecha_creacion,
                b.dtfecha_modificacion
            FROM
                boleta.tbl_boleta b
            INNER JOIN
                persona.tbl_persona p_inf ON b.iidinfractor = p_inf.iidpersona
            INNER JOIN
                persona.tbl_persona p_emp ON b.iidempleado = p_emp.iidpersona
            INNER JOIN
                boleta.tbl_boleta_rol br ON b.iidboleta_rol_id = br.iidboleta_rol
        )";
        $params = array();
       
        if ($data->filters) { // Aplicar filtros si están presentes en la solicitud
            list($sql2, $params2) = $this->filterTickets($data->filters); // Aplicar filtros
            $sql .= $sql2; // Agregar filtros a la consulta principal
            $params += $params2; // Agregar parámetros de los filtros
        } else {
            $sql .= 'SELECT *, COUNT(tickets.iidboleta) OVER() AS total_tickets FROM tickets '; // Obtener perfiles sin filtros
        }
        $sql .= $this->sortInspectors($data->sortBy, $data->sortDesc); // Ordenar inspectores
        // self::dep($itemsPerPage);
        // exit;
        if ($itemsPerPage > 0) { // Si se especifica un número de ítems por página
            $sql .= ' LIMIT :items OFFSET :offset'; // Limitar resultados por página
            $params['items'] = $itemsPerPage; // Añadir parámetro de ítems por página
            $params['offset'] = $offset; // Añadir parámetro de offset
        }
        $tickets = Db::fetchAll($sql, $params); // Ejecutar consulta para obtener inspectores      
        $totalItems = count($tickets) ?? 0; // Obtener total de inspectores
        $totalPages = ceil($totalItems / $itemsPerPage); // Calcular total de páginas
        //    self::dep($sql);
        //         self::dep($totalPages);
        //         exit;
        return array(
            'tickets' => $tickets, // Devolver inspectores
            'totalPages' => $totalPages, // Devolver total de páginas
            'totalItems' => $totalItems, // Devolver total de ítems
        );
    }

    // Método para filtrar inspectores
    private function filterTickets($filters)
    {
        $params = [];
        $sql = "SELECT *, COUNT(tickets.iidboleta) OVER() AS total_tickets FROM tickets ";
        $sql2 = 'WHERE '; // Inicializar fragmento de consulta para filtros
        foreach ($filters as $filter => $value) { // Para cada filtro
            if (empty($value)) continue; // Si el valor del filtro está vacío o es para roles, continuar al siguiente filtro
            if ($sql2 !== 'WHERE ') $sql2 .= 'AND '; // Si no es el primer filtro, añadir "AND"

            switch ($filter) { // Según el filtro
                case 'name': // Filtro por nombre
                    $sql2 .= "tickets.txtnombre ILIKE :name "; // Condición para nombre (ignorando mayúsculas y minúsculas)
                    $params['name'] = '%' . $filters->name . '%'; // Parámetro para nombre
                    break;
                case 'active': // Filtro por estado activo
                    $sql2 .= 'tickets.activo = :active '; // Condición para estado activo
                    $params['active'] = $filters->active; // Parámetro para estado activo
                    break;
            }
        }
        if ($sql2 !== 'WHERE ') $sql .= $sql2; // Si se agregaron filtros, añadirlos a la consulta principal
        return array($sql, $params); // Devolver consulta y parámetros
    }

    private function sortInspectors($sortBy, $sortDesc)
    {
        $sortCount = count($sortBy); // Contar cantidad de criterios de ordenamiento
        if ($sortCount === 0) return 'ORDER BY tickets.iidboleta '; // Si no hay criterios, ordenar por ID por defecto

        $sql = 'ORDER BY '; // Inicializar fragmento de consulta para ordenamiento
        $comma = $sortCount - 1; // Último índice para agregar coma

        for ($i = 0; $i < $sortCount; $i++) { // Para cada criterio de ordenamiento
            $order = $sortDesc[$i] ? 'DESC ' : 'ASC '; // Determinar orden ascendente o descendente
            $column = $sortBy[$i]; // Obtener columna para ordenamiento

            switch ($column) { // Según la columna
                case 'txtnombre': // Ordenar por nombre completo
                    $sql .= 'tickets.txtnombre '; // Agregar columna de nombre completo
                    break;
                case 'activo': // Ordenar por estado activo
                    $sql .= 'tickets.activo '; // Agregar columna de estado activo
                    break;
                default: // Si no se reconoce la columna
                    $sql .= 'tickets.iidboleta '; // Ordenar por ID
            }

            $sql .= "$order NULLS LAST"; // Añadir orden y manejo de nulos
            $sql .= $i < $comma ? ', ' : ' '; // Agregar coma si no es el último criterio
        }

        return $sql; // Devolver fragmento de consulta para ordenamiento
    }

    public function downloadTickets(){
        $data =  $this->request->getJsonRawBody();
        self::dep('data download');
        self::dep($data);
        exit;
    }
}
