<?php

namespace App\Models\Person;

use Phalcon\Mvc\Model;
use App\Library\Db\Db;
use Vokuro\GenericSQL\GenericSQL;

class Companies extends Model
{
    public function initialize()
    {
        $this->setSchema("transporte");
        $this->setSource("tbl_empresa");
    }

    public static function getCompany($iidpersona)
    {
        $sql = "SELECT iid AS iidempresa, iidpersona FROM transporte.tbl_empresa WHERE iidpersona=:iidpersona";
        $params = array('iidpersona' => $iidpersona);
        $company = Db::fetchOne($sql, $params);
        return $company;
    }

    public static function getAllFilteredAndPaginatedCompanies($data)
    {

        $itemsPerPage = $data->itemsPerPage; // Obtener número de ítems por página
        $offset = ($data->page - 1) * $itemsPerPage; // Calcular offset
        $sql =     "WITH empresas AS (
                        SELECT
                            e.iid AS iidempresa,
                            e.iidpersona,
                            p.nombre_completo AS txtnombre_completo,
                            e.vnomenclatura,
                            e.bactivo as activo,
                            TO_CHAR(e.dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
                            TO_CHAR(e.dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
                        FROM transporte.tbl_empresa e
                        INNER JOIN persona.tbl_persona p ON e.iidpersona = p.iid
                    )";
        $params = array();
        if ($data->filters) { // Aplicar filtros si están presentes en la solicitud
            list($sql2, $params2) = self::filterCompanies($data->filters); // Aplicar filtros
            $sql .= $sql2; // Agregar filtros a la consulta principal
            $params += $params2; // Agregar parámetros de los filtros
        } else {
            $sql .= 'SELECT *, COUNT(empresas.iidempresa) OVER() AS total_empresas FROM empresas '; // Obtener perfiles sin filtros
        }
        $sql .= self::sortCompanies($data->sortBy, $data->sortDesc); // Ordenar empresas

        if ($itemsPerPage > 0) { // Si se especifica un número de ítems por página
            $sql .= 'LIMIT :items OFFSET :offset'; // Limitar resultados por página
            $params['items'] = $itemsPerPage; // Añadir parámetro de ítems por página
            $params['offset'] = $offset; // Añadir parámetro de offset
        }

        $companies = Db::fetchAll($sql, $params); // Ejecutar consulta para obtener empresa     
        $totalItems = $companies[0]->total_companies ?? 0; // Obtener total de empresas
        $totalPages = ceil($totalItems / $itemsPerPage); // Calcular total de páginas
        $result = array(
            "companies" => $companies,
            "totalItems" => $totalItems,
            "totalPages" => $totalPages
        );
        return $result;
    }
    private function filterCompanies($filters)
    {
        $params = [];
        $sql = "SELECT *, COUNT(empresas.iidempresa) OVER() AS total_empresas FROM empresas ";
        $sql2 = 'WHERE '; // Inicializar fragmento de consulta para filtros
        foreach ($filters as $filter => $value) { // Para cada filtro
            if (empty($value)) continue; // Si el valor del filtro está vacío o es para roles, continuar al siguiente filtro
            if ($sql2 !== 'WHERE ') $sql2 .= 'AND '; // Si no es el primer filtro, añadir "AND"

            switch ($filter) { // Según el filtro
                case 'name': // Filtro por nombre
                    $sql2 .= "empresas.txtnombre_completo ILIKE :name "; // Condición para nombre (ignorando mayúsculas y minúsculas)
                    $params['name'] = '%' . $filters->name . '%'; // Parámetro para nombre
                    break;

                case 'active': // Filtro por estado activo
                    $sql2 .= 'empresas.activo = :active '; // Condición para estado activo
                    $params['active'] = $filters->active; // Parámetro para estado activo
                    break;
            }
        }
        if ($sql2 !== 'WHERE ') $sql .= $sql2; // Si se agregaron filtros, añadirlos a la consulta principal
        return array($sql, $params); // Devolver consulta y parámetros
    }

    // // Método para ordenar empresas
    private function sortCompanies($sortBy, $sortDesc)
    {
        $sortCount = count($sortBy); // Contar cantidad de criterios de ordenamiento
        if ($sortCount === 0) return 'ORDER BY empresas.iidempresa '; // Si no hay criterios, ordenar por ID por defecto
    
        $sql = 'ORDER BY '; // Inicializar fragmento de consulta para ordenamiento
        $comma = $sortCount - 1; // Último índice para agregar coma
    
        for ($i = 0; $i < $sortCount; $i++) { // Para cada criterio de ordenamiento
            $order = $sortDesc[$i] ? 'DESC ' : 'ASC '; // Determinar orden ascendente o descendente
            $column = $sortBy[$i]; // Obtener columna para ordenamiento
    
            switch ($column) { // Según la columna
                case 'txtnombre_completo': // Ordenar por nombre completo
                    $sql .= 'empresas.txtnombre_completo '; // Agregar columna de nombre completo
                    break;
                case 'activo': // Ordenar por estado activo
                    $sql .= 'empresas.activo '; // Agregar columna de estado activo
                    break;
                default: // Si no se reconoce la columna
                    $sql .= 'empresas.iidempresa '; // Ordenar por ID
            }
    
            $sql .= "$order NULLS LAST"; // Añadir orden y manejo de nulos
            $sql .= $i < $comma ? ', ' : ' '; // Agregar coma si no es el último criterio
        }
    
        return $sql; // Devolver fragmento de consulta para ordenamiento
    }


    public static function getCompanyInfo($id)
    {
        // Verificar si el ID está presente
        if (empty($id)) {
            throw new \InvalidArgumentException('ID requerido.');
        }

        // Construir la consulta utilizando el ORM de Phalcon
        $company = self::findFirst([
            'conditions' => 'iid = :id:',
            'bind' => ['id' => $id],
            'columns' => [
                'iid AS iidempresa',
                'iidpersona',
                'vnomenclatura',
                'bactivo AS activo',
                "TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion",
                "TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion",
            ],
        ]);

        // Verificar si se encontró la empresa
        if (!$company) {
            throw new \Exception("No se encontró el empresa con ID: {$id}");
        }

        // Convertir el resultado a un array para asegurar compatibilidad con el retorno esperado
        $companyArray = $company->toArray();

        return $companyArray;
    }
}