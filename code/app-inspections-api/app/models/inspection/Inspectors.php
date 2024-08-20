<?php

namespace App\Models\Inspection;

use Phalcon\Mvc\Model;
use App\Library\Db\Db;
use Vokuro\GenericSQL\GenericSQL;

class Inspectors extends Model
{
    public function initialize()
    {
        $this->setSchema("inspeccion");
        $this->setSource("tbl_inspector");
    }

    public static function getMultipleConexion()
    {
        return Inspectors::find();
    }

    public function dep($data)
    {
        $format  = print_r('<pre>');
        $format .= print_r($data);
        $format .= print_r('</pre>');
        return $format;
    }
    public static function getAllFilteredAndPaginatedInspectors($data)
    {
        $stringConnectionSiamt = GenericSQL::getStringConnectionDbLink('db_siamt');
        $itemsPerPage = $data->itemsPerPage; // Obtener número de ítems por página
        $offset = ($data->page - 1) * $itemsPerPage; // Calcular offset
        $sql =     "WITH inspectores AS (
                        SELECT
                            i.iid AS iidinspector,
                            i.iidpersona,
                            i.iidetapa,
                            p.nombre_completo AS txtnombre_completo,
                            ca.txtnombre as txtinspector_etapa,
                            cas.txtnombre as txtinspector_subetapa,
                            i.txtfolio_inspector,
                            i.iidturno,
                            it.txtnombre as txtinspector_turno,
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
                        JOIN dblink('$stringConnectionSiamt'::text, 
                        'SELECT nombre_completo, iid FROM persona.tbl_persona'::text) 
                            p(nombre_completo text, iid integer) 
                            ON i.iidpersona = p.iid
                        JOIN inspeccion.tbl_cat_turno it ON i.iidturno = it.iid
                        JOIN dblink('$stringConnectionSiamt'::text, 'SELECT iid, txtnombre FROM comun.tbl_cat_etapa') 
                            AS ca(iid integer, txtnombre text)
                            ON i.iidetapa = ca.iid
                        JOIN dblink('$stringConnectionSiamt'::text, 'SELECT iid, txtnombre FROM comun.tbl_cat_subetapa') 
                            AS cas(iid integer, txtnombre text)
                            ON i.iidsubetapa = cas.iid
                        JOIN inspeccion.tbl_cat_inspector_categoria ic ON i.iidinspector_categoria = ic.iid
                    )";
        $params = array();
        if ($data->filters) { // Aplicar filtros si están presentes en la solicitud
            list($sql2, $params2) = self::filterInspectors($data->filters); // Aplicar filtros
            $sql .= $sql2; // Agregar filtros a la consulta principal
            $params += $params2; // Agregar parámetros de los filtros
        } else {
            $sql .= 'SELECT *, COUNT(inspectores.iidinspector) OVER() AS total_inspectores FROM inspectores '; // Obtener perfiles sin filtros
        }
        $sql .= self::sortInspectors($data->sortBy, $data->sortDesc); // Ordenar inspectores

        if ($itemsPerPage > 0) { // Si se especifica un número de ítems por página
            $sql .= 'LIMIT :items OFFSET :offset'; // Limitar resultados por página
            $params['items'] = $itemsPerPage; // Añadir parámetro de ítems por página
            $params['offset'] = $offset; // Añadir parámetro de offset
        }

