<?php

namespace app\controllers;

use Phalcon\Registry;

use App\Library\Http\Controllers\BaseController;
use App\Library\Misc\Utils;
use App\Models\Layers\Layer;
use App\Models\Layers\BaseLayer;
use App\Models\Territory\LocalDistricts;
use App\Models\Territory\Sections;
use App\Library\Db\Db;
use App\Models\User;
use App\Models\Module;

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
        $currentPage = $data->currentPage;
        $itemsPerPage = $data->itemsPerPage;
        $offset = ($currentPage - 1) * $itemsPerPage;

        $sql = 'SELECT * FROM usuario.usuario LIMIT :items OFFSET :offset';
        $params = array('items' => $itemsPerPage, 'offset' => $offset);

        if ($itemsPerPage < 0) {
            $sql = 'SELECT * FROM usuario.usuario';
            $params = null;
        }

        $users = Db::fetchAll($sql, $params);

        $totalItems = User::count();
        $totalPages = ceil($totalItems / $itemsPerPage);

        return array(
            'data' => $users,
            'pages' => $totalPages,
            'total' => $totalItems,
        );
    }

    public function getEditUserInfo()
    {
        $data = $this->request->getJsonRawBody();
        $params = array('id' => $data->id, 'activo' => 't');

        //usuario
        $sql = 'SELECT id, usuario, clave, nombre, apepat, apemat, correo, admin, activo FROM usuario.usuario WHERE id=:id AND activo=:activo';
        $user['usuario'] = Db::fetchAll($sql, $params)[0];

        //dominios
        $sql = 'SELECT iddominio FROM usuario.usuario_dominio WHERE idusuario=:id AND activo=:activo';
        $dominios = Db::fetchAll($sql, $params);
        $user['usuario']->dominios = array_column($dominios, 'iddominio');

        //modulos
        $sql = 'SELECT idmodulo FROM usuario.usuario_dominio_modulo WHERE idusuario=:id AND activo=:activo';
        $modules = Db::fetchAll($sql, $params);
        $user['usuario']->modulos = array_column($modules, 'idmodulo');

        //roles
        $sql = 'SELECT idperfil FROM usuario.perfil_usuario WHERE idusuario=:id AND activo=:activo';
        $profiles = Db::fetchAll($sql, $params);
        $user['usuario']->roles = array_column($profiles, 'idperfil');

        //permisos
        $sql = 'SELECT idpermiso FROM usuario.usuario_permiso WHERE idusuario=:id AND activo=:activo';
        $permissions = Db::fetchAll($sql, $params);
        $user['usuario']->permisos = array_column($permissions, 'idpermiso');

        return $user;
    }

    public function createUser()
    {
        try {
            $data = $this->request->getJsonRawBody();

            Db::begin();

            if ($this->isUsernameInUse($data->usuario)) throw new \Exception('El nombre de usuario ya se encuentra en uso.');

            $params = array(
                'usuario' => $data->usuario,
                'clave'   => $data->clave,
                'nombre'  => $data->nombre,
                'apepat'  => $data->apepat,
                'apemat'  => empty($data->apemat) ? null : $data->apemat,
                'correo'  => empty($data->apemat) ? null : $data->correo,
                'admin'   => $data->admin ? 't' : 'f',
                'activo'  => $data->activo ? 't' : 'f'
            );

            $this->insert('usuario', $params);

            $data->id = $this->isUsernameInUse($data->usuario);
            $this->processUserAssociations($data, 'insert');

            Db::commit();
            return array('success' => true, 'message' => 'El usuario ha sido creado.');
        } catch (\Exception $e) {
            Db::rollback();
            $msg = 'No fue posible crear el usuario. ' . $e->getMessage();
            return array('success' => false, 'message' => $msg);
        }
    }

    public function updateUser()
    {
        try {
            $data = $this->request->getJsonRawBody();

            Db::begin();

            if ($this->isUsernameChanged($data->usuario, $data->id) && $this->isUsernameInUse($data->usuario))
                throw new \Exception('El nombre de usuario ya se encuentra en uso.');

            $sql = '
                UPDATE usuario.usuario 
                SET usuario=:usuario, clave=encode(sha256(:clave),\'hex\'), nombre=:nombre, apepat=:apepat, apemat=:apemat, correo=:correo, admin=:admin, activo=:activo
                WHERE id=:id
            ';

            $params = array(
                'usuario' => $data->usuario,
                'clave'   => $data->clave,
                'nombre'  => $data->nombre,
                'apepat'  => $data->apepat,
                'apemat'  => empty($data->apemat) ? null : $data->apemat,
                'correo'  => empty($data->apemat) ? null : $data->correo,
                'admin'   => $data->admin ? 't' : 'f',
                'activo'  => $data->activo ? 't' : 'f',
                'id'      => $data->id
            );

            if (!$data->clave) {
                unset($params['clave']);
                $sql = '
                    UPDATE usuario.usuario 
                    SET usuario=:usuario, nombre=:nombre, apepat=:apepat, apemat=:apemat, correo=:correo, admin=:admin, activo=:activo
                    WHERE id=:id
                ';
            }

            if (!Db::execute($sql, $params)) throw new \Exception('Error durante registro.');

            foreach ($this->tables as $t) {
                if ($t === 'usuario' || $t === 'usuario_dominio_configuracion') continue;
                $this->deactivate($t, $data->id);
            }

            $this->processUserAssociations($data, 'activate');

            Db::commit();
            return array('success' => true, 'message' => 'El usuario ha sido actualizado.');
        } catch (\Exception $e) {
            Db::rollback();
            $msg = 'No fue posible actualizar el usuario. ' . $e->getMessage();
            return array('success' => false, 'message' => $msg);
        }
    }

    public function deleteUser($id)
    {
        try {
            Db::begin();

            $params = array('id' => $id);
            foreach ($this->tables as $t) {
                $sql = "DELETE FROM usuario.$t WHERE " . ($t === 'usuario' ? 'id' : 'idusuario') . '=:id';
                if (!Db::execute($sql, $params)) throw new \Exception("Error de borrado en $t");
            }

            Db::commit();
            return array('success' => true, 'message' => 'El usuario ha sido borrado.');
        } catch (\Exception $e) {
            $msg = 'No fue posible borrar el usuario. ' . $e->getMessage();
            return array('success' => false, 'message' => $msg);
        }
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

    private function insert($table, $params)
    {
        $cols = implode(', ', array_keys($params)); // table columns
        $phs = ':' . str_replace(', ', ', :', $cols); // params place holders

        $sql = "INSERT INTO usuario.$table ($cols) VALUES ($phs)";
        if (!Db::execute($sql, $params)) throw new \Exception("Error durante registro en $table");
    }

    private function deactivate($table, $id)
    {
        $sql = "UPDATE usuario.$table SET activo=false WHERE idusuario=:idusuario";
        $params = array('idusuario' => $id);
        if (!Db::execute($sql, $params)) throw new \Exception("Error durante desactivación en $table.");
    }

    private function activate($table, $params)
    {
        $cols = implode(', ', array_keys($params)); // table columns
        $phs = ':' . str_replace(', ', ', :', $cols); // params place holders

        $sql = "SELECT * FROM usuario.$table WHERE ($cols) IN (($phs))";
        $exist = Db::fetchOne($sql, $params);

        $sql = $exist
            ? "UPDATE usuario.$table SET activo=true WHERE ($cols) IN (($phs))"
            : "INSERT INTO usuario.$table ($cols) VALUES ($phs)";

        if (!Db::execute($sql, $params)) throw new \Exception("Error durante activación en $table.");
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

        foreach ($data->roles as $r) {
            $params = array('idusuario' => $data->id, 'idperfil' => $r);
            $this->$associationHandler('perfil_usuario', $params);
        }
    }
}
