<?php

namespace Vokuro\GenericSQL\Person;

use App\Library\Db\SiamtDb as Db;

class Addresses
{

    public static function create($data)
    {
        try {
            $params = [];
            // Db::dep($data);exit;
            foreach ($data as $key => $value) {
                switch ($key) {
                    case 'iidpersona':
                    case 'bactivo':
                    case 'iidcolonia':
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
                    default:
                        $params[$key] = $value;
                        break;
                }
                // $params[$key] = $value;
            }
            $address =  Db::insert('persona.tbl_direccion', $params);
            return $address;
        } catch (\Exception $e) {
            // Aquí puedes manejar la excepción de acuerdo a tus necesidades
            // Por ejemplo, lanzar una excepción personalizada o registrar el error
            throw new \Exception('Error al crear dirección: ' . $e->getMessage());
        }
    }

    public static function update($data){
        $table = "persona.tbl_direccion";
        $params = array(
            'iidcolonia'  => $data->iidcolonia,
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
            'nlatitud' => $data->nlatitud !== '' ? $data->nlatitud : null,
            'nlongitud' => $data->nlongitud !== '' ? $data->nlongitud : null,
            'dtfecha_modificacion' => date('Y-m-d H:i:s'),
            'iidtipo_direccion' => $data->iidtipo_direccion !== '' ? $data->iidtipo_direccion : null,
            'iidtipo_vialidad' => $data->iidtipo_vialidad !== '' ? $data->iidtipo_vialidad : null,
            'txtavenida_kilometro' => $data->txtavenida_kilometro,
            'txttablaje' => $data->txttablaje,
            'txtdescripcion_direccion' => $data->txtdescripcion_direccion,
            'iid' => $data->iiddireccion,
        );
        $where = "iid = :iid"; // Condición WHERE para la actualización
        $direccion = Db::update($table, $params, $where);
        return $direccion;
    }

    function dep($data)
    {
        $format  = print_r('<pre>');
        $format .= print_r($data);
        $format .= print_r('</pre>');
        return $format;
    }

}
