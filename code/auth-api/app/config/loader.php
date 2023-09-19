<?php
$loader = new \Phalcon\Loader();

$loader->registerNamespaces(
    [
        'App\Library'   => BASE_PATH . '/../common-php/',
        'App\Models'    => APP_PATH . '/models/',
        'App\Db'        => APP_PATH . '/db/',
    ]
)->register();