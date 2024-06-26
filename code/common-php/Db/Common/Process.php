<?php
namespace  Vokuro\GenericSQL;

use Phalcon\Db\Enum;
use Phalcon\Di;

class Process
{
    
    public static function getDemoModel()
    {
        $sql = "SELECT * FROM usuario.modulo";
        $demo = self::getBySQL($sql);
        return $demo;
    }

    public static function getFormAllTypes()
    {
        $sql = "SELECT * FROM usuario.modulo";
        $demo = self::getBySQL($sql);
        return $demo;
    }

    public static function getAllFilteredAndPaginatedInspectors($data)
    {
       
        $sql = "SELECT p.iid,
                    p.bfisica,
                    p.txtapellido_paterno,
                    p.txtapellido_materno,
                    p.nombre_completo,
                    d.txtdireccion AS nombre_inspector
                FROM persona.tbl_persona p
                    JOIN dblink('dbname=inspecciones host=127.0.0.1 port=5432 user=postgres password=root'::text, 
                    'SELECT txtdireccion, iidempleado FROM boleta.tbl_boleta'::text) 
                        d(txtdireccion text, iidempleado integer) 
                    ON p.iid = d.iidempleado";
        return Db::fetchAll($sql);

    }
    
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