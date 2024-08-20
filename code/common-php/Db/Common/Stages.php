<?php
namespace Vokuro\GenericSQL\Common;
use App\Library\Db\SiamtDb as Db;
use Phalcon\Mvc\Model;

class Stages extends Model
{
    public function initialize()
    {
        $this->setConnectionService('db_siamt');
        $this->setSchema("comun");
        $this->setSource("tbl_cat_etapa");
    }

    public static function getAllStages()
    {
        $sql = "SELECT 
                ce.iid AS iidetapa,
                ce.txtnombre AS txtetapa_nombre,
                ce.txtdescripcion,
                ce.vclave,
                ce.iidproceso,
                tp.txtnombre AS txtproceso_nombre,
                ce.txtcolor,
                ce.bactivo AS activo,
                TO_CHAR(ce.dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
                TO_CHAR(ce.dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion,
                tp.iidmodulo,
                m.nombre AS txtproceso_modulo_nombre,
                m.descripcion AS txtproceso_modulo_descripcion
            FROM 
                comun.tbl_cat_etapa ce
            JOIN 
                comun.tbl_cat_proceso tp ON ce.iidproceso = tp.iid
            JOIN 
                usuario.modulo m ON tp.iidmodulo = m.id
            WHERE 
                ce.bactivo = 't';
        ";
        $stages = Db::fetchAll($sql);
        return $stages;
    }
}