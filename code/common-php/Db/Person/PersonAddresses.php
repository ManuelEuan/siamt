<?php

namespace Vokuro\GenericSQL\Person;

use App\Library\Db\SiamtDb as Db;

class PersonAddresses
{
    public static function create($iidpersona, $iiddireccion)
    {
        $params = array('iidpersona' => $iidpersona, 'iiddireccion' => $iiddireccion, 'bactual' => 't');
        Db::insert('persona.tbl_persona_direccion', $params);
    }

    public static function getAll($iid)
    {
        $params = array('iidpersona' => $iid);
        $sql = "SELECT 
            pd.iiddireccion, 
            CONCAT(d.txtdireccion_completa, ', ', ' C.P. ', d.icodigo_postal, ', ', cp.txtmunicipio, ' ', cp.txtestado) AS direccion_completa,
            d.icodigo_postal,
            d.txtcalle,
            d.txtcolonia,
            d.txtcalle_letra,
            d.inumero_exterior,
            d.inumero_interior,
            d.txtnumero_exterior_letra,
            d.txtnumero_interior_letra,
            d.the_geom,
            d.txtcruzamiento_uno,
            d.txtcruzamiento_uno_letra,
            d.txtcruzamiento_dos,
            d.txtcruzamiento_dos_letra,
            d.txtreferencia,
            d.iidtipo_direccion,
            d.iidtipo_vialidad,
            d.txtdescripcion_direccion,
            pd.bactual,
            pd.bactivo                   
        FROM 
            persona.tbl_persona_direccion pd
        JOIN 
            persona.tbl_direccion d ON d.iid = pd.iiddireccion
        JOIN 
            (
                SELECT DISTINCT ON (icp) icp, txtasentamiento, txtmunicipio, txtestado
                FROM territorio.tbl_cp
            ) cp ON d.icodigo_postal = cp.icp
        WHERE 
            pd.bactivo = true 
            AND pd.iidpersona = :iidpersona";

        $addresses = Db::fetchAll($sql, $params);
        return $addresses;
    }








    public static function updateCurrentAddress($data)
    {
        $paramsOld = array('iidpersona' => $data->iidpersona);
        $sql = "UPDATE persona.tbl_persona_direccion SET bactual = false WHERE iidpersona = :iidpersona";
        Db::execute($sql, $paramsOld);
        $paramsNew = array('iidpersona' => $data->iidpersona, 'iiddireccion' => $data->selectedAddress);
        $sql = "UPDATE persona.tbl_persona_direccion SET bactual = true WHERE iidpersona = :iidpersona AND iiddireccion = :iiddireccion";
        Db::execute($sql, $paramsNew);
    }

    public static function delete($iidpersona, $iiddireccion)
    {

        $params = array('iidpersona' => $iidpersona, 'iiddireccion' => $iiddireccion);
        $sql = "UPDATE persona.tbl_persona_direccion SET bactivo = false WHERE iidpersona = :iidpersona AND iiddireccion = :iiddireccion";
        Db::execute($sql, $params);
    }

    public static function deactivateAll($iidpersona)
    {
        $paramsVerifyCurrently = array('iidpersona' => $iidpersona);
        $sql = "SELECT 
                    iidpersona,
                    iiddireccion,
                    bactual,
                    bactivo AS activo,
                    TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
                    TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
                FROM 
                    persona.tbl_persona_direccion
                WHERE 
                    bactivo='t' AND bactual='t' AND iidpersona = :iidpersona";


        $existsCurrently = Db::fetchAll($sql, $paramsVerifyCurrently);
        if ($existsCurrently) {
            $sql = "UPDATE persona.tbl_persona_direccion SET bactual = false WHERE iidpersona = :iidpersona";
            Db::execute($sql, $paramsVerifyCurrently);
        }
    }
}
