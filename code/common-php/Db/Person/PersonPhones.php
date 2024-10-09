<?php

namespace Vokuro\GenericSQL\Person;

use App\Library\Db\SiamtDb as Db;
use App\Library\Http\Exceptions\ValidatorBoomException;

class PersonPhones
{
    public static function create($data)
    {
        // Desactivar todos los teléfonos actuales antes de insertar el nuevo
        self::deactivateAll($data->iidpersona);

        try {
            $params = [];
            foreach ($data->phone as $key => $value) {
                // $params[$key] = $value;
                switch ($key) {
                    case 'iidtelefono':
                    case 'txtlada':
                        break;
                    case 'bpropio':
                        $params[$key] = $value == 1 ? 't' : 'f';
                        break;
                    case 'btelegram':
                        $params[$key] = $value == 1 ? 't' : 'f';
                        break;
                    case 'bwhatsapp':
                        $params[$key] = $value == 1 ? 't' : 'f';
                        break;
                    default:
                        $params[$key] = $value;
                        break;
                }
            }
            //  'bactual' y 'bactivo' sean siempre true
            $params['bactual'] = 't';
            $params['bactivo'] = 't';
            // Db::dep($params);exit;
            return Db::insert('persona.tbl_persona_telefono', $params);
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
                'bpropio' => $data->bpropio == 1 ? 't' : 'f',
                'btelegram' => $data->btelegram == 1 ? 't' : 'f',
                'bwhatsapp' => $data->bwhatsapp == 1 ? 't' : 'f'
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
                    pt.bactual,
                    pt.bactivo,
                    pt.bpropio,                   
                    pt.btelegram,                   
                    pt.bwhatsapp
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
                    pt.iidpersona = :iidpersona AND pt.bactivo = true
                ORDER BY 
                    pt.bactual DESC, pt.vtelefono
        ";
        $phones = Db::fetchAll($sql, $params);
        return $phones;
    }

    public static function deactivateAll($iidpersona)
    {
        $params = array('iidpersona' => $iidpersona);
        $sql = "SELECT 
                    iidpersona,
                    iidtipo_telefono,
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

    public static function updateCurrentPhone($data)
    {
        $paramsOld = array('iidpersona' => $data->iidpersona);
        $sql = "UPDATE persona.tbl_persona_telefono SET bactual = false WHERE iidpersona = :iidpersona";
        Db::execute($sql, $paramsOld);
        $paramsNew = array('iidpersona' => $data->iidpersona, 'iidtelefono' => $data->selectedPhone);
        $sql = "UPDATE persona.tbl_persona_telefono SET bactual = true WHERE iidpersona = :iidpersona AND iid = :iidtelefono";
        Db::execute($sql, $paramsNew);
    }

    public static function deactivate($data)
    {
        $paramsNew = array('iidpersona' => $data->iidpersona, 'iid' => $data->selectedPhone);
        $sql = "UPDATE persona.tbl_persona_telefono SET bactivo = false WHERE iidpersona = :iidpersona AND iid = :iid";
        Db::execute($sql, $paramsNew);
    }
}
