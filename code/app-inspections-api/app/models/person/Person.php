<?php

namespace App\Models\Inspection;

use Phalcon\Mvc\Model;
use App\Library\Db\Db;

class Inspectors extends Model
{
    public function initialize()
    {
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
    public static function getAllFilteredAndPaginatedPersons($data)
    {
}