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

    public function createUser()
    {
        $data = $this->request->getJsonRawBody();

        $id = $this->getUserId($data->usuario);
        if ($id) return array('created' => false);

        $admin = $data->admin ? 't' : 'f';
        $activo = $data->activo ? 't' : 'f';
        $apemat = empty($data->apemat) ? null : $data->apemat;
        $correo = empty($data->apemat) ? null : $data->correo;

        $sql = 'INSERT INTO usuario.usuario (usuario, clave, nombre, apepat, apemat, correo, admin, activo) VALUES (:usuario, encode(sha256(:clave),\'hex\'), :nombre, :apepat, :apemat, :correo, :admin, :activo)';
        $params = array(
            'usuario' => $data->usuario,
            'clave'   => $data->clave,
            'nombre'  => $data->nombre,
            'apepat'  => $data->apepat,
            'apemat'  => $apemat,
            'correo'  => $correo,
            'admin'   => $admin,
            'activo'  => $activo
        );
        Db::execute($sql, $params);

        $iduser = $this->getUserId($data->usuario);
        $iddomain = (int) $this->config->dns->id;

        $sql = 'INSERT INTO usuario.usuario_dominio (idusuario, iddominio) VALUES (:idusuario, :iddominio)';
        $params = array(":idusuario" => $iduser, 'iddominio' => $iddomain);
        Db::execute($sql, $params);

        $sql = 'INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo) VALUES (:idusuario, :iddominio, :idmodulo)';
        foreach ($data->modulos as $m) {
            $params = array('idusuario' => $iduser, 'iddominio' => $iddomain, 'idmodulo' => $m);
            Db::execute($sql, $params);
        }

        $sql = 'INSERT INTO usuario.usuario_permiso (idusuario, idpermiso) VALUES (:idusuario, :idpermiso)';
        foreach ($data->permisos as $p) {
            $params = array('idusuario' => $iduser, 'idpermiso' => $p);
            Db::execute($sql, $params);
        }

        $sql = 'INSERT INTO usuario.perfil_usuario (idusuario, idperfil) VALUES (:idusuario, :idperfil)';
        foreach ($data->roles as $r) {
            $params = array('idusuario' => $iduser, 'idperfil' => $r);
            Db::execute($sql, $params);
        }

        return array('created' => true);
    }

    public function deleteUser($id)
    {
        $tables = array(
            'usuario_dominio_modulo',
            'usuario_dominio',
            'perfil_usuario',
            'usuario_permiso'
        );

        $params = array('id' => $id);

        foreach ($tables as $t) {
            $sql = "DELETE FROM usuario.$t WHERE idusuario = :id";
            Db::execute($sql, $params);
        }

        $sql = "DELETE FROM usuario.usuario WHERE id = :id";
        return Db::execute($sql, $params);
    }


    public function updateUser()
    {
    }

    public function getEditUserInfo()
    {
        $data = $this->request->getJsonRawBody();
        $params = array('id' => $data->id, 'activo' => 't');

        //usuario
        $sql = 'SELECT id, usuario, clave, nombre, apepat, apemat, correo, admin, activo FROM usuario.usuario WHERE id=:id AND activo=:activo';
        $user['usuario'] = Db::fetchAll($sql, $params)[0];

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

    private function getUserId($username)
    {
        $sql = 'SELECT id FROM usuario.usuario WHERE usuario = :usuario';
        $params = array("usuario" => $username);
        return Db::fetchColumn($sql, $params);
    }
}
