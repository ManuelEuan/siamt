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

class UsersController extends BaseController
{
    private $tables = array(
        'usuario_dominio_configuracion',
        'usuario_dominio_modulo',
        'usuario_dominio',
        'perfil_usuario',
        'usuario_permiso',
        'usuario'
    );

    public function getUsers()
    {
        $data = $this->request->getJsonRawBody();
        $itemsPerPage = $data->itemsPerPage;
        $offset = ($data->page - 1) * $itemsPerPage;

        $sql = '
            WITH usuarios AS (
                SELECT
                    id,
                    usuario,
                    NULL AS clave,
                    nombre,
                    apepat,
                    apemat,
                    correo,
                    admin,
                    activo,
                    fecha_creacion,
                    fecha_modificacion,
                    TRIM(TRAILING FROM CONCAT(nombre, \' \', apepat, \' \', apemat)) AS nombre_completo
                FROM usuario.usuario
            )
        ';
        $params = array();

        if ($data->filters) {
            list($sql2, $params2) = $this->filterUsers($data->filters);
            $sql .= $sql2;
            $params += $params2;
        } else {
            $sql .= 'SELECT u.*, COUNT(u.id) OVER() AS total_usuarios FROM usuarios u ';
        }

        $sql .= $this->sortUsers($data->sortBy, $data->sortDesc);

        if ($itemsPerPage > 0) {
            $sql .= 'LIMIT :items OFFSET :offset';
            $params['items'] = $itemsPerPage;
            $params['offset'] = $offset;
        }

        $users = Db::fetchAll($sql, $params);
        $totalItems = $users[0]->total_usuarios ?? 0;
        $totalPages = ceil($totalItems / $itemsPerPage);

        return array(
            'users' => $users,
            'totalPages' => $totalPages,
            'totalItems' => $totalItems,
        );
    }

    public function getEditUserInfo()
    {
        $this->hasClientAuthorized('veus');

        $data = $this->request->getJsonRawBody();

        if (empty($data->id)) throw new ValidatorBoomException(422, 'Id requerido.');

        $sql = '
            SELECT 
                id, 
                usuario, 
                NULL AS clave, 
                nombre, 
                apepat, 
                apemat, 
                correo, 
                admin, 
                activo,
                TO_CHAR(fecha_creacion, \'DD-MM-YYYY HH24:MI:SS\') AS fecha_creacion,
                TO_CHAR(fecha_modificacion, \'DD-MM-YYYY HH24:MI:SS\') AS fecha_modificacion
            FROM usuario.usuario
            WHERE id=:id
        ';
        $params = array('id' => $data->id);
        $user['usuario'] = Db::fetchOne($sql, $params);

        $sql = 'SELECT iddominio FROM usuario.usuario_dominio WHERE idusuario=:id AND activo=true';
        $domains = Db::fetchAll($sql, $params);
        $user['usuario']->dominios = array_column($domains, 'iddominio');

        // $sql = 'SELECT idmodulo FROM usuario.usuario_dominio_modulo WHERE idusuario=:id AND activo=true';
        // $modules = Db::fetchAll($sql, $params);
        // $user['usuario']->modulos = array_column($modules, 'idmodulo');

        $sql = 'SELECT idperfil FROM usuario.perfil_usuario WHERE idusuario=:id AND activo=true';
        $roles = Db::fetchAll($sql, $params);
        $user['usuario']->perfiles = array_column($roles, 'idperfil');

        // $sql = '
        //     WITH role_permissions AS (
        //         SELECT r.idpermiso FROM usuario.perfil_permiso r
        //         INNER JOIN usuario.perfil_usuario u ON r.idperfil = u.idperfil
        //         WHERE u.idusuario = :id
        //     ), user_permissions AS (
        //         SELECT idpermiso FROM usuario.usuario_permiso 
        //         WHERE idusuario = :id
        //     )

        //     SELECT idpermiso FROM role_permissions 
        //     UNION 
        //     SELECT idpermiso FROM user_permissions
        // ';
        $sql = '
        WITH perfiles_activos AS (
            -- Obtener los IDs de los perfiles activos del usuario con idusuario = 6
            SELECT idperfil
            FROM usuario.perfil_usuario
            WHERE idusuario = :id AND activo = true
        ),
        permisos_activos AS (
            -- Obtener los IDs de los permisos activos para los perfiles obtenidos
            SELECT idpermiso
            FROM usuario.perfil_permiso
            WHERE idperfil IN (SELECT idperfil FROM perfiles_activos) AND activo = true
        )
        -- Seleccionar los permisos activos
        SELECT *
        FROM permisos_activos;
        
        ';
        $permissions = Db::fetchAll($sql, $params);
        $user['usuario']->permisos = array_column($permissions, 'idpermiso');

        return $user;
    }

    public function getPermissionsFromUser()
    {
        $data = $this->request->getJsonRawBody();
        $params = array('id' => $data->id);
        $sql = '
        WITH perfiles_activos AS (
            -- Obtener los IDs de los perfiles activos del usuario con idusuario = 6
            SELECT idperfil
            FROM usuario.perfil_usuario
            WHERE idusuario = :id AND activo = true
        ),
        permisos_activos AS (
            -- Obtener los IDs de los permisos activos para los perfiles obtenidos
            SELECT *
            FROM usuario.perfil_permiso
            WHERE idperfil IN (SELECT idperfil FROM perfiles_activos) AND activo = true
        )
        -- Seleccionar los permisos activos
        SELECT *
        FROM permisos_activos;
        ';
        $permissions = Db::fetchAll($sql, $params);
        $permissions = array_column($permissions, 'idpermiso');

        $ids_permisos = implode(",", $permissions);

        $sql = "WITH permisos_cte AS (SELECT * FROM usuario.permiso WHERE id IN ($ids_permisos))
                SELECT * FROM permisos_cte;";
        $permissions = Db::fetchAll($sql);
        foreach ($permissions as $permission) {
            $idmodulo = $permission->idmodulo;
            if (!isset($arreglo_agrupado[$idmodulo])) {
                $arreglo_agrupado[$idmodulo] = [];
            }
            $arreglo_agrupado[$idmodulo][] = $permission;
        }
        $claves = array_keys($arreglo_agrupado);
        $ids_modulos = implode(",", $claves);
        $sql = "WITH modulos AS (SELECT * FROM usuario.modulo WHERE id IN ($ids_modulos))
                SELECT * FROM modulos;";

        $modulos = Db::fetchAll($sql);
        foreach ($modulos as $objeto) {
            $id = $objeto->id;
            if (isset($arreglo_agrupado[$id])) {
                $objeto->permisos = $arreglo_agrupado[$id];
            } else {
                $objeto->permisos = array();
            }
        }
        return $modulos;
    }

    public function createUser()
    {
        $this->hasClientAuthorized('crus');

        $data = $this->request->getJsonRawBody();
        $this->validRequiredData($data);

        Db::begin();

        $id = $this->isUsernameInUse($data->usuario);
        if ($id) throw new ValidatorBoomException(422, 'El usuario ya se encuentra en uso.');

        $params = array(
            'usuario' => $data->usuario,
            'clave'   => $data->usuario,
            'nombre'  => $data->nombre,
            'apepat'  => $data->apepat,
            'apemat'  => empty($data->apemat) ? null : $data->apemat,
            'correo'  => empty($data->correo) ? null : $data->correo,
            'admin'   => $data->admin ? 't' : 'f'
        );

        $this->insert('usuario', $params);

        $data->id = $this->isUsernameInUse($data->usuario);

        $this->processUserAssociations($data, 'insert');

        Db::commit();
        return array('message' => 'El usuario ha sido creado.');
    }

    public function updateUser()
    {
        $this->hasClientAuthorized('edus');

        $data = $this->request->getJsonRawBody();
        $this->validRequiredData($data);

        Db::begin();

        if ($this->isUsernameChanged($data->usuario, $data->id)) {
            if ($this->isUsernameInUse($data->usuario)) {
                throw new ValidatorBoomException(422, 'El usuario ya se encuentra en uso.');
            }
        }

        $sql = '
            UPDATE usuario.usuario 
            SET 
                usuario=:usuario, 
                nombre=:nombre, 
                apepat=:apepat, 
                apemat=:apemat, 
                correo=:correo,
                admin=:admin
            WHERE id=:id
        ';

        $params = array(
            'usuario' => $data->usuario,
            'nombre'  => $data->nombre,
            'apepat'  => $data->apepat,
            'apemat'  => empty(trim($data->apemat)) ? null : $data->apemat,
            'correo'  => empty(trim($data->apemat)) ? null : $data->correo,
            'admin'   => $data->admin ? 't' : 'f',
            'id'      => $data->id
        );

        Db::execute($sql, $params);

        foreach ($this->tables as $t) {
            if ($t === 'usuario' || $t === 'usuario_dominio_configuracion') continue;
            $this->deactivate($t, $data->id);
        }

        $this->processUserAssociations($data, 'activate');

        Db::commit();
        return array('message' => 'El usuario ha sido actualizado.');
    }

    public function deleteUser($id)
    {
        $this->hasClientAuthorized('bous');

        $sql = "SELECT activo FROM usuario.usuario WHERE id=:id";
        $params = array('id' => $id);
        $active = Db::fetchColumn($sql, $params);

        $sql = "UPDATE usuario.usuario SET activo=:activo WHERE id=:id";
        $params = array('activo' => $active ? 'f' : 't', 'id' => $id);
        Db::execute($sql, $params);

        $msg = $active ? 'desactivado' : 'activado';
        return array('message' => "El usuario ha sido $msg.");
    }

    public function resetUserPass()
    {
        $this->hasClientAuthorized('reco');

        $data = $this->request->getJsonRawBody();

        $sql = 'SELECT usuario FROM usuario.usuario WHERE id=:id';
        $params = array('id' => $data->id);
        $username = Db::fetchColumn($sql, $params);

        $sql = 'UPDATE usuario.usuario SET clave=encode(sha256(:clave),\'hex\') WHERE id=:id';
        $params = array('id' => $data->id, 'clave' => $username);
        Db::execute($sql, $params);

        return array('message' => 'La contraseña a sido restablecida.');
    }

    public function changeUserPass()
    {
        $this->hasClientAuthorized('caco');

        $data = $this->request->getJsonRawBody();
        $this->validPass($data);

        $sql = 'UPDATE usuario.usuario SET clave=encode(sha256(:clave),\'hex\') WHERE id=:id';
        $params = array('id' => $data->id, 'clave' => $data->clave);
        Db::execute($sql, $params);

        return array('message' => 'La contraseña a sido modificada');
    }



    private function isUsernameInUse($username)
    {
        $sql = 'SELECT id FROM usuario.usuario WHERE usuario=:usuario';
        $params = array('usuario' => $username);
        return Db::fetchColumn($sql, $params);
    }

    private function isUsernameChanged($username, $id)
    {
        $sql = 'SELECT usuario FROM usuario.usuario WHERE id=:id';
        $params = array('id' => $id);
        return !(Db::fetchColumn($sql, $params) === $username);
    }

    private function hasClientAuthorized($permission)
    {
        $permissions = $this->token->getPermissions()['usr'];

        if (!in_array($permission, $permissions)) {
            if ($permission === 'veus' && in_array('edus', $permissions)) return;
            throw new HttpUnauthorizedException(401, 'Permisos insuficientes.');
        }
    }



    private function insert($table, $params)
    {
        $cols = implode(', ', array_keys($params));
        $phs = ':' . str_replace(', ', ', :', $cols);
        $phs = str_replace(':clave', 'encode(sha256(:clave),\'hex\')', $phs);

        $sql = "INSERT INTO usuario.$table ($cols) VALUES ($phs)";
        Db::execute($sql, $params);
    }

    private function deactivate($table, $id)
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

    private function processUserAssociations($data, $associationHandler)
    {
        foreach ($data->dominios as $d) {
            $params = array('idusuario' => $data->id, 'iddominio' => $d);
            $this->$associationHandler('usuario_dominio', $params);

            foreach ($data->modulos as $m) {
                $params = array('idusuario' => $data->id, 'iddominio' => $d, 'idmodulo' => $m);
                $this->$associationHandler('usuario_dominio_modulo', $params);
            }
        }

        foreach ($data->permisos as $p) {
            $params = array('idusuario' => $data->id, 'idpermiso' => $p);
            $this->$associationHandler('usuario_permiso', $params);
        }

        foreach ($data->perfiles as $r) {
            $this->verifyRolePermissions($r, $data->permisos);
            $params = array('idusuario' => $data->id, 'idperfil' => $r);
            $this->$associationHandler('perfil_usuario', $params);
        }
    }

    private function filterUsers($filters)
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
                u.*,
                COUNT(u.id) OVER() AS total_usuarios 
            FROM usuarios u
            INNER JOIN filtro_roles r ON u.id=r.idusuario
        ';
        $params['roles'] = '{' . implode(', ', $filters->roles) . '}';

        if (!$filters->roles) {
            $sql = 'SELECT u.*, COUNT(u.id) OVER() AS total_usuarios FROM usuarios u ';
            unset($params['roles']);
        }

        $sql2 = 'WHERE ';

        foreach ($filters as $filter => $value) {
            if (empty($value) || $filter === 'roles') continue;
            if ($sql2 !== 'WHERE ') $sql2 .= 'AND ';

            switch ($filter) {
                case 'active':
                    $sql2 .= 'u.activo = :active ';
                    $params['active'] = $filters->active;
                    break;
                case 'name':
                    $sql2 .= "u.nombre_completo ILIKE :name ";
                    $params['name'] = '%' . $filters->name . '%';
                    break;
                case 'username':
                    $sql2 .= "u.usuario ILIKE :username ";
                    $params['username'] = '%' . $filters->username . '%';
                    break;
            }
        }

        if ($sql2 !== 'WHERE ') $sql .= $sql2;

        return array($sql, $params);
    }

    private function sortUsers($sortBy, $sortDesc)
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
                    $sql .= 'u.usuario ';
                    break;
                case 'nombre_completo':
                    $sql .= 'u.nombre_completo ';
                    break;
                case 'correo':
                    $sql .= 'u.correo ';
                    break;
                case 'activo':
                    $sql .= 'u.activo ';
                    break;
                default:
                    $sql .= 'u.id';
            }

            $sql .= "$order NULLS LAST";
            $sql .= $i < $comma ? ', ' : ' ';
        }

        return $sql;
    }

    private function validRequiredData($data)
    {
        $requiredKeys = array('nombre', 'apepat', 'usuario', 'dominios');
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

    private function validPass($data)
    {
        $dataKeys = array_keys(get_object_vars($data));

        $message = 'Clave requerida.';
        if (!in_array('clave', $dataKeys)) throw new ValidatorBoomException(422, $message);

        $message = 'Tipo de valor incorrecto en clave.';
        if (!is_string($data->clave)) throw new ValidatorBoomException(422, $message);

        $message = "Valor vacío en clave.";
        if ($data->clave === '') throw new ValidatorBoomException(422, $message);

        $message = 'Longitud incorrecta en clave.';
        if (strlen($data->clave) < 8) throw new ValidatorBoomException(422, $message);
    }
}
