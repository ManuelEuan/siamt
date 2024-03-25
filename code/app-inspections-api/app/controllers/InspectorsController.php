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
        // $this->dep($data);exit;
        $sql = '
        WITH inspectores AS (
          SELECT
              i.iidinspector,
              i.iidpersona,
              i.iidetapa,
              i.txttarjeton,
              i.bactivo as activo,
              i.dtfecha_creacion,
              i.dtfecha_modificacion,
              p.txtnombre,
              p.txtapepat,
              p.txtapemat,
              p.txtrfc,
              p.txtcurp,
              p.txtine
          FROM inspeccion.tbl_inspector i
          JOIN persona.tbl_persona p ON i.iidpersona = p.iidpersona
      )
      '; // Consulta común de inspectores
        //   SELECT *, COUNT(iidinspector) OVER() AS total_inspectores FROM inspectores 
        $params = array();
        // if ($data->filters) { // Aplicar filtros si están presentes en la solicitud
        //     list($sql2, $params2) = $this->filterInspectors($data->filters); // Aplicar filtros
        //     $sql .= $sql2; // Agregar filtros a la consulta principal
        //     $params += $params2; // Agregar parámetros de los filtros
        // }

        if ($data->filters) { // Aplicar filtros si están presentes en la solicitud
            list($sql2, $params2) = $this->filterInspectors($data->filters); // Aplicar filtros

            $sql .= $sql2; // Agregar filtros a la consulta principal
            $params += $params2; // Agregar parámetros de los filtros
        } else {
            $sql .= 'SELECT *, COUNT(iidinspector) OVER() AS total_inspectores FROM inspectores '; // Obtener perfiles sin filtros
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

    // // Método para filtrar inspectores
    private function filterInspectors($filters)
    {
        $params = [];
        $sql = "SELECT *, COUNT(iidinspector) OVER() AS total_inspectores FROM inspectores ";
        $sql2 = 'WHERE '; // Inicializar fragmento de consulta para filtros
        foreach ($filters as $filter => $value) { // Para cada filtro
            if (empty($value)) continue; // Si el valor del filtro está vacío o es para roles, continuar al siguiente filtro
            if ($sql2 !== 'WHERE ') $sql2 .= 'AND '; // Si no es el primer filtro, añadir "AND"

            switch ($filter) { // Según el filtro
                case 'active': // Filtro por estado activo
                    $sql2 .= 'bactivo = :active '; // Condición para estado activo
                    $params['active'] = $filters->active; // Parámetro para estado activo
                    break;
                case 'name': // Filtro por nombre
                    $sql2 .= "txtnombre ILIKE :name "; // Condición para nombre (ignorando mayúsculas y minúsculas)
                    $params['name'] = '%' . $filters->name . '%'; // Parámetro para nombre
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
        if ($sortCount === 0) return 'ORDER BY iidinspector '; // Si no hay criterios, ordenar por ID por defecto

        $sql = 'ORDER BY '; // Inicializar fragmento de consulta para ordenamiento
        $comma = $sortCount - 1; // Último índice para agregar coma

        for ($i = 0; $i < $sortCount; $i++) { // Para cada criterio de ordenamiento
            $order = $sortDesc[$i] ? 'DESC ' : 'ASC '; // Determinar orden ascendente o descendente
            $column = $sortBy[$i]; // Obtener columna para ordenamiento

            switch ($column) { // Según la columna
                    // case 'etapa': // Ordenar por usuario
                    //     $sql .= 'iidetapa '; // Agregar columna de usuario
                    //     break;
                    // case 'nombre': // Ordenar por nombre completo
                    //     $sql .= 'txtnombre '; // Agregar columna de nombre completo
                    //     break;
                    // case 'curp': // Ordenar por correo
                    //     $sql .= 'txtcurp '; // Agregar columna de correo
                    //     break;
                    // case 'activo': // Ordenar por estado activo
                    //     $sql .= 'bactivo '; // Agregar columna de estado activo
                    //     break;
                default: // Si no se reconoce la columna
                    $sql .= 'iidinspector '; // Ordenar por ID
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
            ec.txtestado_civil AS txtestado_civil,
            s.txtsexo AS txtsexo,
            p.bactivo AS activo,
            TO_CHAR(p.dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
            TO_CHAR(p.dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
            FROM persona.tbl_persona p 
            JOIN persona.cat_estado_civil ec ON p.iidestado_civil = ec.iidestado_civil
            JOIN persona.cat_sexo s ON p.iidsexo = s.iidsexo
            WHERE p.txtcurp=:curp
        ";
        $params = array('curp' => $data->curp);
        $persona = Db::fetchOne($sql, $params);
        return $persona;

    }

    // Obtener información para editar un inspector
    // public function getEditInspectorInfo()
    // {
    //     $this->hasClientAuthorized('vepe'); // Verificar si el cliente tiene autorización

    //     $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
    //     if (empty($data->id)) throw new ValidatorBoomException(422, 'Id requerido.'); // Lanzar excepción si el ID está vacío
    //     $params = array('id' => $data->id); // Parámetros para la consulta

    //     // Obtener información del inspector
    //     $sql = 'SELECT 
    //             id, 
    //             nombre, 
    //             descripcion, 
    //             activo,
    //             TO_CHAR(fecha_creacion, \'DD-MM-YYYY HH24:MI:SS\') AS fecha_creacion,
    //             TO_CHAR(fecha_modificacion, \'DD-MM-YYYY HH24:MI:SS\') AS fecha_modificacion
    //             FROM usuario.inspector
    //             WHERE id=:id
    //     ';
    //     $inspector['inspector'] = Db::fetchOne($sql, $params);

    //     // Obtener módulos asociados al inspector
    //     $sql = 'SELECT idmodulo FROM usuario.usuario_dominio_modulo WHERE idusuario=:id AND activo=true';
    //     $modules = Db::fetchAll($sql, $params);
    //     $inspector['inspector']->modulos = array_column($modules, 'idmodulo');

    //     // Obtener usuarios asociados al inspector
    //     $sql = 'SELECT u.id, u.usuario, u.nombre, u.apepat, u.apemat
    //     FROM usuario.usuario u
    //     JOIN usuario.inspector_usuario pu ON u.id = pu.idusuario
    //     WHERE pu.idinspector = :id;
    //     ';
    //     $usuarios = Db::fetchAll($sql, $params);
    //     $inspector['inspector']->usuarios = array_column($usuarios, 'usuario');

    //     // Obtener permisos asociados al inspector independientemente si están activos
    //     $sql = 'SELECT idpermiso, activo FROM usuario.inspector_permiso WHERE idinspector=:id AND activo = true';
    //     // $sql = 'SELECT idpermiso FROM usuario.inspector_permiso WHERE idinspector=:id AND activo=true';
    //     $permissions = Db::fetchAll($sql, $params);
    //     //  var_dump($permissions);exit;
    //     $inspector['inspector']->permisos = array_column($permissions, 'idpermiso');

    //     return $inspector; // Devolver información del inspector
    // }

    // // Métodos para obtener usuarios de un inspector
    // public function getUsersFromInspector()
    // {
    //     $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
    //     $params = array('idinspector' => $data->id); // Parámetros para la consulta
    //     $sql = 'SELECT idusuario FROM usuario.inspector_usuario WHERE idinspector = :idinspector'; // Consulta para obtener usuarios asociados al inspector
    //     $usuarios = Db::fetchAll($sql, $params); // Ejecutar consulta para obtener usuarios
    //     $usuarios = array_column($usuarios, 'idusuario'); // Obtener solo los IDs de usuario
    //     return $usuarios; // Devolver IDs de usuario asociados al inspector
    // }

    // // Método para obtener permisos de un inspector
    // public function getPermissionsFromInspector()
    // {
    //     $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
    //     $params = array('idinspector' => $data->id); // Parámetros para la consulta
    //     $sql = "SELECT p.id, p.nombre, p.descripcion, p.siglas, p.idmodulo, p.activo
    //         FROM usuario.permiso p
    //         WHERE p.id IN (
    //             SELECT pp.idpermiso
    //             FROM usuario.inspector_permiso pp
    //             WHERE pp.idinspector = :idinspector AND activo = true
    //          );
    //     "; // Consulta para obtener permisos asociados al inspector
    //     $permisos = Db::fetchAll($sql, $params); // Ejecutar consulta para obtener permisos
    //     return $permisos; // Devolver permisos asociados al inspector
    // }

    // // Método para crear un inspector
    // public function createInspector()
    // {
    //     $this->hasClientAuthorized('crpe'); // Verificar si el cliente tiene autorización

    //     $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
    //     $this->validRequiredData($data); // Validar datos requeridos

    //     Db::begin(); // Iniciar transacción en la base de datos

    //     $id = $this->isInspectornameInUse($data->nombre); // Verificar si el nombre del inspector ya está en uso
    //     if ($id) throw new ValidatorBoomException(422, 'El nombre del inspector ya se encuentra en uso.'); // Lanzar excepción si el nombre del inspector está en uso

    //     $params = array(
    //         'nombre'  => $data->nombre,
    //         'descripcion' => $data->descripcion,
    //     ); // Parámetros para la inserción del inspector

    //     $this->insert('inspector', $params); // Insertar inspector en la base de datos

    //     $data->id = $this->isInspectornameInUse($data->nombre); // Obtener ID del inspector recién insertado
    //     $this->processInspectorAssociations($data, 'insert'); // Procesar asociaciones del inspector

    //     Db::commit(); // Confirmar transacción en la base de datos
    //     return array('message' => 'El inspector ha sido creado.'); // Devolver mensaje de éxito
    // }

    // // Método para actualizar un inspector
    // public function updateInspector()
    // {
    //     $this->hasClientAuthorized('edpe'); // Verificar si el cliente tiene autorización

    //     $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
    //     $this->validRequiredData($data); // Validar datos requeridos

    //     Db::begin(); // Iniciar transacción en la base de datos

    //     if ($this->isInspectornameChanged($data->nombre, $data->id)) { // Verificar si el nombre del inspector ha cambiado
    //         if ($this->isInspectornameInUse($data->nombre)) { // Verificar si el nuevo nombre del inspector está en uso
    //             throw new ValidatorBoomException(422, 'El inspector ya se encuentra en uso.'); // Lanzar excepción si el nuevo nombre del inspector está en uso
    //         }
    //     }

    //     // Actualización de inspector
    //     $sql = 'UPDATE usuario.inspector SET 
    //             nombre=:nombre, 
    //             descripcion=:descripcion
    //         WHERE id=:id
    //     ';
    //     $params = array(
    //         'nombre'  => $data->nombre,
    //         'descripcion' => $data->descripcion,
    //         'id'      => $data->id
    //     ); // Parámetros para la actualización del inspector
    //     Db::execute($sql, $params); // Ejecutar actualización del inspector en la base de datos
    //     // var_dump($data);exit;

    //     // $sql = "SELECT activo FROM usuario.inspector  WHERE idinspector=:idinspector LIMIT 1"; // Consulta para obtener estado activo del inspector
    //     // $params = array('idinspector' => $data->id); // Parámetros para la consulta
    //     // // $active = Db::fetchAll($sql); // Obtener estado activo del inspector
    //     // $active = Db::fetchColumn($sql, $params); // Obtener estado activo del inspector
    //     // // ESTABLECE 
    //     // $active = count($active) == 0 ? $active = true : $active[0]->activo;

    //     // var_dump($data->id);exit;

    //     $sql = "SELECT activo FROM usuario.inspector WHERE id=:id"; // Consulta para obtener estado activo del inspector
    //     $params = array('id' => $data->id); // Parámetros para la consulta
    //     $activo = Db::fetchColumn($sql, $params); // Obtener estado activo del inspector
    //     $activo = !$activo ? 'f' : 't';

    //     $sql = 'SELECT idpermiso FROM usuario.inspector_permiso WHERE idinspector=:idinspector'; // Consulta para obtener permisos de rol
    //     $params = array('idinspector' => $data->id); // Parámetros para la consulta
    //     $allPermission = Db::fetchAll($sql, $params); // Obtener permisos de rol
    //     $allPermission = array_column($allPermission, 'idpermiso');

    //     $missingPermissions = array_diff($allPermission, $data->permisos);

    //     if (!empty($missingPermissions)) { //Los permisos que se encuentran en la base de datos se desactivan si no se mandan por el cliente
    //         foreach($missingPermissions as $deactivatePermission){
    //             $sql = "UPDATE usuario.inspector_permiso SET activo='f' WHERE idinspector=:idinspector AND idpermiso=:idpermiso"; // Consulta para actualizar estado activo del inspector
    //             $params = array('idinspector' => $data->id, 'idpermiso' => $deactivatePermission); // Si esta activo lo pone en falso, y viceversa
    //             Db::execute($sql, $params); // Ejecutar actualización del estado activo del inspector

    //         }
    //     } 

    //     foreach ($data->permisos as $idpermiso) {
    //         $sql = "SELECT idpermiso FROM usuario.inspector_permiso WHERE idinspector=:idinspector AND idpermiso=:idpermiso"; // Consulta para obtener estado activo del inspector
    //         $params = array('idinspector' => $data->id, 'idpermiso' => $idpermiso); // Parámetros para la consulta
    //         $existe_permiso = Db::fetchOne($sql, $params); 
    //         if (!$existe_permiso) { // Si no existe el permiso lo inserta
    //             $newParams = array('idinspector' => $data->id, 'idpermiso' => $idpermiso, 'activo' => $activo);
    //             $this->insert('inspector_permiso', $newParams); // Insertar inspector en la base de datos
    //         } else { // Si no existe el permiso lo actualiza
    //             $sql = "UPDATE usuario.inspector_permiso SET activo='t' WHERE idinspector=:idinspector AND idpermiso=:idpermiso"; // Consulta para actualizar estado activo del inspector
    //             $params = array('idinspector' => $data->id, 'idpermiso' => $idpermiso); // Si esta activo lo pone en falso, y viceversa
    //             Db::execute($sql, $params); // Ejecutar actualización del estado activo del inspector
    //         }
    //     }

    //     Db::commit(); // Confirmar transacción en la base de datos
    //     return array('message' => 'El inspector ha sido actualizado.'); // Devolver mensaje de éxito
    // }

    // // Método para eliminar un inspector
    // public function deleteInspector($id)
    // {
    //     $this->hasClientAuthorized('bope'); // Verificar si el cliente tiene autorización

    //     $sql = "SELECT activo FROM usuario.inspector WHERE id=:id"; // Consulta para obtener estado activo del inspector
    //     $params = array('id' => $id); // Parámetros para la consulta
    //     $active = Db::fetchColumn($sql, $params); // Obtener estado activo del inspector

    //     $sql = "UPDATE usuario.inspector SET activo=:activo WHERE id=:id"; // Consulta para actualizar estado activo del inspector
    //     $params = array('activo' => $active ? 'f' : 't', 'id' => $id); // Si esta activo lo pone en falso, y viceversa
    //     Db::execute($sql, $params); // Ejecutar actualización del estado activo del inspector

    //     $sql = "UPDATE usuario.inspector_permiso SET activo =:activo WHERE idinspector=:id";
    //     $params = array('activo' => $active ? 'f' : 't', 'id' => $id);
    //     Db::execute($sql, $params);

    //     $sql = "SELECT idpermiso FROM usuario.inspector_permiso WHERE idpermiso=:id"; // Consulta para obtener estado activo del inspector
    //     $params = array('id' => $id); // Parámetros para la consulta

    //     $msg = $active ? 'desactivado' : 'activado'; // Mensaje de confirmación
    //     return array('message' => "El inspector ha sido $msg."); // Devolver mensaje de éxito
    // }

    // // Método para verificar si el nombre del inspector ha cambiado
    // private function isInspectornameChanged($nombreNuevo, $id)
    // {
    //     $sql = 'SELECT nombre FROM usuario.inspector WHERE id=:id'; // Consulta para obtener el nombre del inspector
    //     $params = array('id' => $id); // Parámetros para la consulta
    //     $nombreAntiguo = Db::fetchColumn($sql, $params); // Obtener el nombre antiguo del inspector
    //     $diferente = $nombreAntiguo !== $nombreNuevo; // Verificar si el nombre ha cambiado
    //     return $diferente; // Devolver resultado de la comparación
    // }

    // // Método para verificar si el nombre del inspector está en uso
    // private function isInspectornameInUse($inspectorname)
    // {
    //     $sql = 'SELECT id FROM usuario.inspector WHERE nombre=:nombre'; // Consulta para verificar nombre de inspector
    //     $params = array('nombre' => $inspectorname); // Parámetros para la consulta
    //     return Db::fetchColumn($sql, $params); // Devolver resultado de la consulta
    // }

    // // Método para insertar datos en la base de datos
    // private function insert($table, $params)
    // {
    //     $cols = implode(', ', array_keys($params)); // Obtener nombres de columnas
    //     $phs = ':' . str_replace(', ', ', :', $cols); // Obtener marcadores de posición para los valores
    //     $sql = "INSERT INTO usuario.$table ($cols) VALUES ($phs)"; // Consulta de inserción
    //     Db::execute($sql, $params); // Ejecutar inserción en la base de datos
    // }

    // // Método para verificar que los permisos de rol coincidan con los permisos seleccionados
    // private function verifyRolePermissions($role, $permissions)
    // {
    //     $sql = 'SELECT idpermiso FROM usuario.inspector_permiso WHERE idinspector=:idinspector'; // Consulta para obtener permisos de rol
    //     $params = array('idinspector' => $r); // Parámetros para la consulta
    //     $rolePermissions = Db::fetchAll($sql, $params); // Obtener permisos de rol

    //     if (empty($rolePermissions)) return; // Si no hay permisos de rol, salir del método

    //     $rolePermissions = array_column($rolePermissions, 'idpermiso'); // Obtener solo los IDs de permisos
    //     $unmatchedPermissions = array_diff($rolePermissions, $permissions); // Encontrar permisos no coincidentes

    //     if (!empty($unmatchedPermissions)) { // Si hay permisos no coincidentes
    //         $message = 'Los permisos no coinciden con los inspectores seleccionados.'; // Mensaje de error
    //         throw new ValidatorBoomException(422, $message); // Lanzar excepción de validación
    //     }
    // }

    // // Método para procesar asociaciones del inspector
    // private function processInspectorAssociations($data, $associationHandler)
    // {
    //     foreach ($data->permisos as $permiso) { // Para cada permiso del inspector
    //         $this->verifyRolePermissions($permiso, $data->permisos); // Verificar permisos de rol
    //         $params = array('idinspector' => $data->id, 'idpermiso' => $permiso); // Parámetros para la asociación
    //         $this->$associationHandler('inspector_permiso', $params); // Llamar al manejador de asociación
    //     }
    //     // Db::commit(); // Confirmar transacción en la base de datos
    // }



    // // Método para validar datos requeridos
    // private function validRequiredData($data)
    // {
    //     $requiredKeys = array('nombre', 'descripcion'); // Claves requeridas
    //     $actualKeys = array_keys(get_object_vars($data)); // Claves presentes en los datos
    //     $missingKeys = array_diff($requiredKeys, $actualKeys); // Claves faltantes

    //     $message = 'Faltan valores requeridos.'; // Mensaje de error por valores faltantes
    //     if (!empty($missingKeys)) throw new ValidatorBoomException(422, $message); // Lanzar excepción si faltan valores requeridos

    //     foreach ($data as $key => $value) { // Para cada clave y valor en los datos
    //         if (!in_array($key, $requiredKeys)) continue; // Si no es una clave requerida, pasar al siguiente

    //         if ($key === 'dominios') { // Si la clave es 'dominios'
    //             $message = "Tipo de valor incorrecto en dominios."; // Mensaje de error por tipo de valor incorrecto
    //             if (!is_array($value)) throw new ValidatorBoomException(422, $message); // Lanzar excepción si el valor no es un arreglo

    //             $message = "Valor vacío en dominios."; // Mensaje de error por valor vacío
    //             if (empty($value)) throw new ValidatorBoomException(422, $message); // Lanzar excepción si el valor está vacío
    //             continue; // Pasar al siguiente valor
    //         }

    //         $message = "Tipo de valor incorrecto en $key."; // Mensaje de error por tipo de valor incorrecto
    //         if (!is_string($value)) throw new ValidatorBoomException(422, $message); // Lanzar excepción si el valor no es una cadena

    //         $message = "Valor vacío en $key."; // Mensaje de error por valor vacío
    //         if (empty(trim($value))) throw new ValidatorBoomException(422, $message); // Lanzar excepción si el valor está vacío

    //         if ($key === 'usuario') { // Si la clave es 'usuario'
    //             $regex = '/^[-.\w]+$/'; // Expresión regular para validar caracteres permitidos en el nombre de usuario
    //             $message = "Caracteres no admitidos en usuario."; // Mensaje de error por caracteres no admitidos
    //             if (!preg_match($regex, $value)) throw new ValidatorBoomException(422, $message); // Lanzar excepción si hay caracteres no admitidos
    //             $message = "Longitud incorrecta en usuario."; // Mensaje de error por longitud incorrecta
    //             if (strlen($value) < 5) throw new ValidatorBoomException(422, $message); // Lanzar excepción si la longitud es menor a 5
    //         }
    //     }
    // }
}
