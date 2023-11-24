<?php

use App\Db\Admin;

$app->get('/admin/modules', function () {
    return Admin::getModules();
});

// $app->post('/admin/modules/{id}', function($id) use ($app) {
//     $data = $app->request->getJsonRawBody();
// });

// $app->post('/admin/modules', function() use ($app) {
//     $data = $app->request->getJsonRawBody();
// });

// $app->get('/admin/modules/{id}', function($id) use ($app) {});

// $app->post('/admin/modules/{id}/activate', function($id) use ($app) {});

// $app->post('/admin/modules/{id}/deactivate', function($id) use ($app) {});

// $app->delete('/admin/modules/{id}', function($id) use ($app) {});

// $app->post('/admin/modules/batch', function() use ($app) {
//     $data = $app->request->getJsonRawBody();
// });

// $app->post('/admin/users/', function() use ($app) {});

$app->get('/admin/permissions', function () {
    return Admin::getAllPermissions();
});

$app->get('/admin/groups', function () {
    return Admin::getAllRoles();
});

//Usuarios
$app->post('/admin/users', function () use ($app) {
    $data = $app->request->getJsonRawBody();
    $currentPage = $data->currentPage;
    $itemsPerPage = $data->itemsPerPage;
    return Admin::getUsers($currentPage, $itemsPerPage);
});

$app->post('/admin/users/new', function () use ($app) {
    $data = $app->request->getJsonRawBody();
    return Admin::createUser($data);
});

$app->delete('/admin/users/{id}', function ($id) {
    return Admin::deleteUser($id);
});

$app->put('/admin/users/{id}', function ($id) {
    return array('ID' =>$id);
    // return Admin::updateUser($id);
});

$app->post('/admin/users/getedituserinfo', function () use ($app) {
    $data = $app->request->getJsonRawBody();
    return Admin::getEditUserInfo($data->id);
});
