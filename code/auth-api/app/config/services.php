<?php
declare(strict_types=1);

$di->setShared('request', function(){ return new Phalcon\Http\Request(); });
$di->setShared('response', function(){ return new Phalcon\Http\Response(); });
$di->setShared('router', function(){ return new Phalcon\Mvc\Router(); });

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

$di->setShared('redis', function () {
    $config = $this->getConfig();

    $redis = new \App\Library\Misc\Redis();
    if(boolval($config->redis->persistent))
        $redis->pconnect($config->redis->host, $config->redis->port);
    else
        $redis->connect($config->redis->host, $config->redis->port);

    return $redis;
});