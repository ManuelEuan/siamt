<?php
declare(strict_types=1);
use App\Library\Http\Middlewares\ResponseMiddleware;
use App\Library\Http\Middlewares\SecurityMiddleware;
use Phalcon\Di;
use Phalcon\Mvc\Micro;

define('BASE_PATH', dirname(__DIR__));
define('APP_PATH', BASE_PATH . '/app');
define('ROOT_PATH', realpath(__DIR__."/../"));

try {
    session_start();
    require_once ROOT_PATH.'/vendor/autoload.php';
    include APP_PATH . '/config/loader.php';

    $di = new Di();

    include APP_PATH . '/config/services.php';


    $config = $di->getConfig();

    $app = new Micro($di);
    $app->setEventsManager($app->getSharedService('eventsManager'));

    $responseMiddleware = ResponseMiddleware::register($app);
    date_default_timezone_set('America/Mexico_City');
    include APP_PATH . '/app.php';

    // var_dump($_SERVER['REQUEST_URI']);exit;
    $app->handle($_SERVER['REQUEST_URI']);

}catch(Exception $exception){
    $responseMiddleware->error($app,$exception);
}