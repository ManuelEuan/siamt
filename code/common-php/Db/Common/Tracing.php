<?php
namespace Vokuro\GenericSQL\Common;
use App\Library\Db\SiamtDb as Db;
use Exception;
use Phalcon\Mvc\Model;

class Tracing extends Model
{
    public function initialize()
    {
        $this->setConnectionService('db_siamt');
        $this->setSchema("comun");
        $this->setSource("tbl_seguimiento");
    }

    public static function saveSeguimiento($idFolio, $idUsuario, $idSubEtapa, $motivo)
    {

        $dataSubEtapa = SubStages::findFirstByIid($idSubEtapa);
        if(!$dataSubEtapa)
            throw new Exception('No existe la SubEtapa');

        $dataEtapa = Stages::findFirstByIid($dataSubEtapa->iidetapa);
        if(!$dataEtapa)
            throw new Exception('No existe la Etapa');

        $estatus = new Tracing();
        $estatus->iidfolio = $idFolio;
        $estatus->iidusuarioautorizo = $idUsuario;
        $estatus->iidproceso = $dataEtapa->iidproceso;
        $estatus->iidetapa = $dataEtapa->iid;
        $estatus->iidsubetapa = $dataSubEtapa->iid;
        $estatus->txtmotivo = $motivo;
        $estatus->bactivo = true;

        if(!$estatus->save()){
            throw new Exception($estatus->getMessages()[0]);
        }

        return true;

    }
}