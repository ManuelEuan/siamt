<?php
namespace Vokuro\GenericSQL\Common;
use App\Library\Db\SiamtDb as Db;

class Flows
{
    public static function getNextSubStages($proceso, $idSubEtapaActual)
    {
        $sql = "
        SELECT 
            JSONB_AGG(
                    JSON_BUILD_OBJECT(
                        'idEtapa', iid,
                        'etapa', etapa,
                        'subEtapas', array_to_json(
                                Array(
                                        SELECT JSON_BUILD_OBJECT(
                                                'id', a.iid,
                                                'nombre', a.subetapa
                                        )
                                        FROM (
                                                SELECT DISTINCT se.iid, se.txtnombre subetapa
                                                FROM comun.tbl_flujo f
                                                INNER JOIN comun.tbl_cat_subetapa se ON se.iid = f.iidsubetapa_siguiente AND se.bactivo
                                                INNER JOIN comun.tbl_cat_etapa e ON e.iid = se.iidetapa AND e.bactivo
                                                INNER JOIN comun.tbl_cat_proceso p ON p.iid = e.iidproceso AND p.bactivo
                                                INNER JOIN usuario.modulo m ON m.id = p.iidmodulo AND m.activo
                                                WHERE UPPER(p.vclave) ilike '$proceso' AND f.iidsubetapa = $idSubEtapaActual AND f.bactivo
                                                AND e.iid = b.iid
                                                ORDER BY se.txtnombre
                                        ) a
                                )
                        )
                    )
            ) AS params
        FROM (
            SELECT DISTINCT e.iid, e.txtnombre etapa
            FROM comun.tbl_flujo f
            INNER JOIN comun.tbl_cat_subetapa se ON se.iid = f.iidsubetapa_siguiente AND se.bactivo
            INNER JOIN comun.tbl_cat_etapa e ON e.iid = se.iidetapa AND e.bactivo
            INNER JOIN comun.tbl_cat_proceso p ON p.iid = e.iidproceso AND p.bactivo
            INNER JOIN usuario.modulo m ON m.id = p.iidmodulo AND m.activo
            WHERE UPPER(p.vclave) ilike '$proceso' AND f.iidsubetapa = $idSubEtapaActual AND f.bactivo
            ORDER BY e.txtnombre
        ) b";
        $stages = Db::fetchColumn($sql);

        //$stages = Db::fetchAll($sql);
        return json_decode($stages);
    }
}