<?php
namespace Vokuro\GenericSQL\Common;
use App\Library\Db\SiamtDb as Db;

class SubStages
{
    public static function getAll()
    {

        $sql = "SELECT iid AS iidsubetapa, txtnombre FROM comun.tbl_cat_subetapa WHERE bactivo='t'";
        $subStages = Db::fetchAll($sql);
        return $subStages;
    }

    public static function get($iidSubStage, $markers = [])
    {
        $sql = "SELECT 
                    s.iid AS iidsubetapa,
                    s.txtnombre AS subetapa_nombre,
                    s.vclave,
                    s.txtdescripcion,
                    s.txtcolor,
                    s.txtpermiso,
                    s.binicial,
                    s.bfinal,
                    s.bcancelacion,
                    s.brequiere_motivo,
                    s.iidetapa,
                    e.iidproceso,
                    e.txtnombre AS etapa_nombre
                FROM 
                    comun.tbl_cat_subetapa s
                JOIN 
                    comun.tbl_cat_etapa e ON s.iidetapa = e.iid
                WHERE 
                    s.bactivo = 't' AND s.iid = :iidsubetapa
        ";
        $params = array('iidsubetapa' => $iidSubStage);
        $subStage = Db::fetch($sql, $params);

        if ($markers) {
            if (in_array($subStage->iidsubetapa, $markers['checkSubStages']) && $subStage->iidsubetapa != $markers['checkCurrentSubStage']) {
                $subStage->textIcon = 'subStage - Encontrado en flujo' . $subStage->iidsubetapa;
                $subStage->icon = 'mdi-checkbox-blank-circle';
            } elseif ($subStage->iidsubetapa == $markers['checkCurrentSubStage']) {
                $subStage->textIcon = 'subStage - Encontrado en flujo actual' . $subStage->iidsubetapa;
                $subStage->icon = 'mdi-check-circle';
            } else {
                $subStage->textIcon = 'subStage - No encontrado en flujo' . $subStage->iidsubetapa;
                $subStage->icon = 'mdi-checkbox-blank-circle-outline';
            }
        }
        return $subStage;
    }

}