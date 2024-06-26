<?php

namespace App\Models\Person;

use Phalcon\Mvc\Model;
use App\Library\Db\Db;
// use App\Library\Db\Db;

class Persons extends Model
{
    public function initialize()
    {
        $this->setConnectionService('db_inspecciones');
        // $this->setConnectionService('db_inspecciones');

        $this->setSchema("inspeccion");
        $this->setSource("tbl_inspector");
    }
    public function dep($data)
    {
        $format  = print_r('<pre>');
        $format .= print_r($data);
        $format .= print_r('</pre>');
        return $format;
    }
    public static function getInspector($iidpersona)
    {
        $sql = "SELECT iid AS iidinspector, iidpersona, txtfolio_inspector FROM inspeccion.tbl_inspector WHERE iidpersona=:iidpersona";
        $params = array('iidpersona' => $iidpersona);
        self::dep(Persons::find());exit;
        // return ;
    }
}