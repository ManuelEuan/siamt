<?php
namespace Vokuro\GenericSQL\Territory;
use App\Library\Db\SiamtDb as Db;

class Zones
{
    public static function getDemoModel()
    {
        $sql = "SELECT * FROM comun.tbl_flujo";
        $demo = Db::fetchAll($sql);
        return $demo;
    }
}