<?php

namespace Vokuro\GenericSQL\Person;
use App\Library\Db\SiamtDb as Db;
use App\Library\Http\Exceptions\ValidatorBoomException;

class PersonPhones
{
    public static function create($iidpersona, $iidtipo_telefono, $vtelefono){

        try{
            $paramsPersonAddress = [
                'iidpersona' => $iidpersona, 
                'iidtipo_telefono' => $iidtipo_telefono, 
                'vtelefono' => $vtelefono
            ];
            return Db::insert('persona.tbl_persona_telefono', $paramsPersonAddress);
        } catch (\Exception $e) {
            throw new ValidatorBoomException(422, 'Error teléfono.' . $e->getMessage());
        }
    }

    public static function update($data)
    {

        try {
            $table = "persona.tbl_persona_telefono";
            // $params = [];
            // foreach ($data as $key => $value) {
            //     $params[$key] = $value;
            // }
            $params = array(
                'vtelefono' => $data->vtelefono,
                'iidpersona' => $data->iidpersona,
                'iidtipo_telefono' => $data->iidtipo_telefono,
                'iid' => $data->iidpersona_telefono,
            );
            $where = "iid = :iid";
            Db::update($table, $params, $where);
        } catch (\Exception $e) {
            throw new ValidatorBoomException(422, 'Error teléfono.');
        }
    }

    public static function getAllPhonesByIdPerson($iidpersona)
    {
        $params = array('iidpersona' => $iidpersona);
        $sql = "SELECT
                    pt.iid AS iidpersona_telefono,
                    pt.iidpersona,
                    tt.txtnombre AS txttelefono_tipo, 
                    tt.txtdescripcion,
                    -- t.txtlada, 
                 
                    CONCAT('(', SUBSTRING(CAST(pt.vtelefono AS VARCHAR), 1, 3), ') ',
                        SUBSTRING(CAST(pt.vtelefono AS VARCHAR), 4, 3), '-',
                        SUBSTRING(CAST(pt.vtelefono AS VARCHAR), 7, 4)) AS vtelefono_mask,
                    pt.vtelefono, 
                    pt.iid AS iidtelefono, 
                    pt.iidtipo_telefono, 	
                    pt.bactual
                    -- pt.bactivo,
                    -- t.bactivo AS telefono_activo, 
                    -- pt.bactivo AS persona_telefono_activo, 
                    -- pt.dtfecha_creacion, 
                    -- pt.dtfecha_modificacion
                FROM
                    persona.tbl_persona_telefono AS pt
                -- INNER JOIN
                --     persona.tbl_telefono AS t ON pt.iidtelefono = t.iid
                INNER JOIN
                    persona.tbl_persona AS p ON pt.iidpersona = p.iid
                INNER JOIN
                    persona.tbl_cat_tipo_telefono AS tt ON pt.iidtipo_telefono = tt.iid
                WHERE 
                    pt.iidpersona = :iidpersona 
                    -- AND pt.bactivo = true
        ";
        $phones = Db::fetchAll($sql, $params);
        return $phones;
    }

    public static function deactivateAll($iidpersona){
        $params = array('iidpersona' => $iidpersona);
        $sql = "SELECT 
                    iidpersona,
                    iidtelefono,
                    bactual,
                    bactivo AS activo,
                    TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
                    TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
                FROM 
                    persona.tbl_persona_telefono
                WHERE 
                    bactivo='t' AND bactual='t' AND iidpersona = :iidpersona";

        $existsCurrently = Db::fetchAll($sql, $params);
        if ($existsCurrently) {
            $sql = "UPDATE persona.tbl_persona_telefono SET bactual = false WHERE iidpersona = :iidpersona";
            Db::execute($sql, $params);
        }
    }

    public static function updateCurrentPhone($data){
        $paramsOld = array('iidpersona' => $data->iidpersona);
        $sql = "UPDATE persona.tbl_persona_telefono SET bactual = false WHERE iidpersona = :iidpersona";
        Db::execute($sql, $paramsOld);
        $paramsNew = array('iidpersona' => $data->iidpersona, 'iidtelefono' => $data->selectedPhone);
        $sql = "UPDATE persona.tbl_persona_telefono SET bactual = true WHERE iidpersona = :iidpersona AND iidtelefono = :iidtelefono";
        Db::execute($sql, $paramsNew);
    }

    public static function deactivate($data){
        $paramsNew = array('iidpersona' => $data->iidpersona, 'iidtelefono' => $data->selectedPhone);
        $sql = "UPDATE persona.tbl_persona_telefono SET bactivo = false WHERE iidpersona = :iidpersona AND iidtelefono = :iidtelefono";
        Db::execute($sql, $paramsNew);
    }
    
}
