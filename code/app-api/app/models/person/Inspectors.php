<?php

namespace App\Models\Person;

use Phalcon\Mvc\Model;
// use App\Library\Db\Db;
// use App\Library\Db\Db;
use Vokuro\GenericSQL\GenericSQL;
use App\Library\Db\InspectionsDb as Db;


class Inspectors extends Model

{
    public function initialize()
    {
        $this->setConnectionService('db_inspecciones');
        // $this->setConnectionService('db_inspecciones');

        $this->setSchema("inspeccion");
        $this->setSource("tbl_inspector");
    }
    public function dep($data)
    {
        $format  = print_r('<pre>');
        $format .= print_r($data);
        $format .= print_r('</pre>');
        return $format;
    }
    public static function getInspector($iidpersona)
    {
        $sql = "SELECT iid AS iidinspector, iidpersona, txtfolio_inspector FROM inspeccion.tbl_inspector WHERE iidpersona=:iidpersona";
        $params = array('iidpersona' => $iidpersona);
        $inspector = Db::fetchOne($sql, $params);
        return $inspector;
    }

    public static function getFlowInspector($idOfSearch)
    {
        $stringConnectionSiamt = GenericSQL::getStringConnectionDbLink('db_siamt');

        // GENERACIÓN DINAMICA DE SQL
        $sql = "SELECT 
                    insp.iid AS iidinspector_seguimiento,
                    insp.iidinspector,
                    insp.iidetapa_anterior,
                    insp.iidsubetapa_anterior,
                    insp.iidetapa_actual,
                    insp.iidsubetapa_actual,
                    etapa_anterior.nombre_etapa_anterior,
                    subetapa_anterior.nombre_subetapa_anterior,
                    etapa_actual.nombre_etapa_actual,
                    subetapa_actual.nombre_subetapa_actual
                FROM 
                    inspeccion.tbl_inspector_seguimiento AS insp
                JOIN 
                    dblink('$stringConnectionSiamt'::text, 'SELECT iid, txtnombre FROM comun.tbl_cat_etapa') 
                    AS etapa_anterior(iid integer, nombre_etapa_anterior text)
                    ON insp.iidetapa_anterior::int = etapa_anterior.iid
                JOIN 
                    dblink('$stringConnectionSiamt'::text, 'SELECT iid, txtnombre FROM comun.tbl_cat_etapa') 
                    AS etapa_actual(iid integer, nombre_etapa_actual text)
                    ON insp.iidetapa_actual::int = etapa_actual.iid
                JOIN 
                    dblink('$stringConnectionSiamt'::text, 'SELECT iid, txtnombre FROM comun.tbl_cat_subetapa') 
                    AS subetapa_anterior(iid integer, nombre_subetapa_anterior text)
                    ON insp.iidsubetapa_anterior::int = subetapa_anterior.iid
                JOIN 
                    dblink('$stringConnectionSiamt'::text, 'SELECT iid, txtnombre FROM comun.tbl_cat_subetapa') 
                    AS subetapa_actual(iid integer, nombre_subetapa_actual text)
                    ON insp.iidsubetapa_actual::int = subetapa_actual.iid
                WHERE 
                    insp.iidinspector = :idOfSearch
                    AND insp.bactivo = 't';
        ";
        $params = array('idOfSearch' => $idOfSearch); // Parámetros para la consulta
        $foundRequest = Db::fetchAll($sql, $params);

        $onlyStages = [];
        $onlySubStages = [];
        foreach ($foundRequest as $key => $found) {
            array_push($onlyStages, $found->iidetapa_actual);
            array_push($onlySubStages, $found->iidsubetapa_actual);
        }
        $foundRequest['onlyStages'] = $onlyStages;
        $foundRequest['onlySubStages'] = $onlySubStages;
        $foundRequest['hasBoleta'] = self::getTicketsByPersonInspector($idOfSearch);
        return $foundRequest;
    }

    public static function getTicketsByPersonInspector($idOfSearch)
    {
        // Retorno iidpersona del inspector
        $sqlpersona = "SELECT iidpersona FROM inspeccion.tbl_inspector WHERE iid = $idOfSearch";
        $res = Db::fetchAll($sqlpersona);
        $iidpersona = $res[0]->iidpersona;

        $stringConnectionSiamt = GenericSQL::getStringConnectionDbLink('db_siamt');
        // Retorno del boletas generadas por el iidpersona del inspector
        $sqlBoleta = "SELECT
                        b.iid AS iidboleta,
                        b.dtfecha_hora_infraccion,
                        b.txtlugar_infraccion,
                        b.txtdireccion,
                        b.imonto_total,
                        -- CONCAT(p_inf.txtnombre, ' ', p_inf.txtapellido_paterno, CASE WHEN p_inf.txtapellido_materno <> '' THEN ' ' || p_inf.txtapellido_materno ELSE '' END) AS nombre_infractor,
                        -- CONCAT(p_emp.txtnombre, ' ', p_emp.txtapellido_paterno, CASE WHEN p_emp.txtapellido_materno <> '' THEN ' ' || p_emp.txtapellido_materno ELSE '' END) AS nombre_empleado,
                        p_inf.nombre_completo AS nombre_infractor,
                        p_emp.nombre_completo AS nombre_empleado,
                        br.txtnombre AS nombre_rol,
                        b.txtlicencia,
                        b.txtunidad,
                        b.tarjeta_circulacion_id,
                        b.txtreporte_especial_id,
                        b.txtinspeccion_fisica,
                        b.bretencion_vehiculo,
                        b.bretencion_documento,
                        b.txtobservaciones,
                        b.bapercibimiento,
                        b.dapercibimiento_fecha,
                        b.dfecha_limite_comparecencia,
                        b.dfecha_limite_resolucion,
                        b.dfecha_limite_notificacion,
                        b.bno_ha_lugar,
                        b.bsuspension,
                        b.isuspension_dias,
                        b.dsuspension_fecha,
                        b.bactivo,
                        b.dtfecha_creacion,
                        b.dtfecha_modificacion
                    FROM
                        boleta.tbl_boleta b
                    INNER JOIN dblink('$stringConnectionSiamt'::text, 'SELECT iid, nombre_completo FROM persona.tbl_persona') 
                            AS p_inf(iid integer, nombre_completo text)
                            ON b.iidinfractor = p_inf.iid
                    INNER JOIN dblink('$stringConnectionSiamt'::text, 'SELECT iid, nombre_completo FROM persona.tbl_persona') 
                            AS p_emp(iid integer, nombre_completo text)
                            ON b.iidempleado = p_emp.iid
                    INNER JOIN
                        boleta.tbl_boleta_rol br ON b.iidboleta_rol_id = br.iid
                    WHERE 
                        p_emp.iid = $iidpersona
                        AND b.bactivo = 't';"
        ;

        return Db::fetchAll($sqlBoleta);
    }
}
