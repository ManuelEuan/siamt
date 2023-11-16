<?php

namespace App\Db;

use App\Library\Db\Db;
use App\Models\User;
use App\Models\Module;

class Admin
{
    // public static function fetchUsers(){
    //     $sql = "";
    //     return ;
    // }

    // public static function fetchUsers() {
    //     $sql = "";
    //     return ;
    // }

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

    public static function getEditUserInfo($id)
    {
        //usuario
        $sql = "SELECT u.id, u.usuario, u.clave, u.nombre, u.apepat, u.apemat, u.correo, u.admin, u.activo FROM usuario.usuario u WHERE u.id=$id";
        $user['usuario'] = Db::fetchAll($sql)[0];

        //modulos
        $sql = "SELECT m.idmodulo FROM usuario.usuario_dominio_modulo m WHERE m.idusuario=$id";
        $userModules = array_column(Db::fetchAll($sql), 'idmodulo');
        $userModules = implode(',', $userModules);
        $sql = "SELECT * FROM usuario.modulo m WHERE m.id IN ($userModules)";
        $user['usuario']->modulos = Db::fetchAll($sql);

        //roles
        $sql = "SELECT p.idperfil FROM usuario.perfil_usuario p WHERE p.idusuario=$id";
        $userProfiles = array_column(Db::fetchAll($sql), 'idperfil');
        $userProfiles = implode(',', $userProfiles);
        $sql = "SELECT * FROM usuario.perfil p WHERE p.id IN ($userProfiles)";
        $user['usuario']->roles = Db::fetchAll($sql);

        //permisos
        $sql = "SELECT p.idperfil FROM usuario.perfil_usuario p WHERE p.idusuario=$id";
        $userProfiles = array_column(Db::fetchAll($sql), 'idperfil');
        $userProfiles = implode(',', $userProfiles);
        $sql = "SELECT * FROM usuario.perfil p WHERE p.id IN ($userProfiles)";
        $user['roles'] = $userProfiles;

        return $user;
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
}
