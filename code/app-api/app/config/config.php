<?php

return new \Phalcon\Config([
    'database' => [
        'host' => getenv('DB_HOST'),
        'port' => intval(getenv('DB_PORT')),
        'username' => getenv('DB_USER'),
        'password' => getenv('DB_PASS'),
        'dbname' => getenv('DB_DBNAME'),
        'persistent' => boolval(getenv('DB_PERSISTENT'))
    ],

    'database_inspections' => [
        'host' => getenv('DB_HOST'),
        'port' => intval(getenv('DB_PORT')),
        'username' => getenv('DB_USER'),
        'password' => getenv('DB_PASS'),
        'dbname' => getenv('DB_DBNAME_INSP'),
        'persistent' => boolval(getenv('DB_PERSISTENT'))
    ],

    'database_mantounidades' => [
        'host' => getenv('DB_HOST'),
        'port' => intval(getenv('DB_PORT')),
        'username' => getenv('DB_USER'),
        'password' => getenv('DB_PASS'),
        'dbname' => getenv('DB_DBNAME_MANTO'),
        'persistent' => boolval(getenv('DB_PERSISTENT'))
    ],

    'redis' => [
        'host' => getenv('RD_HOST'),
        'port' => intval(getenv('RD_PORT')),
        'persistent' => boolval(getenv('RD_PERSISTENT'))
    ],

    'jwt' => [
        'alg' => getenv('JWT_ALG'),
        'duration' => intval(getenv('JWT_DURATION')),
        'secret' => getenv('JWT_SECRET')
    ],

    'app' => [
        'auditQueue' => getenv('RD_AUDIT_QUEUE'),
        'whitelistedApis' => array('GET:/domain/config'),
        'keyDocumentos' => getenv('KEY_DOCUMENTOS')
    ]
]);
