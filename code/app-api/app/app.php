<?php

use App\Controllers\DebitsController;
use App\Controllers\ImagesController;
use App\Controllers\ModulesController;
use App\Controllers\PersonsController;
use App\Controllers\ProcessController;
use App\Controllers\ProfilesController;
use App\Controllers\SurveyController;
use App\Controllers\TerritoryController;
use App\Controllers\UsersController;
use App\Controllers\CatalogController;
use App\Controllers\CompaniesController;
use App\Controllers\VehiclesController;
use App\Db\App;
use App\Library\Misc\Utils;
use App\Models\Territory\LocalDistricts;
use controllers\FirmsController;
use Phalcon\Mvc\Micro\Collection;


$app->get('/admin/domain/config', function () use ($app, $config) {

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
    return $data;
});

$app->get('/admin/domains', function () {
    $sql = "SELECT * FROM usuario.dominio WHERE activo=true";
    $domains = \App\Library\Db\Db::fetchAll($sql);
    return $domains;
});

// $app->get('/admin/modules', function () {
//     $sql = "SELECT * FROM usuario.modulo WHERE activo=true";
//     $modules = \App\Library\Db\Db::fetchAll($sql);
//     return $modules;
// });



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
        ->post('/users/getActivePermissionsFromUser', 'getActivePermissionsFromUser')
        ->put('/users', 'updateUser')
        ->put('/users/reset', 'resetUserPass')
        ->put('/users/change', 'changeUserPass')
        ->delete('/users/{id}', 'deleteUser')
        ->post('/users/{id}/permissions', 'getPermissionsFromUser')
        ->get('/users/users/{perfil}', 'users')
);

