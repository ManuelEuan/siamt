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
                CONCAT(
                    CASE
                        WHEN d.iidtipo_direccion = 1 THEN
                            CONCAT(
                                CASE
                                    WHEN d.iidtipo_vialidad = 1 THEN
                                        CASE
                                            WHEN d.txtcalle_letra <> '' THEN CONCAT('Calle ', d.txtcalle, ' ', d.txtcalle_letra)
                                            ELSE d.txtcalle
                                        END
                                    WHEN d.iidtipo_vialidad = 2 THEN CONCAT('AVENIDA O KM ', d.txtcalle)
                                    ELSE ''
                                END,
                                CASE
                                    WHEN d.inumero_exterior IS NOT NULL THEN CONCAT(' #', d.inumero_exterior)
                                    ELSE ''
                                END,
                                CASE
                                    WHEN d.txtcruzamiento_uno <> '' THEN CONCAT(' POR ', d.txtcruzamiento_uno)
                                    ELSE ''
                                END,
                                CASE
                                    WHEN d.txtcruzamiento_uno_letra <> '' THEN CONCAT(' ', d.txtcruzamiento_uno_letra)
                                    ELSE ''
                                END,
                                CASE
                                    WHEN d.txtcruzamiento_dos <> '' THEN CONCAT(' Y ', d.txtcruzamiento_dos)
                                    ELSE ''
                                END,
                                CASE
                                    WHEN d.txtcruzamiento_dos_letra <> '' THEN CONCAT(' ', d.txtcruzamiento_dos_letra)
                                    ELSE ''
                                END,
                                ' C.P. ', d.icodigo_postal,
                                ' Colonia. ', cp.txtasentamiento,
                                ', ', cp.txtmunicipio,
                                ' ', cp.txtestado
                            )
                        WHEN d.iidtipo_direccion = 2 THEN
                            CONCAT('Tablaje ', d.txtcalle,
                                CASE
                                    WHEN d.inumero_exterior IS NOT NULL THEN CONCAT(' #', d.inumero_exterior)
                                    ELSE ''
                                END,
                                 ' C.P. ', d.icodigo_postal,
                                ' Colonia. ', cp.txtasentamiento,
                                ', ', cp.txtmunicipio,
                                ' ', cp.txtestado
                            )
                        WHEN d.iidtipo_direccion = 3 THEN
                            CONCAT('Dirección conocida ', d.txtcalle,
                                CASE
                                    WHEN d.inumero_exterior IS NOT NULL THEN CONCAT(' #', d.inumero_exterior)
                                    ELSE ''
                                END,
                                 ' C.P. ', d.icodigo_postal,
                                ' Colonia. ', cp.txtasentamiento,
                                ', ', cp.txtmunicipio,
                                ' ', cp.txtestado
                            )
                        ELSE '' -- Manejo de otro tipo de dirección, si es necesario
                    END
                ) AS direccion_completa,
                d.icodigo_postal,
                d.iidcolonia,
                d.txtcalle,
                d.txtcalle_letra,
                d.inumero_exterior,
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
                territorio.tbl_cp cp ON d.iidcolonia = cp.iid
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

        $params = array('iidpersona' => $iidpersona,'iiddireccion' => $iiddireccion);
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
