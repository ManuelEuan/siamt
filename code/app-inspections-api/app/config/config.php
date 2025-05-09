<?php

return new \Phalcon\Config([
    'database' => [
        'host' => getenv('DB_HOST'),
        'port' => intval(getenv('DB_PORT')),
        'username' => getenv('DB_USER'),
        'password' => getenv('DB_PASS'),
        'dbname' => getenv('DB_DBNAME_INSP'),
        'persistent' => boolval(getenv('DB_PERSISTENT'))
    ],
    'database_siamt' => [
        'host' => getenv('DB_HOST'),
        'port' => intval(getenv('DB_PORT')),
        'username' => getenv('DB_USER'),
        'password' => getenv('DB_PASS'),
        'dbname' => getenv('DB_DBNAME'),
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
        'appInspectionsFilesDir' => getenv('APP_INSPECTIONS_FILES_DIR'),
        'keyDocumentos' => getenv('KEY_DOCUMENTOS')
    ],
    'internetFailtures' => [
        'smtp' => [
            'server' => getenv('INTERNET_FAILTURES_SMTP_SERVER'),
            'port' => intval(getenv('INTERNET_FAILTURES_SMTP_PORT')),
            'security' => boolval(getenv('INTERNET_FAILTURES_SMTP_SECURITY')),
            'username' => getenv('INTERNET_FAILTURES_SMTP_USERNAME'),
            'password' => getenv('INTERNET_FAILTURES_SMTP_PASSWORD')
        ],
        'provider' => [
            'name' => getenv('INTERNET_FAILTURES_PROVIDER_NAME'),
            'email' => getenv('INTERNET_FAILTURES_PROVIDER_EMAIL')
        ],
        'sender' => [
            'name' => getenv('INTERNET_FAILTURES_SENDER_NAME'),
            'email' => getenv('INTERNET_FAILTURES_SENDER_EMAIL')
        ]
    ]
]);
