<?php

namespace App\Controllers;

use Phalcon\Registry;
use Vokuro\GenericSQL\GenericSQL;
use App\Library\Misc\Utils;
use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Http\Exceptions\ValidatorBoomException;

// MODELO EMPRESAS
use App\Models\Person\Companies;


class CompaniesController extends BaseController
{
        private function hasClientAuthorized($permission)
        {
            $permissions = $this->token->getPermissions()['iie']; // Obtener permisos del token de usuario
            if (!in_array($permission, $permissions)) { // Comprobar si el permiso está presente en los permisos del usuario
                if ($permission === 'veie' && in_array('edie', $permissions)) return; // Permitir acceso si es edpe pero no vepe
                throw new HttpUnauthorizedException(401, 'Permisos insuficientes.'); // Excepción de no autorizado si no se tienen los permisos necesarios
            }
        }
     
        // Obtener empresas
        public function getCompanies()
        {
            $data =  $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
            return Companies::getAllFilteredAndPaginatedCompanies($data);
        }
    
    
        public function getAllShiftsCompany()
        {
            return Shifts::getAllShifts();
        }
        // Obtener información de una empresa
        public function getCompanyInfo()
        {
            $this->hasClientAuthorized('veie'); // Verificar si el cliente tiene autorización
            $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
            return Companies::getCompanyInfo($data->id);
        }
    
        // // Método para crear una empresa
        public function createCompany()
        {
            $this->hasClientAuthorized('crie'); // Verificar si el cliente tiene autorización
    
            $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
            $this->validRequiredData($data, 'createCompany'); // Validar datos requeridos
            Db::begin(); // Iniciar transacción en la base de datos
    
            $params = array(
                'iidpersona'  => $data->iidpersona,
                'vnomenclatura'  => $data->vnomenclatura

            );
    
            $iidempresa = $this->insert('tbl_empresa', $params, true);
            $vnomenclatura = $this->insert('tbl_empresa', $params, true);
            
            $params = array(
                'iidempresa' => $iidempresa,
                'vnomenclatura' => $vnomenclatura
            );
    
            Db::commit(); // Confirmar transacción en la base de datos
            return array('message' => 'La empresa ha sido creado.'); // Devolver mensaje de éxito
        }
    
    
        // // Método para actualizar una empresa
        public function updateCompany()
        {
            $this->hasClientAuthorized('edie'); // Verificar si el cliente tiene autorización
            $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
            $this->validRequiredData($data, 'updateCompany'); // Validar datos requeridos
            Db::begin(); // Iniciar transacción en la base de datos
    
            // Actualización de empresa
            $sql = 'UPDATE transporte.tbl_empresa SET 
                    vnomenclatura=:vnomenclatura,
                    bactivo=:bactivo,
                    dtfecha_modificacion=:dtfecha_modificacion
                WHERE iid=:iidempresa
            ';
            $params = array(
                'vnomenclatura'=> $data->vnomenclatura,
                'bactivo' => $data->activo ? 't' : 'f',
                'dtfecha_modificacion' => date('Y-m-d H:i:s'), // Formato de fecha correcto
                'iidempresa'=> $data->iidempresa,
            ); // Parámetros para la actualización del empresa
    
            Db::execute($sql, $params); // Ejecutar actualización del empresa en la base de datos
            Db::commit(); // Confirmar transacción en la base de datos
    
            return array('message' => 'La empresa ha sido actualizado.'); // Devolver mensaje de éxito
        }
    
        // // Método para eliminar un empresa
        public function deleteCompany($iidempresa)
        {
            $this->hasClientAuthorized('boie'); // Verificar si el cliente tiene autorización
    
            $sql = "SELECT bactivo FROM transporte.tbl_empresa WHERE iidempresa=:iidempresa"; // Consulta para obtener estado activo del inspector
            $params = array('iidempresa' => $iidempresa); // Parámetros para la consulta
            $bactivo = Db::fetchColumn($sql, $params); // Obtener estado activo del empresa
            $sql = "UPDATE transporte.tbl_empresa SET bactivo=:bactivo WHERE iidempresa=:iidempresa"; // Consulta para actualizar estado activo del inspector
            $params = array('bactivo' => $bactivo ? 'f' : 't', 'iidempresa' => $iidempresa); // Si esta activo lo pone en falso, y viceversa
            Db::execute($sql, $params); // Ejecutar actualización del estado activo de empresa
            $msg = $bactivo ? 'desactivado' : 'activado'; // Mensaje de confirmación
            return array('message' => "La empresa ha sido $msg."); // Devolver mensaje de éxito
        }
    
       
        // // Método para insertar datos en la base de datos
        private function insert($table, $params)
        {
            $cols = implode(', ', array_keys($params)); // Obtener nombres de columnas
            $phs = ':' . str_replace(', ', ', :', $cols); // Obtener marcadores de posición para los valores
            $sql = "INSERT INTO transporte.$table ($cols) VALUES ($phs)"; // Consulta de inserción
            return Db::execute($sql, $params); // Ejecutar inserción en la base de datos
        }
    
        // // Método para validar datos requeridos
        private function validRequiredData($data, $from)
        {
            switch ($from) {
                case 'createCompany':
                case 'updateCompany':
                    $requiredKeys = array('iidpersona'); // Claves requeridas
                    break;
                default:
                    $message = "Falta de información.";
                    throw new ValidatorBoomException(422, $message);
                    break;
            }
    
            // $requiredKeys = array('iidpersona' 'iidempresa'); // Claves requeridas
            $actualKeys = array_keys(get_object_vars($data)); // Claves presentes en los datos
            $missingKeys = array_diff($requiredKeys, $actualKeys); // Claves faltantes
            $message = 'Faltan valores requeridos.';
    
            if (!empty($missingKeys)) throw new ValidatorBoomException(422, $message);
    
            foreach ($data as $key => $value) {
                if (!in_array($key, $requiredKeys)) continue;
                // Validar tipos de valores según la clave
                switch ($key) {
                    case 'iidempresa':
                    case 'iidpersona':
                        $message = "Tipo de valor incorrectos en $key.";
                        if (!is_int($value)) throw new ValidatorBoomException(422, $message);
                        break;
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