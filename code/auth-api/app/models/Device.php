<?php
namespace App\Models;

use Phalcon\Mvc\Model;
use Phalcon\Mvc\Model\Resultset\Simple as Resultset;
class Device extends Model
{

    public function initialize()
    {
        $this->setSource('dispositivo');
        $this->setSchema('usuario');
    }

    public static function get($id, $aplicacion){
        $app = Application::findFirst("txtllave = '$aplicacion' and bactivo = true");
        if($app != false){
            if(!$app->bvalida_dispositivo){
                $o = new \stdClass();
                $o->bpermitido = true;
                $o->dtfecha_modificacion = date('c');
                return $o;
            }

            $sql = "select d.* from usuario.dispositivo d left join usuario.aplicacion a on(d.txtaplicacion=a.txtllave) where d.txtid = '$id' and a.txtllave = '$aplicacion'";
            $device = new Device();

            $a = $device->getReadConnection()->query($sql);

            if($a->numRows() == 0){
                $d = new Device();
                $d->txtid = $id;
                $d->txtaplicacion = $aplicacion;
                $d->save();
                $d->refresh();

                return $d;
            }else{
                $rs = new Resultset(null,$device, $a);
                return $rs->getFirst();
            }
        }else{
            $o = new \stdClass();
            $o->bpermitido = false;
            $o->dtfecha_modificacion = date('c');
            return $o;
        }
    }

    public function jsonSerialize() : array {
        return [ "permitido" => $this->permitido,
            "fechaModificacion" => $this->fecha_modificacion];
    }
}
