<?php

namespace Vokuro\GenericSQL\Person;

use App\Library\Db\SiamtDb as Db;
use App\Library\Http\Exceptions\ValidatorBoomException;

class Phones
{
    public static function create($data)
    {
        try {
            $params = [];
            foreach ($data as $key => $value) {
                // $params[$key] = $value;
                switch ($key) {
                    case 'iidtelefono':
                    case 'iidpersona':
                    case 'txtlada':
                        break;
                    default:
                        $params[$key] = $value;
                        break;
                }
            }

            return Db::insert('persona.tbl_telefono', $params);
        } catch (\Exception $e) {
            throw new ValidatorBoomException(422, 'Error teléfono.'. $e->getMessage());
        }
    }

    public static function update($data)
    {
        try {
            $table = "persona.tbl_telefono";
            // $params = [];
            // foreach ($data as $key => $value) {
            //     $params[$key] = $value;
            // }
            $params = array(
                'vtelefono' => $data->phone->vtelefono,
                'iidtipo_telefono' => $data->phone->iidtipo_telefono,
                'iid' => $data->phone->iidtelefono,
            );
            $where = "iid = :iid";
            Db::update($table, $params, $where);
        } catch (\Exception $e) {
            throw new ValidatorBoomException(422, 'Error teléfono.');
        }
    }
}
