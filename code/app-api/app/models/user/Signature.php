<?php
namespace App\Models\User;

use Phalcon\Mvc\Model;

class Signature extends Model
{
    public function initialize()
    {
        $this->setSchema("usuario");
        $this->setSource("tbl_tbl_firma");
    }

    public function getSequenceName()
    {
        return "inspeccion.tbl_tbl_firma_iid_seq";
    }
   
}
