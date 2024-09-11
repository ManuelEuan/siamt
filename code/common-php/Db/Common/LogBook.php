<?php
namespace Vokuro\GenericSQL\Common;
use App\Library\Db\SiamtDb as Db;
use Exception;
use Phalcon\Mvc\Model;

class LogBook extends Model
{
    public function initialize()
    {
        $this->setConnectionService('db_siamt');
        $this->setSchema("comun");
        $this->setSource("tbl_bitacora");
    }

    /**
     * @param int $idFolio <p>* Identificador del Registro</p>
     * @param int $idUsuario <p>* Identificador del usuario</p>
     * @param string $siglaModulo <p>* Siglas del Módulo</p>
     * @param Model $dataOrigin <p>Modelo con los datos originales antes de actualizar, pueden mandar null si es un registro nuevo</p>
     * @param Model $data <p>* Modelo con los datos a guardar</p>
     * @return bool|true Valor True si el registro se guardó correctamente de lo contrario se regresará un Exception
     */

    public static function saveLoogBook(int $idFolio, int $idUsuario, string $siglaModulo, ?Model $dataOrigin, Model $data)
    {

        if($data != $dataOrigin) {
            $bitacora = new LogBook();
            $bitacora->iidusuario = $idUsuario;
            $bitacora->txtmodulo = $siglaModulo;
            $bitacora->iidentificador = $idFolio;
            $bitacora->txttabla = $data->getSchema() . "." . $data->getSource();
            $bitacora->txtoriginal = $dataOrigin != null ? json_encode($dataOrigin) : $dataOrigin;
            $bitacora->txtcambios = json_encode($data);;

            if (!$bitacora->save()) {
                throw new Exception($bitacora->getMessages()[0]);
            }
        }

        return true;

    }
}