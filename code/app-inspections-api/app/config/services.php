<?php
declare(strict_types=1);

use App\Library\Http\Middlewares\SecurityMiddleware;

$di->setShared('request', function(){ return new Phalcon\Http\Request(); });
$di->setShared('response', function(){ return new Phalcon\Http\Response(); });
$di->setShared('modelsManager', function(){ return new Phalcon\Mvc\Model\Manager(); });
$di->setShared('modelsMetadata', function(){ return new Phalcon\Mvc\Model\MetaData\Memory(); });
$di->setShared('router', function(){ return new Phalcon\Mvc\Router(); });
$di->setShared('filter', function(){ return (new Phalcon\Filter\FilterFactory())->newInstance(); });

$di->setShared('eventsManager', function(){
    $config = $this->getConfig();

    $eventsManager = new Phalcon\Events\Manager();

    $securityMiddleware = new SecurityMiddleware($config->jwt->alg, $config->jwt->secret, $config->app->whitelistedApis->toArray());

    $eventsManager->attach('micro', $securityMiddleware);

    return $eventsManager;
});

$di->setShared('config', function () { return include APP_PATH . '/config/config.php'; });

$di->setShared('db', function () {
    $config = $this->getConfig();

    $params = [
        'host' => $config->database->host,
        'port' => $config->database->port,
        'username' => $config->database->username,
        'password' => $config->database->password,
        'dbname' => $config->database->dbname,
        'options' => [\PDO::ATTR_PERSISTENT => intval($config->database->persistent)]
    ];

    return new Phalcon\Db\Adapter\Pdo\Postgresql($params);
});

$di->setShared('db_siamt', function () {
    $config = $this->getConfig();

    $params = [
        'host' => $config->database_siamt->host,
        'port' => $config->database_siamt->port,
        'username' => $config->database_siamt->username,
        'password' => $config->database_siamt->password,
        'dbname' => $config->database_siamt->dbname,
        'options' => [\PDO::ATTR_PERSISTENT => intval($config->database_siamt->persistent)]
    ];
    return new Phalcon\Db\Adapter\Pdo\Postgresql($params);
});

$di->setShared('redis', function () {
    $config = $this->getConfig();

    $redis = new \App\Library\Misc\Redis();
    if(boolval($config->redis->persistent))
        $redis->pconnect($config->redis->host, $config->redis->port);
    else
        $redis->connect($config->redis->host, $config->redis->port);

    return $redis;
});