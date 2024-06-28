<?php
namespace Vokuro\GenericSQL\Common;
use App\Library\Db\SiamtDb as Db;

class Process
{
    public static function getAllProcess()
    {
        $sql = "SELECT 
            iid AS iidproceso,
            iidmodulo,
            txtnombre,
            bactivo AS activo,
            TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
            TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
            FROM comun.tbl_cat_proceso
            WHERE bactivo='t'
        ";
        $processes = Db::fetchAll($sql);
        return $processes;
    }
}