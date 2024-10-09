<?php
namespace Vokuro\GenericSQL\Common;
use Phalcon\Mvc\Model;

class Configuration extends Model
{
    public function initialize()
    {
        $this->setConnectionService('db_siamt');
        $this->setSchema("comun");
        $this->setSource("tbl_configuracion");
    }
}
