<?php
namespace Vokuro\GenericSQL\Common;
use App\Library\Db\SiamtDb as Db;

class Flows
{
    public static function getNextSubStages($proceso, $idEtapaActual)
    {
        $sql = "SELECT e.*
        FROM comun.flujo f
        INNER JOIN comun.etapa e ON e.id = f.idetapa_siguiente
        INNER JOIN comun.proceso p ON p.id = e.idproceso
        INNER JOIN usuario.modulo m ON m.id = p.idmodulo
        WHERE UPPER(p.nombre) ilike '$proceso' AND f.idetapa = $idEtapaActual";
        $stages = Db::fetchAll($sql);
        return $stages;
    }
}