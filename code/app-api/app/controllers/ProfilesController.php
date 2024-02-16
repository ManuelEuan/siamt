<?php

namespace App\Controllers;

use Phalcon\Registry;

use App\Library\Http\Controllers\BaseController;
use App\Library\Misc\Utils;
use App\Models\Layers\Layer;
use App\Models\Layers\BaseLayer;
use App\Models\Territory\LocalDistricts;
use App\Models\Territory\Sections;
use GuzzleHttp\Client;
use GuzzleHttp\Psr7;
use App\Library\Db\Db;
use App\Library\Http\Status;
use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Http\Exceptions\ValidatorBoomException;

class ProfilesController extends BaseController
{
    private $tables = array( // Tablas para activar/desactivar o eliminar que estén relacionadas con el perfil (dinámico)
        'perfil_permiso',
    );

    public function getProfiles()
    {
        $data = $this->request->getJsonRawBody();
        $itemsPerPage = $data->itemsPerPage;
        $offset = ($data->page - 1) * $itemsPerPage;

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
        ';
        $params = array();

        if ($data->filters) {
            list($sql2, $params2) = $this->filterProfiles($data->filters);
            $sql .= $sql2;
            $params += $params2;
        } else {
            $sql .= 'SELECT p.*, COUNT(p.id) OVER() AS total_perfiles FROM perfiles p ';
        }

        $sql .= $this->sortProfiles($data->sortBy, $data->sortDesc);

        if ($itemsPerPage > 0) {
            $sql .= 'LIMIT :items OFFSET :offset';
            $params['items'] = $itemsPerPage;
            $params['offset'] = $offset;
        }

        $profiles = Db::fetchAll($sql, $params);
        // var_dump($profiles);exit;
        $totalItems = $profiles[0]->total_perfiles ?? 0;
        $totalPages = ceil($totalItems / $itemsPerPage);

        return array(
            'profiles' => $profiles,
            'totalPages' => $totalPages,
            'totalItems' => $totalItems,
        );
    }

    public function dep($data)
    {
        $format  = print_r('<pre>');
        $format .= print_r($data);
        $format .= print_r('</pre>');
        return $format;
    }

