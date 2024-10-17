<?php
namespace Vokuro\GenericSQL\Common;
use Phalcon\Mvc\Model;

class NonWorkingDay extends Model
{
    public function initialize()
    {
        $this->setConnectionService('db_siamt');
        $this->setSchema("comun");
        $this->setSource("tbl_dia_inhabil");
    }
}
