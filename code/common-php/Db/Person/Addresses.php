<?php

namespace Vokuro\GenericSQL\Person;

use App\Library\Db\SiamtDb as Db;

class Addresses
{

    public static function create($data)
    {
        try {
            $params = [];
            $omitKeys = [
                'txtcalle_letra', 'txtnumero_exterior_letra',
                'inumero_interior', 'txtnumero_interior_letra', 'txtcruzamiento_uno',
                'txtcruzamiento_uno_letra', 'txtcruzamiento_dos', 'txtcruzamiento_dos_letra',
                'txtreferencia'
            ];

            foreach ($data as $key => $value) {
                switch ($key) {
                    case 'iidpersona':
                    case 'bactivo':
                    case 'nlatitud':
                    case 'nlongitud':
                    case 'txtavenida_kilometro':
                    case 'txttablaje':
                    case 'dtfecha_creacion':
                    case 'dtfecha_modificacion':
                        break;
                    case 'iidtipo_vialidad':
                        $params[$key] = ($value == 0) ? null : $value;
                        break;
                    case 'iidtipo_direccion':
                        $params[$key] = $value;
                        if (!in_array($value, [/* valores permitidos */])) {
                            // Omitir las claves específicas
                            foreach ($omitKeys as $omitKey) {
                                if (isset($params[$omitKey])) {
                                    unset($params[$omitKey]);
                                }
                            }
                        }
                        break;
                    default:
                        if (!in_array($key, $omitKeys)) {
                            $params[$key] = $value;
                        }
                        break;
                }
            }

            $address =  Db::insert('persona.tbl_direccion', $params);
            return $address;
        } catch (\Exception $e) {
            // Aquí puedes manejar la excepción de acuerdo a tus necesidades
            // Por ejemplo, lanzar una excepción personalizada o registrar el error
            throw new \Exception('Error al crear dirección: ' . $e->getMessage());
        }
    }

    public static function update($data)
    {
        try {
            $table = "persona.tbl_direccion";

            $params = array(
                'txtcalle' => $data->txtcalle,
                'txtcalle_letra' => $data->txtcalle_letra,
                'inumero_exterior' => $data->inumero_exterior !== '' ? $data->inumero_exterior : null,
                'txtnumero_exterior_letra' => $data->txtnumero_exterior_letra,
                'inumero_interior' => $data->inumero_interior !== '' ? $data->inumero_interior : null,
                'txtnumero_interior_letra' => $data->txtnumero_interior_letra,
                'txtcruzamiento_uno' => $data->txtcruzamiento_uno,
                'txtcruzamiento_uno_letra' => $data->txtcruzamiento_uno_letra,
                'txtcruzamiento_dos' => $data->txtcruzamiento_dos,
                'txtcruzamiento_dos_letra' => $data->txtcruzamiento_dos_letra,
                'txtreferencia' => $data->txtreferencia,
                'dtfecha_modificacion' => date('Y-m-d H:i:s'),
                'iidtipo_direccion' => $data->iidtipo_direccion !== '' ? $data->iidtipo_direccion : null,
                'iidtipo_vialidad' => $data->iidtipo_vialidad !== '' ? $data->iidtipo_vialidad : null,
                'iid' => $data->iiddireccion,
            );

            $where = "iid = :iid"; // Condición WHERE para la actualización
            $direccion = Db::update($table, $params, $where);
            return $direccion;
        } catch (\Exception $e) {
            throw new \Exception('Error dirección: ' . $e->getMessage());
        }
    }

    // public static function update($data)
    // {
    //     try {
    //         $table = "persona.tbl_direccion";
    //         $params = [];
    //         Db::dep($data);
    //         foreach ($data as $key => $value) {
    //             switch ($key) {
    //                 case 'iidinspector':
    //                     break;
    //                 default:
    //                     $params[$key] = $value;
    //                     break;
    //             }
    //         }
    //         $where = "iid = :iid";
    //         Db::update($table, $params, $where);
    //     } catch (\Exception $e) {
    //         throw new \Exception('Error dirección: ' . $e->getMessage());
    //     }
    // }
}
