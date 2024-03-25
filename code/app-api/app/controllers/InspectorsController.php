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

    // Obtener perfiles
    public function getInspectors()
    {
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $itemsPerPage = $data->itemsPerPage; // Obtener número de ítems por página
        $offset = ($data->page - 1) * $itemsPerPage; // Calcular offset

        $sql = '
            WITH perfiles AS (
                SELECT
                    id,
                    nombre,
                    descripcion,
                    activo,
                    fecha_creacion,
                    fecha_modificacion
                FROM usuario.perfil
            )
        '; // Consulta común de perfiles
        $params = array();

        if ($data->filters) { // Aplicar filtros si están presentes en la solicitud
            list($sql2, $params2) = $this->filterProfiles($data->filters); // Aplicar filtros
            $sql .= $sql2; // Agregar filtros a la consulta principal
            $params += $params2; // Agregar parámetros de los filtros
        } else {
            $sql .= 'SELECT p.*, COUNT(p.id) OVER() AS total_perfiles FROM perfiles p '; // Obtener perfiles sin filtros
        }

        $sql .= $this->sortProfiles($data->sortBy, $data->sortDesc); // Ordenar perfiles

        if ($itemsPerPage > 0) { // Si se especifica un número de ítems por página
            $sql .= 'LIMIT :items OFFSET :offset'; // Limitar resultados por página
            $params['items'] = $itemsPerPage; // Añadir parámetro de ítems por página
            $params['offset'] = $offset; // Añadir parámetro de offset
        }

        $profiles = Db::fetchAll($sql, $params); // Ejecutar consulta para obtener perfiles
        $totalItems = $profiles[0]->total_perfiles ?? 0; // Obtener total de perfiles
        $totalPages = ceil($totalItems / $itemsPerPage); // Calcular total de páginas

        return array(
            'profiles' => $profiles, // Devolver perfiles
            'totalPages' => $totalPages, // Devolver total de páginas
            'totalItems' => $totalItems, // Devolver total de ítems
        );
    }
}