<?php
$loader = new \Phalcon\Loader();

$loader->registerNamespaces(
    [
        'App\Library'   => BASE_PATH . '/../common-php/',
        'App\Controllers'    => APP_PATH . '/controllers/',
        'App\Models'    => APP_PATH . '/models/',
        'Vokuro\GenericSQL' => BASE_PATH . '/../common-php/Db',
    ]
)->register();

$loader->registerClasses(
    [
        'Vokuro\GenericSQL\GenericSQL' => BASE_PATH . '/../common-php/GenericSQL/GenericSQL.php',
    ]
)->register();