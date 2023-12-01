<?php

use App\Models\Territory\LocalDistricts;
use Phalcon\Mvc\Micro\Collection;
use App\Db\App;
use App\Library\Misc\Utils;
use App\Controllers\TerritoryController;
use App\Controllers\LayersController;
use App\Controllers\SurveyController;
use App\Controllers\UsersController;


$app->get('/domain/config', function () use ($app, $config) {

    $data = App::getDomainConfigAsJson(Utils::getRequestDomain());

    return $data;
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

$app->get('/admin/modules', function () {
    $sql = "SELECT * FROM usuario.modulo WHERE activo = true";
    $modules = \App\Library\Db\Db::fetchAll($sql);
    return $modules;
});

$app->get('/admin/permissions', function () {
    $sql = "SELECT * FROM usuario.permiso WHERE activo = true";
    $permissions = \App\Library\Db\Db::fetchAll($sql);
    return $permissions;
});

$app->get('/admin/groups', function () {
    $sql = "SELECT * FROM usuario.perfil WHERE activo = true";
    $profiles = \App\Library\Db\Db::fetchAll($sql);
    return $profiles;
});

$app->mount(
    (new Collection())
        ->setHandler(UsersController::class, true)
        ->setPrefix('/admin')
        ->post("/users", "getUsers")
        ->post('/users/new', 'createUser')
        ->post('/users/getedituserinfo', 'getEditUserInfo')
        ->put('/users', 'updateUser')
        ->delete('/users/{id}', 'deleteUser')
);
