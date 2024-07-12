<?php

namespace App\Models\Inspection;

use Phalcon\Mvc\Model;
use App\Library\Db\Db;
// use App\Library\Db\InspectionsDb;
// use App\Library\Db\InspectionsDb as Db;

class Tickets extends Model
{
    public function initialize()
    {
        $this->setSchema("boleta");
        $this->setSource("tbl_boleta");
    }

    public function getSequenceName()
    {
        return "boleta.tbl_boleta_iid_seq";
    }

    public function dep($data)
    {
        $format  = print_r('<pre>');
        $format .= print_r($data);
        $format .= print_r('</pre>');
        return $format;
    }

    public static function getAllTickets($data, $bactivo = null)
    {
        $parameters = [];
        $conditions = [];
        if ($bactivo === true) {
            $conditions[] = "bactivo = :activo:";
            $parameters["activo"] = 't';
        } elseif ($bactivo === false) {
            $conditions[] = "bactivo = :activo:";
            $parameters["activo"] = 'f';
        } elseif ($bactivo !== null) {
            throw new \InvalidArgumentException("El valor de bactivo debe ser true, false o null.");
        }

        $itemsPerPage = $data->itemsPerPage; // Obtener número de ítems por página
        $offset = ($data->page - 1) * $itemsPerPage; // Calcular offset
        $sql = "WITH tickets AS (
                SELECT
                b.iid AS iidboleta,
                b.dtfecha_hora_infraccion,
                b.txtlugar_infraccion,
                b.txtdireccion,
                b.imonto_total,
                p_inf.nombre_completo AS nombre_infractor,
                p_emp.nombre_completo AS nombre_empleado,
                -- CONCAT(p_inf.txtnombre, ' ', p_inf.txtapellido_paterno, CASE WHEN p_inf.txtapellido_materno <> '' THEN ' ' || p_inf.txtapellido_materno ELSE '' END) AS nombre_infractor,
                -- CONCAT(p_emp.txtnombre, ' ', p_emp.txtapellido_paterno, CASE WHEN p_emp.txtapellido_materno <> '' THEN ' ' || p_emp.txtapellido_materno ELSE '' END) AS nombre_empleado,
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
            INNER JOIN dblink('dbname=siamt_unstable_jair host=172.20.199.57 port=5432 user=postgres password=root'::text, 
                    'SELECT nombre_completo, iid FROM persona.tbl_persona'::text) 
                        p_emp(nombre_completo text, iid integer) 
                    ON b.iidempleado = p_emp.iid
            INNER JOIN dblink('dbname=siamt_unstable_jair host=172.20.199.57 port=5432 user=postgres password=root'::text, 
                    'SELECT nombre_completo, iid FROM persona.tbl_persona'::text) 
                        p_inf(nombre_completo text, iid integer) 
                    ON b.iidinfractor = p_inf.iid
            -- INNER JOIN
            --     persona.tbl_persona p_inf ON b.iidinfractor = p_inf.iid
            -- INNER JOIN
            --     persona.tbl_persona p_emp ON b.iidempleado = p_emp.iid
            INNER JOIN
                boleta.tbl_boleta_rol br ON b.iidboleta_rol_id = br.iid
        )";
        $params = array();

        if ($data->filters) { // Aplicar filtros si están presentes en la solicitud
            list($sql2, $params2) = self::filterTickets($data->filters); // Aplicar filtros
            $sql .= $sql2; // Agregar filtros a la consulta principal
            $params += $params2; // Agregar parámetros de los filtros
        } else {
            $sql .= 'SELECT *, COUNT(tickets.iidboleta) OVER() AS total_tickets FROM tickets '; // Obtener perfiles sin filtros
        }
        if (isset($data->filters->type) &&$data->filters->type != '' ) {
            return Db::fetchAll($sql, $params);
        } else {
            $sql .= self::sortTickets($data->sortBy, $data->sortDesc); // Ordenar inspectores
            if ($itemsPerPage > 0) { // Si se especifica un número de ítems por página
                $sql .= ' LIMIT :items OFFSET :offset'; // Limitar resultados por página
                $params['items'] = $itemsPerPage; // Añadir parámetro de ítems por página
                $params['offset'] = $offset; // Añadir parámetro de offset
            }
            $tickets = Db::fetchAll($sql, $params); // Ejecutar consulta para obtener inspectores      
            $totalItems = count($tickets) ?? 0; // Obtener total de inspectores
            $totalPages = ceil($totalItems / $itemsPerPage); // Calcular total de páginas
            return array(
                'tickets' => $tickets, // Devolver inspectores
                'totalPages' => $totalPages, // Devolver total de páginas
                'totalItems' => $totalItems, // Devolver total de ítems
            );
        }
    }

    // Método para filtrar inspectores
    private function filterTickets($filters)
    {
        $params = [];
        $sql = "SELECT *, COUNT(tickets.iidboleta) OVER() AS total_tickets FROM tickets ";
        $sql2 = 'WHERE '; // Inicializar fragmento de consulta para filtros
        foreach ($filters as $filter => $value) { // Para cada filtro
            if (empty($value) || $filter == 'type') continue; // Si el valor del filtro está vacío o es para roles, continuar al siguiente filtro
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

    private function sortTickets($sortBy, $sortDesc)
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
}
