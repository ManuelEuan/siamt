<?php
namespace Vokuro\GenericSQL\Common;
use App\Library\Db\SiamtDb as Db;
use Exception;
use Phalcon\Mvc\Model;

class Tracing extends Model
{
    public function initialize()
    {
        $this->setSchema("comun");
        $this->setSource("tbl_seguimiento");
    }

    public function save($idFolio, $idSubEtapa, $motivo)
    {

        $dataSubEtapa = SubStages::findFirstById($idSubEtapa);
        if(!$dataSubEtapa)
            throw new Exception('No existe la SubEtapa');

        $dataEtapa = Stages::findFirstById($dataSubEtapa->iidetapa);
        if(!$dataEtapa)
            throw new Exception('No existe la Etapa');

        $token = $this->di->getShared('token');
        $idUsuario = $token->getUserId();

        $estatus = new Tracing();
        $estatus->idfolio = $idFolio;
        $estatus->idusuarioautorizo = $idUsuario;
        $estatus->idproceso = $dataEtapa->iidproceso;
        $estatus->idetapa = $dataEtapa->iid;
        $estatus->idsubetapa = $dataSubEtapa->iid;
        $estatus->motivo = $motivo;
        $estatus->activo = true;

        if(!$estatus->save()){
            throw new Exception($estatus->getMessages()[0]);
        }

        return true;

    }
}