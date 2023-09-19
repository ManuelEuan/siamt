<?php
declare(strict_types=1);

use App\Library\Http\Middlewares\ResponseMiddleware;
use Phalcon\Di;
use Phalcon\Mvc\Micro;

define('BASE_PATH', dirname(__DIR__));
define('APP_PATH', BASE_PATH . '/app');

try {
    include APP_PATH . '/config/loader.php';

    $di = new Di();
    include APP_PATH . '/config/services.php';

    $config = $di->getConfig();

    $app = new Micro($di);

    $responseMiddleware = ResponseMiddleware::register($app);

    include APP_PATH . '/app.php';


    $app->handle($_SERVER['REQUEST_URI']);

}catch(Exception $exception){
    $responseMiddleware->error($app,$exception);
}