        $inspectors = Db::fetchAll($sql, $params); // Ejecutar consulta para obtener inspectores      
        $totalItems = $inspectors[0]->total_inspectores ?? 0; // Obtener total de inspectores
        $totalPages = ceil($totalItems / $itemsPerPage); // Calcular total de páginas
        $result = array(
            "inspectors" => $inspectors,
            "totalItems" => $totalItems,
            "totalPages" => $totalPages
        );
        return $result;
    }
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

    public static function getAllInspectorByType($type = '')
    {
        $stringConnectionSiamt = GenericSQL::getStringConnectionDbLink('db_siamt');
        $sql = "SELECT
                    i.iid AS iidinspector,
                    i.iidpersona,
                    i.iidetapa,
                    -- CASE 
                    --     WHEN p.txtapellido_materno != '' THEN 
                    --         CONCAT(p.txtnombre, ' ', p.txtapellido_paterno, ' ', p.txtapellido_materno)
                    --     ELSE 
                    --         CONCAT(p.txtnombre, ' ', p.txtapellido_paterno) 
                    -- END AS txtnombre_completo,
                    p.nombre_completo AS txtnombre_completo,
                    -- ca.txtnombre as txtinspector_etapa,
                    -- cas.txtnombre as txtinspector_subetapa,
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
                -- JOIN persona.tbl_persona p ON i.iidpersona = p.iid
                JOIN dblink('$stringConnectionSiamt'::text, 
                    'SELECT nombre_completo, txtrfc, txtcurp, txtine, iid FROM persona.tbl_persona'::text) 
                    p(nombre_completo text, txtrfc text, txtcurp text, txtine text, iid integer)
                ON i.iidpersona = p.iid
                JOIN inspeccion.tbl_cat_turno it ON i.iidturno = it.iid
                JOIN dblink('$stringConnectionSiamt'::text, 'SELECT iid, txtnombre FROM comun.tbl_cat_etapa') 
                        AS ca(iid integer, txtnombre text)
                        ON i.iidetapa = ca.iid
                JOIN dblink('$stringConnectionSiamt'::text, 'SELECT iid, txtnombre FROM comun.tbl_cat_subetapa') 
                    AS cas(iid integer, txtnombre text)
                    ON i.iidsubetapa = cas.iid
                -- JOIN comun.tbl_cat_etapa ca ON i.iidetapa = ca.iid
                -- JOIN comun.tbl_cat_subetapa cas ON i.iidsubetapa = cas.iid
                JOIN inspeccion.tbl_cat_inspector_categoria ic ON i.iidinspector_categoria = ic.iid
                WHERE i.bactivo='t'
        ";
        if ($type) {
            $sql = $sql . " AND ic.txtnombre ='" . $type . "'";
        }
        $inspectors = Db::fetchAll($sql);
        return $inspectors;
        //     $parameters = [];
        //     $conditions = "i.bactivo = 't'";

        //     if (!empty($type)) {
        //         $conditions .= " AND ic.txtnombre = :tipo:";
        //         $parameters["tipo"] = $type;
        //     }

        //     // Construir la consulta
        //     $query = [
        //         "conditions" => $conditions,
        //         "bind" => $parameters,
        //         "columns" => [
        //             "i.iid AS iidinspector",
        //             "i.iidpersona",
        //             "i.iidetapa",
        //             "i.txtnombre AS txtnombre_completo",
        //             "ca.txtnombre as txtinspector_etapa",
        //             "cas.txtnombre as txtinspector_subetapa",
        //             "i.txtfolio_inspector",
        //             "i.iidturno",
        //             "it.txtnombre as txtinspector_turno",
        //             "p.txtrfc",
        //             "p.txtcurp",
        //             "p.txtine",
        //             "i.iidinspector_categoria",
        //             "ic.txtnombre as txtinspector_categoria",
        //             "TO_CHAR(i.dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion",
        //             "TO_CHAR(i.dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion",
        //         ],
        //         "joins" => [
        //             [
        //                 "type" => "JOIN",
        //                 "source" => "persona.tbl_persona",
        //                 "conditions" => "i.iidpersona = p.iid",
        //                 "alias" => "p"
        //             ],
        //             [
        //                 "type" => "JOIN",
        //                 "source" => "inspeccion.tbl_cat_turno",
        //                 "conditions" => "i.iidturno = it.iid",
        //                 "alias" => "it"
        //             ],
        //             [
        //                 "type" => "JOIN",
        //                 "source" => "comun.tbl_cat_etapa",
        //                 "conditions" => "i.iidetapa = ca.iid",
        //                 "alias" => "ca"
        //             ],
        //             [
        //                 "type" => "LEFT JOIN",
        //                 "source" => "comun.tbl_cat_subetapa",
        //                 "conditions" => "i.iidsubetapa = cas.iid",
        //                 "alias" => "cas"
        //             ],
        //             [
        //                 "type" => "JOIN",
        //                 "source" => "inspeccion.tbl_cat_inspector_categoria",
        //                 "conditions" => "i.iidinspector_categoria = ic.iid",
        //                 "alias" => "ic"
        //             ],
        //         ],
        //     ];

        //     $inspectors = self::find($query);

        //     return $inspectors;
    }

    public static function getInspectorInfo($id)
    {
        // Verificar si el ID está presente
        if (empty($id)) {
            throw new \InvalidArgumentException('ID requerido.');
        }

        // Construir la consulta utilizando el ORM de Phalcon
        $inspector = self::findFirst([
            'conditions' => 'iid = :id:',
            'bind' => ['id' => $id],
            'columns' => [
                'iid AS iidinspector',
                'iidpersona',
                'iidturno',
                'iidetapa',
                'iidsubetapa',
                'txtfolio_inspector',
                'txtcomentarios',
                'iidinspector_categoria',
                'dvigencia',
                'dfecha_alta',
                'dfecha_baja',
                'bactivo AS activo',
                "TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion",
                "TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion",
            ],
        ]);

        // Verificar si se encontró el inspector
        if (!$inspector) {
            throw new \Exception("No se encontró el inspector con ID: {$id}");
        }

        // Convertir el resultado a un array para asegurar compatibilidad con el retorno esperado
        $inspectorArray = $inspector->toArray();

        return $inspectorArray;
    }
}
