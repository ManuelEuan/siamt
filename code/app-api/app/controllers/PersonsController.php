<?php

namespace App\Controllers;

use Phalcon\Registry;
use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Http\Exceptions\ValidatorBoomException;
use App\Library\Misc\Utils;

// 
use Vokuro\GenericSQL\Person\Persons;
use Vokuro\GenericSQL\Person\PersonAddresses;
use Vokuro\GenericSQL\Person\PersonPhones;
use Vokuro\GenericSQL\Person\Addresses;
use Vokuro\GenericSQL\Person\Phones;
use Vokuro\GenericSQL\Person\TypesAddress;
use Vokuro\GenericSQL\Person\TypesRoad;

// MODELOS 
use App\Models\Person\Inspectors;
use App\Models\Person\Companies;
// MODELOS PERSONAS
// use App\Models\Person\Persons;
use App\Models\Person\Sexes;
use App\Models\Person\CivilStatus;
use App\Models\Person\TypesPhone;
use App\Models\Person\Lada;

class PersonsController extends BaseController
{

    private function hasClientAuthorized($permission)
    {

        $permissions = $this->token->getPermissions()['pel']; // Obtener permisos del token de usuario
        if (!in_array($permission, $permissions)) { // Comprobar si el permiso está presente en los permisos del usuario
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

    public function getPersonByDinamycSearch()
    {

        // return Person::getDemoModel();
        $data =  $this->request->getJsonRawBody();
        $typeOfRequest = $data->data->typeOfRequest;
        $personas = Persons::getPersonByDinamycSearch($data);

        // SI NO EXISTE LA PERSONA SE RETORNA VACÍO
        if (!$personas || !$personas[0]) {
            return;
        }

        // SI EXISTE PERSONA ÚNICA SE RETORNAN LOS DATOS ESPECÍFICOS
        $permissions = $this->token->getPermissions()['pel'];
        if (count($personas) > 0) {
            foreach ($personas as $key => $persona) {
                if ($typeOfRequest == 'Inspector') {
                    // Consulta adicional para obtener información de inspección
                    $inspector = Inspectors::getInspector($persona->iidpersona);

                    if (!$inspector) {
                        $persona->foundRequestSearched = false;
                    } else {
                        $persona->iidOfSearchedRequest = $inspector->iidinspector;
                        $persona->foundRequestSearched = true;
                    }
                }
                if ($typeOfRequest == 'Empresa') {
                    // Consulta adicional para obtener información de inspección
                    $company = Companies::getCompany($persona->iidpersona);
                    if (!$company) {
                        $persona->foundRequestSearched = false;
                    } else {
                        $persona->iidOfSearchedRequest = $company->iidempresa;
                        $persona->foundRequestSearched = true;
                    }
                }
                if (in_array('vetp', $permissions)) {
                    $persona->telefonos = self::getPersonPhones($persona->iidpersona);
                }
                if (in_array('vedp', $permissions)) {
                    $persona->direcciones = self::getPersonAddresses($persona->iidpersona);
                }
            }
        }

        // SI EXISTEN MUCHAS PERSONAS QUE COINCIDEN CON LA BÚSQUEDA SE RETORNAN TODAS
        return $personas;
        // return $persona;
    }

    public function getAllSexes()
    {
        return Sexes::getAllSexes();
    }

    public function getAllTypesOfAddress()
    {
        return TypesAddress::getAll();
    }

    public function getAllTypesOfRoad()
    {
        return TypesRoad::getAll();
    }


    public function getAllLadaIdentifiers()
    {
        return Lada::getAllLada();
    }

    public function getAllCivilStatus()
    {
        return CivilStatus::getAllCivilStatus();
    }

    public function getAllTypesPhone()
    {
        return TypesPhone::getAllTypesPhone();
    }

    public function getGeneralPersonData()
    {
        $this->hasClientAuthorized('vemp'); // Verificar si el cliente tiene autorización
        $iidpersona = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $person = Persons::getById($iidpersona);
        return $person;
    }

    public function getPersonAddresses($iidpersona = 0)
    {
        $this->hasClientAuthorized('vedp'); // Verificar si el cliente tiene autorización
        if ($iidpersona) {
            $iid = $iidpersona;
        } else {
            $iid = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        }
        $personAdresses = PersonAddresses::getAll($iid);
        return $personAdresses;
    }

    public function getPersonPhones($iidpersona = 0)
    {
        $this->hasClientAuthorized('vetp'); // Verificar si el cliente tiene autorización
        if ($iidpersona) {
            $iid = $iidpersona;
        } else {
            $iid = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        }
        $phones = PersonPhones::getAllPhonesByIdPerson($iid);
        return $phones;
    }

    public function createPerson()
    {
        $this->hasClientAuthorized('crmp'); // Verificar si el cliente tiene autorización

        $info = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        if (isset($info->person)) {
            $data = $info->person;
            $phone = $info->phone;
            $address = $info->address;
        } else {
            $data = $info;
        }
        $this->validRequiredData($data, 'person'); // Validar datos requeridos
        $exist = false;
        if ($data->txtcurp) {
            $exist = Persons::searchCURP($data->txtcurp);
            $message = 'El CURP ya se encuentra registrado';
        } elseif ($data->txtrfc) {
            $exist = Persons::searchRFC($data->txtrfc);
            $message = 'El RFC ya se encuentra registrado';
        }
        if ($exist) {
            throw new ValidatorBoomException(422, $message);
        }


        Db::begin(); // Iniciar transacción en la base de datos
        try {

            $iidpersona = Persons::create($data);

            $iidpersona = intval($iidpersona);
            $nombreCompleto = $data->txtnombre . ' ' . $data->txtapellido_paterno;

            if (!empty($data->txtapellido_materno)) {
                $nombreCompleto .= ' ' . $data->txtapellido_materno;
            }

            $data->iidpersona = $iidpersona;
            $data->txtnombre_completo = $nombreCompleto;
            if (isset($phone)) {
                $phone->iidpersona = $iidpersona;
                $this->createPhone($phone);
            }
            if (isset($address)) {
                $address->iidpersona = $iidpersona;
                $this->createAddress($address);
            }


            Db::commit(); // Confirmar transacción en la base de datos
            return ['message' => 'La persona ha sido creada.', 'persona' => $data];
        } catch (\Exception $e) {
            Db::rollback();
            throw new ValidatorBoomException(422, 'Ha ocurrido un error al crear la persona. ' . $e->getMessage());
        }
    }

    // // Método para actualizar un persona
    public function updatePerson()
    {
        $this->hasClientAuthorized('edgp'); // Verificar si el cliente tiene autorización
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $this->validRequiredData($data, 'person'); // Validar datos requeridos
        Db::begin(); // Iniciar transacción en la base de datos
        try {
            Persons::update($data);

            Db::commit();
            $txtnombre_completo = $data->txtnombre . ' ' . $data->txtapellido_paterno;
            if (!empty($data->txtapellido_materno)) {
                $txtnombre_completo .= ' ' . $data->txtapellido_materno;
            }

            return ['message' => 'La persona ha sido actualizada.', 'txtnombre_completo' => $txtnombre_completo];
        } catch (\Exception $e) {
            Db::rollback();
            throw new ValidatorBoomException(422, 'Error en transacción de persona');
        }


        return array(); // Devolver mensaje de éxito
    }

    public function createAddress($direction = '')
    {
        $this->hasClientAuthorized('crdp'); // Verificar si el cliente tiene autorización

        if ($direction != '') {
            $data = new \stdClass();
            $data->address = $direction;
            if (is_object($direction) && property_exists($direction, 'iidpersona')) {
                $data->iidpersona = $direction->iidpersona;
            }
        } else {
            $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        }
        if (empty($data->iidpersona)) {
            throw new ValidatorBoomException(422, 'No se ha podido identificar a la persona para asignar dirección');
        }
        $iidpersona = $data->iidpersona;
        $this->validRequiredData($data->address, 'address'); // Validar datos requeridos

        // Añadir the_geom a los datos de dirección
        if (!empty($data->address->nlatitud) && !empty($data->address->nlongitud)) {
            $data->address->the_geom = "POINT({$data->address->nlongitud} {$data->address->nlatitud})"; // Formato POINT
        }

        Db::begin(); // Iniciar transacción en la base de datos
        try {
            $iiddireccion = Addresses::create($data->address);
            PersonAddresses::deactivateAll($iidpersona);
            PersonAddresses::create($iidpersona, $iiddireccion);
            Db::commit(); // Confirmar transacción en la base de datos
            // $data->address->iiddireccion = $iiddireccion;
            return ['message' => 'La dirección ha sido creada.', 'data' => $data];
        } catch (\Exception $e) {
            Db::rollback();
            throw new ValidatorBoomException(422, 'Ha ocurrido un error al crear la dirección. ' . $e->getMessage());
        }
    }

    public function createPhone($phone = '')
    {
        $this->hasClientAuthorized('crtp'); // Verificar si el cliente tiene autorización

        if ($phone != '') {
            $data = new \stdClass();
            $data->phone = $phone;
            if (is_object($phone) && property_exists($phone, 'iidpersona')) {
                $data->iidpersona = $phone->iidpersona;
            }
            if (is_object($data->phone) && property_exists($data->phone, 'vtelefono')) {
                $data->phone->vtelefono = preg_replace('/[^0-9]/', '', $data->phone->vtelefono);
                $data->phone->vtelefono = intval($data->phone->vtelefono);
            }
        } else {
            $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
            $data->phone->vtelefono = preg_replace('/[^0-9]/', '', $data->phone->vtelefono);
            $data->phone->vtelefono = intval($data->phone->vtelefono);
        }

        if (empty($data->iidpersona)) {
            throw new ValidatorBoomException(422, 'No se ha podido identificar a la persona para asignar Teléfono');
        }

        $iidpersona = $data->iidpersona;
        $this->validRequiredData($data->phone, 'phone'); // Validar datos requeridos
        Db::begin(); // Iniciar transacción en la base de datos
        try {
            // $iidtelefono = Phones::create($data->phone);
            // PersonPhones::deactivateAll($iidpersona);

            // PersonPhones::create($data->phone->iidpersona, $data->phone->iid_tipo_telefono, $data->phone->vtelefono);
            if (!isset($data->phone->iidpersona)) {
                $data->phone->iidpersona = $iidpersona;
            }
            $iidtelefono = PersonPhones::create($data);

            Db::commit(); // Confirmar transacción en la base de datos
            $data->phone->iidtelefono = $iidtelefono;
            return ['message' => 'El teléfono ha sido creado.', 'data' => $data];
        } catch (\Exception $e) {
            Db::rollback();
            throw new ValidatorBoomException(422, 'Ha ocurrido un error al crear el teléfono.' . $e->getMessage());
        }
    }

    public function updatePhone()
    {
        $this->hasClientAuthorized('edtp');
        $data = $this->request->getJsonRawBody();

        $data->phone->vtelefono = preg_replace('/[^0-9]/', '', $data->phone->vtelefono);
        $data->phone->vtelefono = intval($data->phone->vtelefono);

        $this->validRequiredData($data->phone, 'phone');

        Db::begin();
        try {
            PersonPhones::update($data->phone);
            Db::commit();
            return ['message' => 'El teléfono ha sido actualizado correctamente.'];
        } catch (\Exception $e) {
            Db::rollback();
            throw new ValidatorBoomException(422, 'Ha ocurrido un error al actualizar el teléfono.');
        }
    }


    public function updateCurrentPhone()
    {
        $this->hasClientAuthorized('edtp');
        $data = $this->request->getJsonRawBody();
        if (empty($data->iidpersona) || empty($data->selectedPhone)) {
            throw new ValidatorBoomException(422, 'Falta de información requerida');
        }
        Db::begin();
        try {
            PersonPhones::updateCurrentPhone($data);
            Db::commit();
            return ['message' => 'El teléfono actual ha sido actualizado correctamente.'];
        } catch (\Exception $e) {
            Db::rollback();
            throw new ValidatorBoomException(422, 'Ha ocurrido un error al actualizar el teléfono actual.');
        }
    }

    public function updateCurrentAddress()
    {
        $this->hasClientAuthorized('eddp');
        $data = $this->request->getJsonRawBody();
        if (empty($data->iidpersona) || empty($data->selectedAddress)) {
            throw new ValidatorBoomException(422, 'Falta de información requerida');
        }
        Db::begin();

        try {
            PersonAddresses::updateCurrentAddress($data);
            Db::commit();
            return ['message' => 'La dirección ha sido actualizada.', 'data' => $data];
        } catch (\Exception $e) {
            Db::rollback();
            throw new ValidatorBoomException(422, 'Ha ocurrido un error al actualizar la dirección actual.');
        }
    }

    public function deleteAddress()
    {
        $this->hasClientAuthorized('eddp');
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        if (empty($data->iidpersona) || empty($data->selectedAddress)) {
            throw new ValidatorBoomException(422, 'Falta de información requerida');
        }
        Db::begin();
        try {
            PersonAddresses::delete($data->iidpersona, $data->selectedAddress);
            Db::commit();
            return ['message' => 'La dirección ha sido eliminada.', 'data' => $data];
        } catch (\Exception $e) {
            Db::rollback();
            throw new ValidatorBoomException(422, 'Ha ocurrido un error al borrar la dirección.');
        }
    }

    public function deletePhone()
    {
        $this->hasClientAuthorized('edtp');
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        if (empty($data->iidpersona) || empty($data->selectedPhone)) {
            throw new ValidatorBoomException(422, 'Falta de información requerida');
        }
        Db::begin();

        try {
            PersonPhones::deactivate($data);
            Db::commit();
            return ['message' => 'El teléfono ha sido eliminado.', 'data' => $data];
        } catch (\Exception $e) {
            Db::rollback();
            throw new ValidatorBoomException(422, 'Ha ocurrido un error al eliminar el teléfono.');
        }
    }

    // // Método para validar datos requeridos
    private function validRequiredData($data, $typeValidation)
    {
        switch ($typeValidation) {
            case 'person':
                $requiredKeys = array('bfisica', 'txtnombre'); // Claves requeridas
                // Si el tipo de validación es 'person' y 'bfisica' es true, agregar 'txtcurp' a las claves requeridas, de lo contrario, agregar 'txtrfc'
                if ($data->bfisica) {
                    $requiredKeys[] = 'txtcurp';
                } else {
                    $requiredKeys[] = 'txtrfc';
                }
                break;
            case 'address':
                $requiredKeys = array('txtcolonia'); // Claves requeridas
                break;
            case 'phone':
                $requiredKeys = array('vtelefono', 'iidtipo_telefono'); // Claves requeridas
                break;
            default:
                $message = "No se seleccionó un tipo de validación";
                throw new ValidatorBoomException(422, $message);
                break;
        }
        $actualKeys = array_keys(get_object_vars($data)); // Claves presentes en los datos
        $missingKeys = array_diff($requiredKeys, $actualKeys); // Claves faltantes

        $message = 'Faltan valores requeridos.';

        if (!empty($missingKeys)) throw new ValidatorBoomException(422, $message);

        foreach ($data as $key => $value) {
            if (!in_array($key, $requiredKeys)) continue;

            // Validar tipos de valores según la clave
            switch ($key) {
                case 'iidcolonia':
                case 'vtelefono':
                    // var_dump(gettype($key));
                    $message = "Tipo de valor incorrecto en $key.";
                    if (!is_int($value)) throw new ValidatorBoomException(422, $message);
                    break;
                case 'iidtipo_telefono':
                    $message = "Tipo de valor incorrectos en $key.";
                    if (!is_int($value)) throw new ValidatorBoomException(422, $message);
                    break;
                case 'bfisica':
                    $message = "Tipo de valor incorrecto en $key.";
                    if (!is_bool($value)) throw new ValidatorBoomException(422, $message);
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

    public function updateAddress()
    {
        $this->hasClientAuthorized('eddp');
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $this->validRequiredData($data->address, 'address'); // Validar datos requeridos

        Db::begin();

        try {
            // Verificar y extraer las coordenadas
        if (!empty($data->the_geom->coordinates) && count($data->the_geom->coordinates) >= 2) {
            $nlatitud = (float)$data->the_geom->coordinates[1];
            $nlongitud = (float)$data->the_geom->coordinates[0];
            $data->address->the_geom = "POINT($nlongitud $nlatitud)"; // Convertir a formato POINT
        } else {
            throw new ValidatorBoomException(422, 'Coordenadas no válidas.');
        }

            Addresses::update($data->address);
            Db::commit();
            return ['message' => 'La dirección ha sido actualizada.', 'data' => $data];
        } catch (\Exception $e) {
            Db::rollback();
            throw new ValidatorBoomException(422, 'Ha ocurrido un error al actualizar la dirección.');
        }

        Db::commit();

        return array('message' => 'La dirección ha sido actualizada.'); // Devolver mensaje de éxito
    }
}
