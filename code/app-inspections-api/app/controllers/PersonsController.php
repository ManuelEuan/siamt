<?php

namespace App\Controllers;

use Phalcon\Registry;
use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Http\Exceptions\ValidatorBoomException;

class PersonsController extends BaseController
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

    public function getAllSexesPerson()
    {
        $sql = "SELECT 
            iidsexo,
            txtnombre,
            txtdescripcion,
            bactivo AS activo,
            TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
            TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
            FROM persona.cat_sexo
            WHERE bactivo='t'
        ";
        $zones = Db::fetchAll($sql);
        return $zones;
    }

    public function getAllCivilStatusPerson()
    {
        $sql = "SELECT 
            iidestado_civil,
            txtnombre,
            txtdescripcion,
            bactivo AS activo,
            TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
            TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
            FROM persona.cat_estado_civil
            WHERE bactivo='t'
        ";
        $civilStatus = Db::fetchAll($sql);
        return $civilStatus;
    }

    public function getPersonAddresses()
    {
        $this->hasClientAuthorized('crii'); // Verificar si el cliente tiene autorización
        // $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $data = 84;
        $params = array('iidpersona' => $data);
        $sql = "SELECT 
                -- 
                    pd.iiddireccion, 
                    c.txtnombre as colony,
                    CONCAT(
                    CASE
                        WHEN d.txtcalle_letra <> '' THEN CONCAT('Calle ', d.txtcalle, ' ', d.txtcalle_letra)
                        ELSE d.txtcalle
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
                    CONCAT(' C.P. ', c.icodigo_postal),
                    CASE
                        WHEN c.txtnombre <> '' THEN CONCAT(' Colonia. ', c.txtnombre)
                        ELSE ''
                    END,
                    CASE
                        WHEN m.entity <> '' THEN CONCAT(' Municipio. ', m.entity)
                        ELSE ''
                    END
                ) AS direccion_completa,
                    d.iidcolonia,
                    d.txtcalle,
                    d.txtcalle_letra,
                    d.inumero_exterior,
                    d.txtcruzamiento_uno,
                    d.txtcruzamiento_uno_letra,
                    d.flatitud,
                    d.flongitud,
                    c.icodigo_postal,
                    pd.bactual,
                    m.entity,
                    m.municipality,
                    pd.bactivo                   
                FROM 
                    persona.tbl_persona_direccion pd
                JOIN 
                    persona.tbl_direccion d ON pd.iiddireccion = d.iiddireccion
                JOIN 
                    territorio.cat_colonia c ON d.iidcolonia = c.iidcolonia
                JOIN (
                    SELECT DISTINCT ON (c.icodigo_postal)
                        e.txtnombre AS entity,
                        m.txtnombre AS municipality,
                        c.icodigo_postal
                    FROM
                        territorio.cat_colonia AS c
                    JOIN
                        territorio.cat_municipio AS m ON c.iclave_municipio = m.iclave_municipio
                    JOIN
                        territorio.cat_estado AS e ON m.iclave_estado = e.iclave_estado
                ) AS m ON c.icodigo_postal = m.icodigo_postal
                WHERE pd.bactivo='t' AND pd.iidpersona=:iidpersona
        ";
        $addresses = Db::fetchAll($sql, $params);
        // WHERE pd.iidpersona=:iidpersona";
        // WHERE pd.bactivo='t' AND pd.iidpersona=:iidpersona";
        // $this->dep($addresses);
        // exit;
        return $addresses;
    }

    public function createPerson()
    {
        $this->hasClientAuthorized('crii'); // Verificar si el cliente tiene autorización

        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $this->validRequiredData($data, 'person'); // Validar datos requeridos
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

    public function createDirection()
    {
        $this->hasClientAuthorized('crii'); // Verificar si el cliente tiene autorización

        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        if (empty($data->iidpersona)) {
            throw new ValidatorBoomException(422, 'No se ha podido identificar a la persona');
        }
        $iidpersona = $data->iidpersona;
        // if (empty($data->iidpersona)) throw new ValidatorBoomException(422, 'No se ha podido identificar a la persona');
        $this->validRequiredData($data->direction, 'direction'); // Validar datos requeridos
        // var_dump($data->direction->inumero_exterior);exit;

        Db::begin(); // Iniciar transacción en la base de datos

        $params = array(
            'iidcolonia' => $data->direction->iidcolonia,
            'txtcalle' => $data->direction->txtcalle,
            'txtcalle_letra' => $data->direction->txtcalle_letra,
            'inumero_exterior' => $data->direction->inumero_exterior,
            'txtnumero_exterior_letra' => $data->direction->txtnumero_exterior_letra,
            'inumero_interior' => $data->direction->inumero_interior,
            'txtnumero_interior_letra' => $data->direction->txtnumero_interior_letra,
            'txtcruzamiento_uno' => $data->direction->txtcruzamiento_uno,
            'txtcruzamiento_uno_letra' => $data->direction->txtcruzamiento_uno_letra,
            'txtcruzamiento_dos' => $data->direction->txtcruzamiento_dos,
            'txtcruzamiento_dos_letra' => $data->direction->txtcruzamiento_dos_letra,
            'txtreferencia' => $data->direction->txtreferencia,
            'flatitud' => $data->direction->flatitud,
            'flongitud' => $data->direction->flongitud,
        );

        $iiddireccion = $this->insert('tbl_direccion', $params);
        // if(!$iiddireccion){
        //     throw new ValidatorBoomException(422, 'No se ha podido registrar la dirección');
        // }

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
            // var_dump('actualizado');
        }

        $paramsPersonDirection = array('iidpersona' => $iidpersona, 'iiddireccion' => $iiddireccion, 'bactual' => $data->bactual);
        $this->insert('tbl_persona_direccion', $paramsPersonDirection);
        Db::commit(); // Confirmar transacción en la base de datos
        $data->direction->iiddireccion = $iiddireccion;

        return array('message' => 'La dirección ha sido creada.', 'data' => $data); // Devolver mensaje de éxito
    }

    public function updateCurrentAddress()
    {
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        // var_dump($data);exit;
        if (empty($data->iidpersona) || empty($data->selectedAddress)) {
            throw new ValidatorBoomException(422, 'Falta de información requerida');
        }
        Db::begin(); // Iniciar transacción en la base de datos
        $paramsOld = array('iidpersona' => $data->iidpersona);
        $sql = "UPDATE persona.tbl_persona_direccion SET bactual = false WHERE iidpersona = :iidpersona";
        Db::execute($sql, $paramsOld);
        $paramsNew = array('iidpersona' => $data->iidpersona, 'iiddireccion' => $data->selectedAddress);
        $sql = "UPDATE persona.tbl_persona_direccion SET bactual = true WHERE iidpersona = :iidpersona AND iiddireccion = :iiddireccion";
        Db::execute($sql, $paramsNew);
        Db::commit(); // Confirmar transacción en la base de datos
        return array('message' => 'La dirección ha sido actualizada.', 'data' => $data);
    }

    // // Método para eliminar un inspector
    public function deleteAddress()
    {
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        // var_dump($data);exit;
        if (empty($data->iidpersona) || empty($data->selectedAddress)) {
            throw new ValidatorBoomException(422, 'Falta de información requerida');
        }
        Db::begin(); // Iniciar transacción en la base de datos
        $paramsNew = array('iidpersona' => $data->iidpersona, 'iiddireccion' => $data->selectedAddress);
        $sql = "UPDATE persona.tbl_persona_direccion SET bactivo = false WHERE iidpersona = :iidpersona AND iiddireccion = :iiddireccion";
        Db::execute($sql, $paramsNew);
        Db::commit(); // Confirmar transacción en la base de datos
        return array('message' => 'La dirección ha sido eliminada.', 'data' => $data);
    }

    private function insert($table, $params)
    {
        $cols = implode(', ', array_keys($params)); // Obtener nombres de columnas
        $phs = ':' . str_replace(', ', ', :', $cols); // Obtener marcadores de posición para los valores
        $sql = "INSERT INTO persona.$table ($cols) VALUES ($phs)"; // Consulta de inserción
        return Db::execute($sql, $params); // Ejecutar inserción en la base de datos
    }

    // // Método para validar datos requeridos
    private function validRequiredData($data, $typeValidation)
    {
        // if($$typeValidation == 'person'){
        // }
        switch ($typeValidation) {
            case 'person':
                $requiredKeys = array('bfisica', 'txtnombre', 'txtcurp'); // Claves requeridas
                break;
            case 'direction':
                $requiredKeys = array('iidcolonia', 'txtcalle'); // Claves requeridas
                break;
            default:
                $message = "No se seleccionó un tipo de validación";
                throw new ValidatorBoomException(422, $message);
                break;
        }
        $actualKeys = array_keys(get_object_vars($data)); // Claves presentes en los datos
        $missingKeys = array_diff($requiredKeys, $actualKeys); // Claves faltantes
        $message = 'Faltan valores requeridosss.';

        if (!empty($missingKeys)) throw new ValidatorBoomException(422, $message);

        foreach ($data as $key => $value) {
            if (!in_array($key, $requiredKeys)) continue;

            // Validar tipos de valores según la clave
            switch ($key) {
                case 'iidcolonia':
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

    public function updateAddress()
    {
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $this->validRequiredData($data->direction, 'direction'); // Validar datos requeridos
        // $this->dep($data);exit;
        Db::begin(); // Iniciar transacción en la base de datos

        // Actualización de inspector
        $sql = 'UPDATE persona.tbl_direccion SET 
                iidcolonia=:iidcolonia,
                txtcalle=:txtcalle,
                txtcalle_letra=:txtcalle_letra,
                inumero_exterior=:inumero_exterior,
                txtnumero_exterior_letra=:txtnumero_exterior_letra,
                inumero_interior=:inumero_interior,
                txtnumero_interior_letra=:txtnumero_interior_letra,
                txtcruzamiento_uno=:txtcruzamiento_uno,
                txtcruzamiento_uno_letra=:txtcruzamiento_uno_letra,
                txtcruzamiento_dos=:txtcruzamiento_dos,
                txtcruzamiento_dos_letra=:txtcruzamiento_dos_letra,
                txtreferencia=:txtreferencia,
                flatitud=:flatitud,
                flongitud=:flongitud,
                dtfecha_modificacion=:dtfecha_modificacion
            WHERE iiddireccion=:iiddireccion
        ';
        $params = array(
            'iidcolonia'  => $data->direction->iidcolonia,
            'txtcalle' => $data->direction->txtcalle,
            'txtcalle_letra' => $data->direction->txtcalle_letra,
            'inumero_exterior' => $data->direction->inumero_exterior !== '' ? $data->direction->inumero_exterior : null,
            'txtnumero_exterior_letra' => $data->direction->txtnumero_exterior_letra,
            'inumero_interior' => $data->direction->inumero_interior !== '' ? $data->direction->inumero_interior : null,
            'txtnumero_interior_letra' => $data->direction->txtnumero_interior_letra,
            'txtcruzamiento_uno' => $data->direction->txtcruzamiento_uno,
            'txtcruzamiento_uno_letra' => $data->direction->txtcruzamiento_uno_letra,
            'txtcruzamiento_dos' => $data->direction->txtcruzamiento_dos,
            'txtcruzamiento_dos_letra' => $data->direction->txtcruzamiento_dos_letra,
            'txtreferencia' => $data->direction->txtreferencia,
            'flatitud' => $data->direction->flatitud !== '' ? $data->direction->flatitud : null,
            'flongitud' => $data->direction->flongitud !== '' ? $data->direction->flongitud : null,
            'dtfecha_modificacion' => date('Y-m-d H:i:s'),
            'iiddireccion' => $data->direction->iiddireccion,

        );
        
        Db::execute($sql, $params);
        Db::commit();
        
        return array('message' => 'La dirección ha sido actualizada.'); // Devolver mensaje de éxito
    }
}
