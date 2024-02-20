<?php

use App\Models\Territory\LocalDistricts;
use Phalcon\Mvc\Micro\Collection;
use App\Db\App;
use App\Library\Misc\Utils;
use App\Controllers\TerritoryController;
use App\Controllers\LayersController;
use App\Controllers\SurveyController;
use App\Controllers\UsersController;
use App\Controllers\ProfilesController;



$app->get('/domain/config', function () use ($app, $config) {

    $data = App::getDomainConfigAsJson(Utils::getRequestDomain());

    return $data;
});


$app->get('/user/info', function () use ($app, $config) {
    $token = $app->getSharedService('token');
    $sql = "SELECT * FROM usuario.usuario WHERE id=" . $token->getUserId();
    $user = \App\Library\Db\Db::fetchAll($sql);
    return $user;
});


$app->get('/user/config', function () use ($app, $config) {

    $token = $app->getSharedService('token');

    $data = App::getUserConfigAsJson($token->getDomainId(), $token->getUserId());

    return $data;
});

$app->get('/modules/config', function () use ($app) {
    $token = $app->getSharedService("token");
    $mods = $token->getModules();

    $response = App::getModules($mods);

    return $response;
});

$app->get('/modules/config/all', function () use ($app) {
    $request = $app->request;
    $user = $request->get('user');
    $module = $request->get('module');
    $token = $app->getSharedService("token");
    $domainId = $token->getDomainId();
    return App::getModuleUserDomainConfig($user, $module, $domainId);
});

$app->get('/users', function () use ($app, $config) {
    $token = $app->getSharedService('token');
    $data = App::findUsersByDomain($token->getDomainId());
    return $data;
});

$app->get('/profiles', function () use ($app, $config) {
    $token = $app->getSharedService('token');
    $data = App::findProfilesByDomain($token->getDomainId());
    dep($data);
    return $data;
});

$app->get('/admin/domains', function () {
    $sql = "SELECT * FROM usuario.dominio WHERE activo=true";
    $domains = \App\Library\Db\Db::fetchAll($sql);
    return $domains;
});

$app->get('/admin/modules', function () {
    $sql = "SELECT * FROM usuario.modulo WHERE activo=true";
    $modules = \App\Library\Db\Db::fetchAll($sql);
    return $modules;
});

$app->get('/admin/permissions', function () {
    $sql = "SELECT * FROM usuario.permiso WHERE activo=true";
    $permissions = \App\Library\Db\Db::fetchAll($sql);
    return $permissions;
});

$app->get('/admin/roles', function () {
    $sql = "
        WITH permissions AS (
            SELECT 
                idperfil, 
                ARRAY_AGG(idpermiso) AS idpermiso
            FROM usuario.perfil_permiso 
            WHERE activo=true
            GROUP BY idperfil
        )
        
        SELECT r.*, p.idpermiso FROM usuario.perfil r
        FULL JOIN permissions p ON id=p.idperfil
        WHERE activo=true
    ";
    $roles = \App\Library\Db\Db::fetchAll($sql);

    foreach($roles as $r) {
        $permissions = $r->idpermiso;
        $r->idpermiso = array_map(
            'intval', 
            explode(',', str_replace(['{', '}'], '', $permissions))
        );
    }

    return $roles;
});

$app->mount(
    (new Collection())
        ->setHandler(UsersController::class, true)
        ->setPrefix('/admin')
        ->post("/users", "getUsers")
        ->post('/users/new', 'createUser')
        ->post('/users/getedituserinfo', 'getEditUserInfo')
        ->put('/users', 'updateUser')
        ->put('/users/reset', 'resetUserPass')
        ->put('/users/change', 'changeUserPass')
        ->delete('/users/{id}', 'deleteUser')
        ->post('/users/{id}/permissions', 'getPermissionsFromUser')
   

);
$app->mount(
    (new Collection())
    ->setHandler(ProfilesController::class, true)
    ->setPrefix('/admin')
    ->post("/profiles", "getProfiles")
    ->post('/profiles/new', 'createProfile')
    ->put('/profiles', 'updateProfile')
    ->post('/profiles/geteditprofileinfo', 'getEditProfileInfo')
    ->delete('/profiles/{id}', 'deleteProfile')
    ->post('/profiles/{id}/users', 'getUsersFromProfile')
    ->post('/profiles/{id}/permissions', 'getPermissionsFromProfile')
);