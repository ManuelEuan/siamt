<?php
$loader = new \Phalcon\Loader();

$loader->registerNamespaces(
    [
        'App\Library'   => BASE_PATH . '/../common-php/',
        'App\Controllers'    => APP_PATH . '/controllers/',
        'App\Models'    => APP_PATH . '/models/',
        'App\Models\User'    => APP_PATH . '/models/user',
        'App\Models\Territory'    => APP_PATH . '/models/territory',
        'App\Models\Person'    => APP_PATH . '/models/person',
        'App\Models\Layers'    => APP_PATH . '/models/layers',
        'App\Db'        => APP_PATH . '/db/',
    ]
)->register();

$loader->registerClasses(
    [
        'Vokuro\GenericSQL\GenericSQL' => BASE_PATH . '/../common-php/GenericSQL/GenericSQL.php',
        // 'Vokuro\GenericSQL\Person' => BASE_PATH . '/../common-php/Db/Person/DemoModel.php',
        'Vokuro\GenericSQL\Common' => BASE_PATH . '/../common-php/Db/Common/Process.php'
    ]
)->register();