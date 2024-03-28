<?php

namespace App\Controllers;

use Phalcon\Registry;
use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Http\Exceptions\ValidatorBoomException;

class TerritoryController extends BaseController
{

    private function hasClientAuthorized($permission)
    {

        $permissions = $this->token->getPermissions()['iin']; // Obtener permisos del token de usuario
        if (!in_array($permission, $permissions)) { // Comprobar si el permiso está presente en los permisos del usuario
            if ($permission === 'veii' && in_array('edii', $permissions)) return; // Permitir acceso si es edpe pero no vepe
            throw new HttpUnauthorizedException(401, 'Permisos insuficientes.'); // Excepción de no autorizado si no se tienen los permisos necesarios
        }
    }

    // Método para depurar y mostrar datos
    public function dep($data)
    {
        $format  = print_r('<pre>');
        $format .= print_r($data);
        $format .= print_r('</pre>');
        return $format;
    }

    public function getAllPostalCodes()
    {
        $sql = "SELECT 
            iidcolonia,
            iclave_colonia,
            txtnombre,
            iidmunicipio,
            icodigo_postal,
            bactivo AS activo,
            TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
            TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
            FROM territorio.cat_colonia
            WHERE bactivo='t' AND iidmunicipio = 50
        ";
        $postalCodes = Db::fetchAll($sql);
        return $postalCodes;
    }

    public function createPerson()
    {
        $this->hasClientAuthorized('crii'); // Verificar si el cliente tiene autorización

        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $this->validRequiredData($data); // Validar datos requeridos
        // var_dump($data);exit;
        Db::begin(); // Iniciar transacción en la base de datos

        $params = array(
            'bfisica' => $data->bfisica,
            'txtnombre' => $data->txtnombre,
            'txtapepat' => $data->txtapepat,
            'txtapemat' => $data->txtapemat,
            'dfecha_nacimiento' => $data->dfecha_nacimiento !== '' ? $data->dfecha_nacimiento : null,
            'txtrfc' => $data->txtrfc,
            'txtcurp' => $data->txtcurp,
            'txtine' => $data->txtine,
            'iidestado_civil' => $data->iidestado_civil,
            'iidsexo' => $data->iidsexo,
            'txtcorreo' => $data->txtcorreo,
            // 'bactivo' => $data->bactivo,
            // 'dtfecha_creacion' => $data->dtfecha_creacion !== '' ? $data->dtfecha_creacion : date("Y/m/d H:i:s"),
            // 'dtfecha_modificacion' => $data->dtfecha_modificacion !== '' ? $data->dtfecha_modificacion : date("Y/m/d H:i:s"),
        );

        $this->insert('tbl_persona', $params);
        Db::commit(); // Confirmar transacción en la base de datos
        return array('message' => 'La persona ha sido creada.'); // Devolver mensaje de éxito
    }

    private function insert($table, $params)
    {
        $cols = implode(', ', array_keys($params)); // Obtener nombres de columnas
        $phs = ':' . str_replace(', ', ', :', $cols); // Obtener marcadores de posición para los valores
        $sql = "INSERT INTO persona.$table ($cols) VALUES ($phs)"; // Consulta de inserción
        // var_dump($sql);exit;
        return Db::execute($sql, $params); // Ejecutar inserción en la base de datos
    }

    // // Método para validar datos requeridos
    private function validRequiredData($data)
    {
        $requiredKeys = array('bfisica', 'txtnombre', 'txtcurp'); // Claves requeridas
        $actualKeys = array_keys(get_object_vars($data)); // Claves presentes en los datos
        $missingKeys = array_diff($requiredKeys, $actualKeys); // Claves faltantes
        $message = 'Faltan valores requeridos.';

        if (!empty($missingKeys)) throw new ValidatorBoomException(422, $message);

        foreach ($data as $key => $value) {
            if (!in_array($key, $requiredKeys)) continue;

            // Validar tipos de valores según la clave
            switch ($key) {
                default:
                    $message = "Tipo de valor incorrecto en $key.";
                    if (!is_string($value)) throw new ValidatorBoomException(422, $message);
                    $message = "Valor vacío en $key.";
                    if (empty(trim($value))) throw new ValidatorBoomException(422, $message);
                    break;
            }
        }
    }
}
