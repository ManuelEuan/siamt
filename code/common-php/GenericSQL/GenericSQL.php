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

}