    public function getEditProfileInfo()
    {
        $this->hasClientAuthorized('vepe');

        $data = $this->request->getJsonRawBody();

        if (empty($data->id)) throw new ValidatorBoomException(422, 'Id requerido.');
        $params = array('id' => $data->id);
        // Se trae el perfil 
        $sql = 'SELECT 
                id, 
                nombre, 
                descripcion, 
                activo,
                TO_CHAR(fecha_creacion, \'DD-MM-YYYY HH24:MI:SS\') AS fecha_creacion,
                TO_CHAR(fecha_modificacion, \'DD-MM-YYYY HH24:MI:SS\') AS fecha_modificacion
                FROM usuario.perfil
                WHERE id=:id
        ';
        $profile['perfil'] = Db::fetchOne($sql, $params);
        
        $sql = 'SELECT idmodulo FROM usuario.usuario_dominio_modulo WHERE idusuario=:id AND activo=true';
        $modules = Db::fetchAll($sql, $params);
        $profile['perfil']->modulos = array_column($modules, 'idmodulo');

        $sql = 'SELECT u.id, u.usuario, u.nombre, u.apepat, u.apemat
        FROM usuario.usuario u
        JOIN usuario.perfil_usuario pu ON u.id = pu.idusuario
        WHERE pu.idperfil = :id;
        ';
        $usuarios = Db::fetchAll($sql, $params);
        $profile['perfil']->usuarios = array_column($usuarios, 'usuario');

        $sql = 'SELECT idpermiso FROM usuario.perfil_permiso WHERE idperfil=:id AND activo=true';
        $permissions = Db::fetchAll($sql, $params);
        $profile['perfil']->permisos = array_column($permissions, 'idpermiso');
        // $this->dep($profile);exit;        
        
        return $profile;
    }

    public function getUsersFromProfile(){
        $data = $this->request->getJsonRawBody();
        $params = array('idperfil' => $data->id);
        $sql = 'SELECT idusuario FROM usuario.perfil_usuario WHERE idperfil = :idperfil';
        $usuarios = Db::fetchAll($sql, $params);
        $usuarios = array_column($usuarios, 'idusuario');
        // var_dump($usuarios);exit;
        return $usuarios;
        // $this->dep($usuarios);exit;
    }

    public function getPermissionsFromProfile($id){
        $data = $this->request->getJsonRawBody();
        $params = array('idperfil' => $data->id);
        $sql = "SELECT p.id, p.nombre, p.descripcion, p.siglas, p.idmodulo, p.activo
                FROM usuario.permiso p
                WHERE p.id IN (
                    SELECT pp.idpermiso
                    FROM usuario.perfil_permiso pp
                    WHERE pp.idperfil = :idperfil
                 );
        ";

        $permisos = Db::fetchAll($sql, $params);
        return $permisos;
    }

    public function createProfile()
    {
        $this->hasClientAuthorized('crpe');

        $data = $this->request->getJsonRawBody();
        $this->validRequiredData($data);
        Db::begin();

        $id = $this->isProfilenameInUse($data->nombre);
        if ($id) throw new ValidatorBoomException(422, 'El nombre del perfil ya se encuentra en uso.');

        $params = array(
            'nombre'  => $data->nombre,
            'descripcion' => $data->descripcion,
        );

        $this->insert('perfil', $params);
        
        $data->id = $this->isProfilenameInUse($data->nombre);
        $this->processProfileAssociations($data, 'insert');

        Db::commit();
        return array('message' => 'El perfil ha sido creado.');
    }

    public function updateProfile()
    {
        $this->hasClientAuthorized('edpe');

        $data = $this->request->getJsonRawBody();
        $this->validRequiredData($data);

        Db::begin();

        if ($this->isProfilenameChanged($data->nombre, $data->id)) { //Verifica si es diferente
            if ($this->isProfilenameInUse($data->nombre)) { // Si es diferente verifica que otro perfil no tenga el mismo
                throw new ValidatorBoomException(422, 'El perfil ya se encuentra en uso.');
            }
        }

        // Actualización de perfil
        $sql = 'UPDATE usuario.perfil SET 
                    nombre=:nombre, 
                    descripcion=:descripcion
                WHERE id=:id
        ';

        $params = array(
            'nombre'  => $data->nombre,
            'descripcion' => $data->descripcion,
            'id'      => $data->id
        );

        Db::execute($sql, $params);

        // Actualización de permisos
        $sql = 'DELETE FROM usuario.perfil_permiso WHERE idperfil=:id';
        $params = array('id' => $data->id);
        Db::execute($sql, $params);
        $this->processProfileAssociations($data, 'insert');

        Db::commit();
        return array('message' => 'El perfil ha sido actualizado.');
    }

    private function isProfilenameChanged($nombreNuevo, $id)
    {
        $sql = 'SELECT nombre FROM usuario.perfil WHERE id=:id';
        $params = array('id' => $id);
        $nombreAntiguo = Db::fetchColumn($sql, $params);
        $diferente = $nombreAntiguo !== $nombreNuevo;
        return $diferente;
    }

    public function deleteProfile($id)
    {
        $this->hasClientAuthorized('bope');

        $sql = "SELECT activo FROM usuario.perfil WHERE id=:id";
        $params = array('id' => $id);
        $active = Db::fetchColumn($sql, $params);

        $sql = "UPDATE usuario.perfil SET activo=:activo WHERE id=:id";
        $params = array('activo' => $active ? 'f' : 't', 'id' => $id);
        Db::execute($sql, $params);

        $msg = $active ? 'desactivado' : 'activado';
        return array('message' => "El perfil ha sido $msg.");
    }

    private function isProfilenameInUse($profilename)
    {
        $sql = 'SELECT id FROM usuario.perfil WHERE nombre=:nombre';
        $params = array('nombre' => $profilename);
        return Db::fetchColumn($sql, $params);
    }

    private function insert($table, $params)
    {
        $cols = implode(', ', array_keys($params));
        $phs = ':' . str_replace(', ', ', :', $cols);
        $sql = "INSERT INTO usuario.$table ($cols) VALUES ($phs)";
        Db::execute($sql, $params);
        // Db::commit();
    }


    private function isUsernameChanged($username, $id)
    {
        $sql = 'SELECT usuario FROM usuario.usuario WHERE id=:id';
        $params = array('id' => $id);
        return !(Db::fetchColumn($sql, $params) === $username);
    }

    private function hasClientAuthorized($permission)
    {
        $permissions = $this->token->getPermissions()['per']; //usuario.permiso
        if (!in_array($permission, $permissions)) {
            if ($permission === 'vepe' && in_array('edpe', $permissions)) return;
            throw new HttpUnauthorizedException(401, 'Permisos insuficientes.');
        }
    }




    private function updatePermissions($table, $id)
    {
        $sql = "UPDATE usuario.$table SET activo=false WHERE idusuario=:idusuario";
        $params = array('idusuario' => $id);
        Db::execute($sql, $params);
    }

    private function activate($table, $params)
    {
        $cols = implode(', ', array_keys($params));
        $phs = ':' . str_replace(', ', ', :', $cols);

        $sql = "SELECT * FROM usuario.$table WHERE ($cols) IN (($phs))";
        $exist = Db::fetchOne($sql, $params);

        $sql = $exist
            ? "UPDATE usuario.$table SET activo=true WHERE ($cols) IN (($phs))"
            : "INSERT INTO usuario.$table ($cols) VALUES ($phs)";

        Db::execute($sql, $params);
    }

    private function verifyRolePermissions($role, $permissions)
    {
        $sql = 'SELECT idpermiso FROM usuario.perfil_permiso WHERE idperfil=:idperfil';
        $params = array('idperfil' => $r);
        $rolePermissions = Db::fetchAll($sql, $params);

        if (empty($rolePermissions)) return;

        $rolePermissions = array_column($rolePermissions, 'idpermiso');
        $unmatchedPermissions = array_diff($rolePermissions, $permissions);

        if (!empty($unmatchedPermissions)) {
            $message = 'Los permisos no coinciden con los perfiles seleccionados.';
            throw new ValidatorBoomException(422, $message);
        }
    }

    private function processProfileAssociations($data, $associationHandler)
    {
        foreach ($data->permisos as $permiso) {
            $this->verifyRolePermissions($permiso, $data->permisos);
            $params = array('idperfil' => $data->id, 'idpermiso' => $permiso);
            $this->$associationHandler('perfil_permiso', $params);
        }
        // Db::commit();
    }

    private function filterProfiles($filters)
    {
        $sql = ',
            roles AS (
                SELECT
                    idusuario,
                    ARRAY_AGG(idperfil) AS perfiles
                FROM usuario.perfil_usuario
                GROUP BY idusuario
            ),
            filtro_roles AS (
                SELECT idusuario
                FROM roles
                WHERE perfiles @> :roles::integer[]
            )

            SELECT 
                p.*,
                COUNT(p.id) OVER() AS total_perfiles 
            FROM usuarios u
            INNER JOIN filtro_roles r ON p.id=r.idusuario
        ';
        $params['roles'] = '{' . implode(', ', $filters->roles) . '}';

        if (!$filters->roles) {
            $sql = 'SELECT p.*, COUNT(p.id) OVER() AS total_perfiles FROM perfiles p ';
            unset($params['roles']);
        }

        $sql2 = 'WHERE ';

        foreach ($filters as $filter => $value) {
            if (empty($value) || $filter === 'roles') continue;
            if ($sql2 !== 'WHERE ') $sql2 .= 'AND ';

            switch ($filter) {
                case 'active':
                    $sql2 .= 'p.activo = :active ';
                    $params['active'] = $filters->active;
                    break;
                case 'name':
                    $sql2 .= "p.nombre ILIKE :name ";
                    $params['name'] = '%' . $filters->name . '%';
                    break;
            }
        }

        if ($sql2 !== 'WHERE ') $sql .= $sql2;

        return array($sql, $params);
    }

    private function sortProfiles($sortBy, $sortDesc)
    {
        $sortCount = count($sortBy);
        if ($sortCount === 0) return 'ORDER BY id ';

        $sql = 'ORDER BY ';
        $comma = $sortCount - 1;

        for ($i = 0; $i < $sortCount; $i++) {
            $order = $sortDesc[$i] ? 'DESC ' : 'ASC ';
            $column = $sortBy[$i];

            switch ($column) {
                case 'usuario':
                    $sql .= 'p.usuario ';
                    break;
                case 'nombre_completo':
                    $sql .= 'p.nombre_completo ';
                    break;
                case 'correo':
                    $sql .= 'p.correo ';
                    break;
                case 'activo':
                    $sql .= 'p.activo ';
                    break;
                default:
                    $sql .= 'p.id ';
            }

            $sql .= "$order NULLS LAST";
            $sql .= $i < $comma ? ', ' : ' ';
        }

        return $sql;
    }

    private function validRequiredData($data)
    {
        $requiredKeys = array('nombre', 'descripcion');
        $actualKeys = array_keys(get_object_vars($data));
        $missingKeys = array_diff($requiredKeys, $actualKeys);

        $message = 'Faltan valores requeridos.';
        if (!empty($missingKeys)) throw new ValidatorBoomException(422, $message);

        foreach ($data as $key => $value) {
            if (!in_array($key, $requiredKeys)) continue;

            if ($key === 'dominios') {
                $message = "Tipo de valor incorrecto en dominios.";
                if (!is_array($value)) throw new ValidatorBoomException(422, $message);

                $message = "Valor vacío en dominios.";
                if (empty($value)) throw new ValidatorBoomException(422, $message);
                continue;
            }

            $message = "Tipo de valor incorrecto en $key.";
            if (!is_string($value)) throw new ValidatorBoomException(422, $message);

            $message = "Valor vacío en $key.";
            if (empty(trim($value))) throw new ValidatorBoomException(422, $message);

            if ($key === 'usuario') {
                $regex = '/^[-.\w]+$/';
                $message = "Caracteres no admitidos en usuario.";
                if (!preg_match($regex, $value)) throw new ValidatorBoomException(422, $message);
                $message = "Longitud incorrecta en usuario.";
                if (strlen($value) < 5) throw new ValidatorBoomException(422, $message);
            }
        }
    }
}