$app->mount(
    (new Collection())
    ->setHandler(ModulesController::class, true)
    ->setPrefix('/admin/modules')
    ->get('/', 'getAll')
    ->post('/', 'create')
    ->get('/{id}', 'get')
    ->post('/{id}', 'update')
    ->post('/{id}/activate', 'activate')
    ->post('/{id}/deactivate', 'deactivate')
    ->delete('/{id}', 'delete')
    ->post('/batch', 'batch')
    ->post('/getPermissionsOfModule', 'getPermissionsOfModule')
    ->post('/createPermission', 'createPermission')
    ->post('/updatePermission', 'updatePermission')  
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

$app->mount(
    (new Collection())
    ->setHandler(DebitsController::class, true)
    ->setPrefix('/admin')
    ->get("/debits/getServiceVindenUrlDebitaciones", "getServiceVindenUrlDebitaciones")
);

$app->mount(
    (new Collection())
    ->setHandler(ProcessController::class, true)
    ->setPrefix('/admin')
    ->post("/process/dinamycRegisterInProcess", "dinamycRegisterInProcess")
    ->post("/process/getInfoBySubStage", "getInfoBySubStage")
    ->post("/process/newDinamycSubStage", "newDinamycSubStage")
    ->get("/process/getAllModules", "getAllModules")
    ->get("/process/getAllProcess", "getAllProcess")
    ->get("/process/getAllStages", "getAllStages")
    ->get("/process/getAllSubStages", "getAllSubStages")
    ->get("/process/stages/{vclave}", "stages")
    ->get("/process/substages/{iidetapa}", "substages")
    ->get("/process/process/{iid}", "process")
    ->post("/process/getProcessWithStagesAndSubstages", "getProcessWithStagesAndSubstages")
    ->post("/process/getFlowByProcess", "getFlowByProcess")
    ->post("/process/newRegisterInProcess", "newRegisterInProcess")
    ->post("/process/getAllNextSubStagesEnabled", "getAllNextSubStagesEnabled")
    ->put("/process/updateRegisterInProcess", "updateRegisterInProcess")
    ->get("/process/getStructureFormDinamycProcess", "getStructureFormDinamycProcess")
    ->get ("/process/tracing/{vclave}/{iidfolio}", "getTracing")
);

$app->mount(
    (new Collection())
    ->setHandler(PersonsController::class, true)
    ->setPrefix('/admin')
    ->get("/persons/getAllSexes", "getAllSexes")
    ->get("/persons/getAllTypesOfAddress", "getAllTypesOfAddress")
    ->get("/persons/getAllTypesOfRoad", "getAllTypesOfRoad")
    ->get("/persons/getAllTypesPhone", "getAllTypesPhone")
    ->get("/persons/getAllLadaIdentifiers", "getAllLadaIdentifiers")
    ->get("/persons/getAllCivilStatus", "getAllCivilStatus")
    ->post("/persons/new", "createPerson")
    ->put("/persons/update", "updatePerson")
    ->post("/persons/direction/new", "createAddress")
    ->post("/persons/getPersonAddresses", "getPersonAddresses")
    ->post("/persons/getPersonPhones", "getPersonPhones")
    ->post("/persons/getGeneralPersonData", "getGeneralPersonData")
    ->post("/persons/updateCurrentAddress", "updateCurrentAddress")
    ->post("/persons/updateCurrentPhone", "updateCurrentPhone")
    ->post("/persons/deleteAddress", "deleteAddress")
    ->post("/persons/deletePhone", "deletePhone")
    ->put("/persons/direction", "updateAddress")
    ->post("/persons/phone/new", "createPhone")
    ->put("/persons/phone", "updatePhone")
    ->post("/persons/getPersonByDinamycSearch", "getPersonByDinamycSearch")
);

$app->mount(
    (new Collection())
    ->setHandler(TerritoryController::class, true)
    ->setPrefix('/admin')
    ->get("/territory/allStates", "getEsatdos")
    ->get("/territory/municipalities/{iclave_estado}", "getMunicipioByEstado")
    ->get("/territory/localities/{iclave_estado}/{iclave_municipio}", "getLocalities")
    ->get("/territory/localities/{iclave_estado}", "getLocalities")
    ->get("/territory/localities", "getLocalities")
    ->get("/territory/getAllPostalCodes", "getAllPostalCodes")
    ->post("/territory/getMunicipalityAndEntityByPostalCode", "getMunicipalityAndEntityByPostalCode")
    ->post("/territory/getColoniesByPostalCode", "getColoniesByPostalCode") 
);

$app->mount(
    (new Collection())
    ->setHandler(CatalogController::class, true)
    ->setPrefix('/admin')
    ->get("/catalog/companies", "getCompanies")
    ->get("/catalog/concessions", "getConcessions")
    ->get("/catalog/concessions/{id}", "getConcessions")
    ->get("/catalog/operators", "getOperators")
    ->get("/catalog/operators/{idEmpresa}", "getOperators")
    ->get("/catalog/routes", "routes")
    ->get("/catalog/licensesType", "licensesType")
);

$app->mount(
    (new Collection())
    ->setHandler(DebitsController::class, true)
    ->setPrefix('/admin')
    ->get("/debits/getServiceVindenUrlDebitaciones", "getServiceVindenUrlDebitaciones")
);


$app->mount(
    (new Collection())
    ->setHandler(CompaniesController::class, true)
    ->setPrefix('/admin')
    ->post("/companies", "getCompanies")
    ->post("/companies/getPersonByCurp", "getPersonByCurp")
    ->post("/companies/new", "createCompany")
    ->put("/companies", "updateCompany")
    ->delete("/companies/{id}", "deleteCompany")
    ->post("/companies/getCompanyInfo", "getCompanyInfo")
);

$app->mount(
    (new Collection())
        ->setHandler(ImagesController::class, true)
        ->setPrefix('/admin/images')
        ->get("/", "get")
);

$app->mount(
    (new Collection())
    ->setHandler(VehiclesController::class, true)
    ->setPrefix('/admin')
    ->get("/catalog/vehicles", "getVehicles")
    ->get("/catalog/vehicles/{id}", "getVehicles")
    ->get("/catalog/vehiclesType", "typeVehicles") 
    ->get("/vehicles/getBrand", "getBrand") 
    ->get("/vehicles/getModel", "getModel")
    ->get("/vehicles/getFuelType", "getFuelType")
);


