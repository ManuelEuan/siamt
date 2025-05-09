<?php

use App\Db\Auth;
use App\Library\Http\Exceptions\HttpBadRequestException;
use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Misc\Utils;
use App\Library\Security\JwtBuilder;
use App\Models\Device;
use Phalcon\Security\JWT\Signer\Hmac;

$app->post('/login', function () use($app, $config) {
    $body = $app->request->getJsonRawBody();

    if(empty($body->username) or empty($body->password) or empty($body->application) or empty($body->device))
    {
        throw new HttpBadRequestException(100,'Nombre de usuario y clave son requeridas');
    }

    if(!Device::get($body->device,$body->application)->bpermitido){
        throw new HttpUnauthorizedException(102,'Usuario/Clave incorrecta');
    }

    $user = Auth::findFirstByUsuarioAndAplicacion($body->username, $body->application);
    if(empty($user))
    {
        throw new HttpUnauthorizedException(103,'Usuario/Clave incorrecta');
    }

    $idInspector = null;
    if($body->application == 'ee4f34f79e9d43156aa09bb2ffd5b725') {
        $user = Auth::validateInspector($body->username);

        if (empty($user)) {
            throw new HttpUnauthorizedException(104, 'Usuario/Clave incorrecta');
        }

        $idInspector = $user->iidinspector;
    }

    $user = Auth::login($body->username, $body->password, Utils::getRequestDomain());

    if(empty($user))
    {
        throw new HttpUnauthorizedException(101,'Usuario/Clave incorrecta');
    }
    $permissions = Auth::getUserPermissionsAsJson($user->idusuario, $user->iddominio);
    // var_dump($permissions);exit;
    $now = time();
    $signer = new Hmac($config->jwt->alg);
    $builder = new JwtBuilder($signer);
    $builder
        ->setIssuedAt($now)
        ->setExpirationTime($now + $config->jwt->duration)
        ->setSubject($body->username)
        ->setIpAddress(md5(Utils::getClientIp()))
        ->setUserId($user->idusuario)
        ->setInspectorId($idInspector)
        ->setDomainId($user->iddominio)
        ->setDomain(md5($user->dominio))
        ->setUserFullName($user->nombre)
        ->setPermissions(json_decode($permissions->permisos))
        ->setPassphrase($config->jwt->secret);

    $app->getSharedService('redis')->publishToQueue($config->app->auditQueue, $config->app->auditQueue);

    error_log("json: ".json_encode($builder), 0);
    error_log("token: ".$builder->getToken()->getToken(), 0);
    return [
        'token' => $builder->getToken()->getToken()
    ];
});

$app->post('/changepassword', function () use ($app, $config) {
    $body = $app->request->getJsonRawBody();
    $resp = Auth::changePassword($body->username, $body->password);
    if(count($resp)){
         return $data = json_encode(array('lError' => false));
    }
    return $data = json_encode(array('lError' => true));
});

$app->get('/users', function () use ($app, $config) {
    $resp = Auth::getUsers();
    if(count($resp)){
         return $data = json_encode(array('lError' => false, 'data' => $resp));
    }
    return $data = json_encode(array('lError' => true));
});
// $app->get('/profiles', function () use ($app, $config) {
//     $resp = Auth::getUsers();
//     dep($resp);exit;
//     if(count($resp)){
//          return $data = json_encode(array('lError' => false, 'data' => $resp));
//     }
//     return $data = json_encode(array('lError' => true));
// });