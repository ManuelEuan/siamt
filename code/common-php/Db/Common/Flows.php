<?php
namespace Vokuro\GenericSQL\Common;
use App\Library\Db\SiamtDb as Db;

class Flows
{
    public static function getNextSubStages($proceso, $idSubEtapaActual)
    {
        $sql = "SELECT se.iid, se.iidetapa, se.txtnombre subetapa, e.txtnombre etapa
        FROM comun.tbl_flujo f
        INNER JOIN comun.tbl_cat_subetapa se ON se.iid = f.iidsubetapa_siguiente
        INNER JOIN comun.tbl_cat_etapa e ON e.iid = se.iidetapa
        INNER JOIN comun.tbl_cat_proceso p ON p.iid = e.iidproceso
        INNER JOIN usuario.modulo m ON m.id = p.iidmodulo
        WHERE UPPER(p.txtnombre) ilike '$proceso' AND f.iidsubetapa = $idSubEtapaActual AND f.activo";
        $stages = Db::fetchAll($sql);
        return $stages;
    }
}