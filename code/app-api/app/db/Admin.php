<?php

namespace App\Db;

use App\Library\Db\Db;
use App\Library\Http\Exceptions\HttpBadRequestException;
use App\Models\User;
use App\Models\Module;
use Error;
use Exception;

class Admin
{
    public static function getModules()
    {
        $modules = Module::find();
        return array('data' => $modules);
    }

    // public static function updateModule(id, data) {
    //     $sql = "";
    //     return;
    // }

    // public static function saveModule(data) {
    //     $sql = "";
    //     return;
    // }

    // public static function getModule(id) {
    //     $sql = "";
    //     return;
    // }

    // public static function activateModule(id) {
    //     $sql = "";
    //     return;
    // }

    // public static function deactivateModule(id) {
    //     $sql = "";
    //     return;
    // }

    // public static function deleteModule(id) {
    //     $sql = "";
    //     return;
    // }

    // public static function batchModules(data) {
    //     return await this.post("/modules/batch", data);
    // }

    // public static function getAllUsers() {
    //     $sql = "";
    //     return;
    // }

    public static function getAllPermissions()
    {
        $sql = "SELECT * FROM usuario.permiso";
        $permissions = Db::fetchAll($sql);
        return $permissions;
    }

    public static function getAllRoles()
    {
        $sql = "SELECT * FROM usuario.perfil";
        $profiles = Db::fetchAll($sql);
        return $profiles;
    }

    public static function getUsers($currentPage, $itemsPerPage)
    {
        $offset = ($currentPage - 1) * $itemsPerPage;
        $sql = "SELECT u.id, u.usuario, u.nombre, u.correo, u.activo FROM usuario.usuario u LIMIT $itemsPerPage OFFSET $offset";
        $users = Db::fetchAll($sql);

        $totalItems = User::count();
        $totalPages = ceil($totalItems / $itemsPerPage);

        return array(
            'data' => $users,
            'pages' => $totalPages,
            'total' => $totalItems,
        );
    }

    public static function createUser($data)
    {
            $sql = 'SELECT id FROM usuario.usuario WHERE usuario = :usuario';
            $params = array("usuario" => $data->usuario);
            $id = Db::fetchColumn($sql, $params);
            if($id) throw new Exception('El nombre de usuario ya se encuentra en uso.');

            $sql = 'INSERT INTO usuario.usuario (usuario, nombre, apepat, apemat, correo, admin, activo) VALUES (:usuario, :nombre, :apepat, :apemat, :correo, :admin, :activo)';
            $params = array("usuario" => $data->usuario, "nombre" => $data->nombre, "apepat" => $data->apepat, "apemat" => $data->apemat, "correo"  => $data->correo, "admin" => $data->admin ? 't' : 'f', "activo" => $data->activo ? 't' : 'f');
            Db::execute($sql, $params);

            $sql = 'UPDATE usuario.usuario SET clave = encode(sha256(:pass),\'hex\') WHERE usuario = :user';
            $params = array("pass" => $data->clave, "user" => $data->usuario);
            Db::execute($sql, $params);

            $sql = 'SELECT id FROM usuario.usuario WHERE usuario = :usuario';
            $params = array("usuario" => $data->usuario);
            $idusuario = Db::fetchColumn($sql, $params);

            $sql = 'INSERT INTO usuario.perfil_usuario (idusuario, idperfil) VALUES (:idusuario, :idperfil)';
            foreach ($data->roles as $r) {
                $params = array('idusuario' => $idusuario, 'idperfil' => $r);
                Db::execute($sql, $params);
            }

            $sql = 'INSERT INTO usuario.usuario_dominio_modulo (idusuario, iddominio, idmodulo) VALUES (:idusuario, :iddominio, :idmodulo)';
            foreach ($data->modulos as $m) {
                $params = array('idusuario' => $idusuario, 'iddominio' => 1, 'idmodulo' => $m);
                Db::execute($sql, $params);
            }

            $sql = 'INSERT INTO usuario.usuario_permiso (idusuario, idpermiso) VALUES (:idusuario, :idpermiso)';
            foreach ($data->permisos as $p) {
                $params = array('idusuario' => $idusuario, 'idpermiso' => $p);
                Db::execute($sql, $params);
            }
    }

    public static function deleteUser($id)
    {
        $tables = array(
            'usuario_dominio_configuracion',
            'usuario_dominio_modulo',
            'usuario_dominio',
            'perfil_usuario',
            'usuario_permiso'
        );

        foreach ($tables as $t) {
            $sql = "DELETE FROM usuario.$t WHERE idusuario = $id";
            Db::execute($sql);
        }

        $sql = "DELETE FROM usuario.usuario WHERE id = $id";
        return Db::execute($sql);
    }


    public static function updateUser()
    {
    }

    public static function getEditUserInfo($id)
    {
        //usuario
        $sql = 'SELECT id, usuario, clave, nombre, apepat, apemat, correo, admin, activo FROM usuario.usuario WHERE id = :id';
        $params = array('id' => $id);
        $user['usuario'] = Db::fetchAll($sql, $params)[0];

        //modulos
        $sql = 'SELECT idmodulo FROM usuario.usuario_dominio_modulo WHERE idusuario = :id';
        $params = array('id' => $id);
        $modules = Db::fetchAll($sql, $params);
        $user['usuario']->modulos = array_column($modules, 'idmodulo');

        //roles
        $sql = 'SELECT idperfil FROM usuario.perfil_usuario WHERE idusuario = :id';
        $params = array('id' => $id);
        $profiles = Db::fetchAll($sql, $params);
        $user['usuario']->roles = array_column($profiles, 'idperfil');

        //permisos
        $sql = 'SELECT idpermiso FROM usuario.usuario_permiso WHERE idusuario = :id';
        $params = array('id' => $id);
        $permissions = Db::fetchAll($sql, $params);
        $user['usuario']->permisos = array_column($permissions, 'idpermiso');

        return $user;
    }
}
