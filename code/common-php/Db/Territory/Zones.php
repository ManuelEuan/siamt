<?php
namespace Vokuro\GenericSQL\Territory;
use App\Library\Db\SiamtDb as Db;

class Zones
{
    public static function getAll()
    {
        $sql = "SELECT * FROM territorio.tbl_cat_zona";
        $demo = Db::fetchAll($sql);
        return $demo;
    }
}