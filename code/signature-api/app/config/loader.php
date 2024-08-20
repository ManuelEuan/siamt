<?php
$loader = new \Phalcon\Loader();

$loader->registerNamespaces(
    [
        'App\Library'   => BASE_PATH . '/../common-php/',
        'App\Models'    => APP_PATH . '/models/',
        'App\Controllers'    => APP_PATH . '/controllers/'
    ]
)->register();

$loader->registerClasses(
    [
        'Vokuro\GenericSQL\GenericSQL' => BASE_PATH . '/../common-php/GenericSQL/GenericSQL.php',
    ]
)->register();