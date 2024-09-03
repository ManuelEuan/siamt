<?php
namespace  Vokuro\GenericSQL;

use Phalcon\Db\Enum;
use Phalcon\Di;

class GenericSQL
{

    public static function fetch(string $sql, ?array $params = null)
    {
        return self::commonFetch($sql,$params);
    }

    private static function commonFetch(string $sql, ?array $params = null)
    {
        $db = self::getDb();
        $pdo = $db->query($sql, $params);
        $pdo->setFetchMode(Enum::FETCH_CLASS, \stdClass::class);
        return $pdo->fetch();
    }
    private static function getDb()
    {
        $di = Di::getDefault();
        return $di->getShared("db");
    }

    public static function getBySQL($sql)
    {
        $connection = self::getDb();
        $resp = $connection->fetchAll(
            $sql,
            Enum::FETCH_OBJ
        );
        return $resp;
    }
    
    public static function getBySQL2($sql)
    {
        $connection = self::getDb();
        $resp = $connection->fetchAll(
            $sql,
            Enum::FETCH_ASSOC
        );
        return $resp;
    }
    public function dep($data)
    {
        $format  = print_r('<pre>');
        $format .= print_r($data);
        $format .= print_r('</pre>');
        return $format;
    }

    public static function getStringConnectionDbLink($db = null)
    {
     
        if($db == 'db_siamt'){
            $host = getenv('DB_HOST');
            $port = intval(getenv('DB_PORT'));
            $username = getenv('DB_USER');
            $password = getenv('DB_PASS');
            $dbname = getenv('DB_DBNAME');
        }
        if($db == 'db_inspecciones'){
            $host = getenv('DB_HOST');
            $port = intval(getenv('DB_PORT'));
            $username = getenv('DB_USER');
            $password = getenv('DB_PASS');
            $dbname = getenv('DB_DBNAME_INSP');
            }
        $connection = "dbname=$dbname host=$host port=$port user=$username password=$password";
        return $connection;
    }
}