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

    public function getPersonByDinamycSearch()
    {
        $data =  $this->request->getJsonRawBody();
        $typeSearch = $data->data->typeSearch;
        $dataSearch = $data->data->dataSearch;
        $typeOfRequest = $data->data->typeOfRequest;

        $sql = "SELECT 
                    p.iidpersona,
                    p.bfisica,
                    p.txtnombre,
                    p.txtapepat,
                    p.txtapemat,
                    p.txtrfc,
                    p.txtine,
                    p.txtcurp,
                    p.txtcorreo,
                    p.iidestado_civil,
                    p.iidsexo,
                    p.dfecha_nacimiento,
                    ec.txtnombre AS txtestado_civil,
                    s.txtnombre AS txtsexo,
                    p.bactivo AS activo,
                    CASE 
                        WHEN p.txtapemat != '' THEN 
                            CONCAT(p.txtnombre, ' ', p.txtapepat, ' ', p.txtapemat)
                        ELSE 
                            CONCAT(p.txtnombre, ' ', p.txtapepat) 
                    END AS txtnombre_completo,
                    TO_CHAR(p.dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
                    TO_CHAR(p.dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
                FROM 
                    persona.tbl_persona p 
                LEFT JOIN 
                    persona.cat_estado_civil ec ON p.iidestado_civil = ec.iidestado_civil
                LEFT JOIN 
                    persona.cat_sexo s ON p.iidsexo = s.iidsexo
        ";

        switch ($typeSearch) {
            case 'NOMBRE':
                // Se divide el valor de búsqueda en palabras individuales
                $searchTerms = explode(' ', $dataSearch);

                // Se inicializa un array para almacenar las condiciones de búsqueda
                $conditions = [];

                // Se construyen las condiciones para cada palabra de búsqueda
                foreach ($searchTerms as $term) {
                    if ($term != "") {

                        $dataSearch = '%' . $term . '%';
                        // Se agregan las condiciones para cada columna relevante
                        $conditions[] = '(UPPER(p.txtnombre) ILIKE UPPER(:dataSearch) 
                                     OR UPPER(p.txtapepat) ILIKE UPPER(:dataSearch) 
                                     OR UPPER(p.txtapemat) ILIKE UPPER(:dataSearch))';
                        $where = ' WHERE ' . implode(' OR ', $conditions);
                    }
                }

                // Se unen las condiciones con OR para que cualquiera de ellas coincida
                break;
            case 'CURP':
                $where = ' WHERE p.txtcurp=:dataSearch';
                break;
            case 'RFC':
                $where = ' WHERE p.txtrfc=:dataSearch';
                break;
            default:
                // Si el tipo de búsqueda no coincide con ninguno de los casos anteriores, usar la búsqueda por RFC como predeterminada
                $where = ' WHERE p.txtrfc=:dataSearch';
                break;
        }

        $sqlComplete = $sql . $where;

        $params = array('dataSearch' => $dataSearch);
        if ($typeSearch == 'CURP' || $typeSearch == 'RFC') {
            $personas[] = Db::fetchOne($sqlComplete, $params);

        } else {
            $personas = Db::fetchAll($sqlComplete, $params);
        }

        // SI NO EXISTE LA PERSONA SE RETORNA VACÍO
        if (!$personas) {
            return;
        }
        

        // SI EXISTE PERSONA ÚNICA SE RETORNAN LOS DATOS ESPECÍFICOS
        if ($typeOfRequest == 'Inspector') {
            if (count($personas) > 0) {
                foreach ($personas as $key => $persona) {
                    // Consulta adicional para obtener información de inspección
                    $sql2 = "SELECT iidinspector, iidinspector, txtfolio_inspector
                        FROM inspeccion.tbl_inspector
                        WHERE iidpersona=:iidpersona
                    ";

                    $params2 = array('iidpersona' => $persona->iidpersona);
                    $inspector = Db::fetchOne($sql2, $params2);

                    if (!$inspector) {
                        $persona->foundRequestSearched = false;
                    } else {
                        $persona->iidOfSearchedRequest = $inspector->iidinspector;
                        $persona->foundRequestSearched = true;
                    }
                }
            }
        }
        // $this->dep($personas);exit;
        // SI EXISTEN MUCHAS PERSONAS QUE COINCIDEN CON LA BÚSQUEDA SE RETORNAN TODAS
        return $personas;
        // return $persona;
    }

    public function getAllSexes()
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

    public function getAllLadaIdentifiers()
    {
        $sql = "SELECT 
            iidlada,
            txtnombre,
            txtdescripcion,
            bactivo AS activo,
            TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
            TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
            FROM persona.cat_lada
            WHERE bactivo='t'
        ";
        $ladaIdentifiers = Db::fetchAll($sql);
        return $ladaIdentifiers;
    }

    public function getAllCivilStatus()
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

    public function getAllTypesPhone()
    {
        $sql = "SELECT 
            iidtelefono_tipo,
            txtnombre,
            txtdescripcion,
            bactivo AS activo,
            TO_CHAR(dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
            TO_CHAR(dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
            FROM persona.cat_telefono_tipo
            WHERE bactivo='t'
        ";
        $typesPhone = Db::fetchAll($sql);
        return $typesPhone;
    }

    public function getGeneralPersonData()
    {
        $this->hasClientAuthorized('crii'); // Verificar si el cliente tiene autorización
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $params = array('iidpersona' => $data);
        $sql = "SELECT
                    iidpersona, 
                    bfisica, 
                    txtnombre, 
                    txtapepat, 
                    txtapemat, 
                    dfecha_nacimiento, 
                    iidestado_nacimiento, 
                    txtrfc, 
                    txtcurp, 
                    txtine, 
                    iidestado_civil, 
                    iidsexo, 
                    txtcorreo, 
                    bactivo,
                    CASE 
                        WHEN txtapemat != '' THEN 
                            CONCAT(txtnombre, ' ', txtapepat, ' ', txtapemat)
                        ELSE 
                            CONCAT(txtnombre, ' ', txtapepat) 
                    END AS txtnombre_completo
                FROM
                    persona.tbl_persona
                WHERE
                    bactivo = true AND iidpersona = :iidpersona;
        ";
        // $this->dep($sql);exit;
        $generalPersonData = Db::fetch($sql, $params);
        return $generalPersonData;
    }

    public function getPersonAddresses()
    {
        $this->hasClientAuthorized('crii'); // Verificar si el cliente tiene autorización
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        // var_dump($data);exit;
        // $data = 84;
        $params = array('iidpersona' => $data);
        $sql = "SELECT 
                -- 
                    pd.iiddireccion, 
                    c.txtnombre as colony,
                    CONCAT(
                        CASE
                            WHEN d.itipo_direccion = 1 THEN
                                CONCAT(
                                    CASE
                                        WHEN d.itipo_vialidad = 1 THEN
                                            CASE
                                                WHEN d.txtcalle_letra <> '' THEN CONCAT('Calle ', d.txtcalle, ' ', d.txtcalle_letra)
                                                ELSE d.txtcalle
                                            END
                                        WHEN d.itipo_vialidad = 2 THEN CONCAT('AVENIDA O KM ', d.txtavenida_kilometro)
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
                                    CONCAT(' C.P. ', c.icodigo_postal),
                                    CASE
                                        WHEN c.txtnombre <> '' THEN CONCAT(' Colonia. ', c.txtnombre)
                                        ELSE ''
                                    END,
                                    CASE
                                        WHEN m.entity <> '' THEN CONCAT(' Municipio. ', m.entity)
                                        ELSE ''
                                    END
                                )
                            WHEN d.itipo_direccion = 2 THEN
                                CONCAT('Tablaje ', d.txttablaje,
                                    CONCAT(
                                        CASE
                                            WHEN d.inumero_exterior IS NOT NULL THEN CONCAT(' #', d.inumero_exterior)
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
                                    )
                                )
                            WHEN d.itipo_direccion = 3 THEN
                                CONCAT('Dirección conocida ', d.txtdescripcion_direccion,
                                    CONCAT(
                                        CASE
                                            WHEN d.inumero_exterior IS NOT NULL THEN CONCAT(' #', d.inumero_exterior)
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
                                    )
                                )
                            ELSE '' -- Manejo de otro tipo de dirección, si es necesario
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
                    d.itipo_direccion,
                    d.itipo_vialidad,
                    d.txtavenida_kilometro,
                    d.txttablaje,
                    d.txtdescripcion_direccion,
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
        return $addresses;
    }

    public function getPersonPhones()
    {
        $this->hasClientAuthorized('crii'); // Verificar si el cliente tiene autorización
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        // var_dump($data);exit;
        $params = array('iidpersona' => $data);
        $sql = "SELECT
                    tbl_persona_telefono.iidpersona_telefono,
                    tbl_persona_telefono.iidpersona,
                    cat_telefono_tipo.txtnombre AS txttelefono_tipo, 
                    cat_telefono_tipo.txtdescripcion,
                    tbl_telefono.txtlada, 
                    tbl_telefono.inumero, 
                    tbl_telefono.iidtelefono, 
                    tbl_telefono.iidtelefono_tipo, 	
                    tbl_persona_telefono.bactual,
                    tbl_telefono.bactivo, 
                    tbl_persona_telefono.bactivo, 
                    tbl_persona_telefono.dtfecha_creacion, 
                    tbl_persona_telefono.dtfecha_modificacion
                FROM
                    persona.tbl_persona_telefono
                INNER JOIN
                    persona.tbl_telefono
                ON 
                    tbl_persona_telefono.iidtelefono = tbl_telefono.iidtelefono
                INNER JOIN
                    persona.tbl_persona
                ON 
                    tbl_persona_telefono.iidpersona = tbl_persona.iidpersona
                INNER JOIN
                    persona.cat_telefono_tipo
                ON 
                    tbl_telefono.iidtelefono_tipo = cat_telefono_tipo.iidtelefono_tipo
                WHERE tbl_persona_telefono.iidpersona = :iidpersona AND tbl_persona_telefono.bactivo = true
        ";
        $phones = Db::fetchAll($sql, $params);
        return $phones;
    }

    public function createPerson()
    {
        $this->hasClientAuthorized('crii'); // Verificar si el cliente tiene autorización

        $info = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        // var_dump(isset($info->phone));exit;
        if (isset($info->person)) {
            $data = $info->person;
            $phone = $info->phone;
            $direction = $info->direction;
        } else {
            $data = $info;
        }
        $this->validRequiredData($data, 'person'); // Validar datos requeridos
        Db::begin(); // Iniciar transacción en la base de datos
        // var_dump(($data->bfisica ? 't' : 'f'));exit;

        $params = array(
            'bfisica' => $data->bfisica ? 't' : 'f',
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
        );


        $iiddpersona = $this->insert('tbl_persona', $params);

        // $this->dep($phone);exit;
        if (isset($phone)) {
            $phone->iidpersona = $iiddpersona;
            $this->createPhone($phone);
        }
        if (isset($direction)) {
            $direction->iidpersona = $iiddpersona;
            $this->createAddress($direction);
        }


        Db::commit(); // Confirmar transacción en la base de datos
        return array('message' => 'La persona ha sido creada.', 'iidpersona' => $iiddpersona); // Devolver mensaje de éxito
    }

    // // Método para actualizar un persona
    public function updatePerson()
    {
        $this->hasClientAuthorized('edii'); // Verificar si el cliente tiene autorización
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $this->validRequiredData($data, 'person'); // Validar datos requeridos
        Db::begin(); // Iniciar transacción en la base de datos

        // Actualización de persona
        $sql = 'UPDATE persona.tbl_persona SET 
                    bfisica=:bfisica,
                    txtnombre=:txtnombre,
                    txtapemat=:txtapemat,
                    dfecha_nacimiento=:dfecha_nacimiento,
                    iidestado_nacimiento=:iidestado_nacimiento,
                    -- txtrfc=:txtrfc,
                    -- txtcurp=:txtcurp,
                    txtine=:txtine,
                    iidestado_civil=:iidestado_civil,
                    iidsexo=:iidsexo,
                    txtcorreo=:txtcorreo,
                    bactivo=:bactivo,
                    dtfecha_modificacion=:dtfecha_modificacion
                WHERE iidpersona=:iidpersona
            ';
        $params = array(
            'bfisica'  => $data->bfisica,
            'txtnombre' => $data->txtnombre,
            'txtapemat' => $data->txtapemat,
            'dfecha_nacimiento' => $data->dfecha_nacimiento,
            'iidestado_nacimiento' => $data->iidestado_nacimiento,
            'txtine' => $data->txtine,
            'iidestado_civil' => $data->iidestado_civil,
            'iidsexo' => $data->iidsexo,
            'txtcorreo' => $data->txtcorreo,
            'bactivo' => $data->activo ? 't' : 'f',
            'dtfecha_modificacion' => date('Y-m-d H:i:s'), // Formato de fecha correcto
            'iidpersona'      => $data->iidpersona,
        ); // Parámetros para la actualización de la persona
        // $this->dep($data);exit;

        Db::execute($sql, $params); // Ejecutar actualización de la persona en la base de datos
        Db::commit(); // Confirmar transacción en la base de datos

        return array('message' => 'La persona ha sido actualizada.'); // Devolver mensaje de éxito
    }

    public function createAddress($direction = '')
    {
        $this->hasClientAuthorized('crii'); // Verificar si el cliente tiene autorización

        if ($direction != '') {
            $data = new \stdClass();
            $data->direction = $direction;
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
        // if (empty($data->iidpersona)) throw new ValidatorBoomException(422, 'No se ha podido identificar a la persona');
        $this->validRequiredData($data->direction, 'direction'); // Validar datos requeridos
        // var_dump($data->direction->inumero_exterior);exit;

        Db::begin(); // Iniciar transacción en la base de datos

        $params = array(
            'iidcolonia' => $data->direction->iidcolonia,
            'txtcalle' => $data->direction->txtcalle,
            'txtcalle_letra' => $data->direction->txtcalle_letra,
            'itipo_vialidad' => $data->direction->itipo_vialidad,
            'itipo_direccion' => $data->direction->itipo_direccion,
            'txtavenida_kilometro' => $data->direction->txtavenida_kilometro,
            'txttablaje' => $data->direction->txttablaje,
            'txtdescripcion_direccion' => $data->direction->txtdescripcion_direccion,
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

        $paramsPersonAddress = array('iidpersona' => $iidpersona, 'iiddireccion' => $iiddireccion, 'bactual' => 't');
        $this->insert('tbl_persona_direccion', $paramsPersonAddress);
        Db::commit(); // Confirmar transacción en la base de datos
        $data->direction->iiddireccion = $iiddireccion;

        return array('message' => 'La dirección ha sido creada.', 'data' => $data); // Devolver mensaje de éxito
    }

    public function createPhone($phone = '')
    {
        $this->hasClientAuthorized('crii'); // Verificar si el cliente tiene autorización

        if ($phone != '') {
            $data = new \stdClass();
            $data->phone = $phone;
            if (is_object($phone) && property_exists($phone, 'iidpersona')) {
                $data->iidpersona = $phone->iidpersona;
            }
            if (is_object($data->phone) && property_exists($data->phone, 'inumero')) {
                $data->phone->inumero = intval($data->phone->inumero);
            }
        } else {
            $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
            $data->phone->inumero = intval($data->phone->inumero);
        }

        if (empty($data->iidpersona)) {
            throw new ValidatorBoomException(422, 'No se ha podido identificar a la persona para asignar Teléfono');
        }
        $iidpersona = $data->iidpersona;
        $this->validRequiredData($data->phone, 'phone'); // Validar datos requeridos

        Db::begin(); // Iniciar transacción en la base de datos

        $params = array(
            'txtlada' => $data->phone->txtlada,
            'inumero' => $data->phone->inumero,
            'iidtelefono_tipo' => $data->phone->iidtelefono_tipo,
            'inumero' => $data->phone->inumero,
        );

        $iidtelefono = $this->insert('tbl_telefono', $params);

        $paramsVerifyCurrently = array('iidpersona' => $iidpersona);
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

        $existsCurrently = Db::fetchAll($sql, $paramsVerifyCurrently);
        if ($existsCurrently) {
            $sql = "UPDATE persona.tbl_persona_telefono SET bactual = false WHERE iidpersona = :iidpersona";
            Db::execute($sql, $paramsVerifyCurrently);
            // var_dump('actualizado');
        }

        $paramsPersonAddress = array('iidpersona' => $iidpersona, 'iidtelefono' => $iidtelefono, 'bactual' => $data->bactual);
        $this->insert('tbl_persona_telefono', $paramsPersonAddress);
        Db::commit(); // Confirmar transacción en la base de datos
        $data->phone->iidtelefono = $iidtelefono;

        return array('message' => 'El teléfono ha sido creado.', 'data' => $data); // Devolver mensaje de éxito
    }

    public function updatePhone()
    {
        $this->hasClientAuthorized('edii'); // Verificar si el cliente tiene autorización
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $data->phone->inumero = intval($data->phone->inumero);
        $this->validRequiredData($data->phone, 'phone'); // Validar datos requeridos
        Db::begin(); // Iniciar transacción en la base de datos

        // Actualización de telefono
        $sql = 'UPDATE persona.tbl_telefono SET 
                    txtlada=:txtlada,
                    inumero=:inumero,
                    iidtelefono_tipo=:iidtelefono_tipo,
                    bactivo=:bactivo,
                    dtfecha_modificacion=:dtfecha_modificacion
                WHERE iidtelefono=:iidtelefono
            ';
        $params = array(
            'txtlada'  => $data->phone->txtlada,
            'inumero' => intval($data->phone->inumero),
            'iidtelefono_tipo' => $data->phone->iidtelefono_tipo,
            'bactivo' => $data->phone->activo ? 't' : 'f',
            'dtfecha_modificacion' => date('Y-m-d H:i:s'), // Formato de fecha correcto
            'iidtelefono'      => $data->phone->iidtelefono,
        );
        // Parámetros para la actualización del teléfono
        // $this->dep($data);exit;
        Db::execute($sql, $params); // Ejecutar actualización del teléfono en la base de datos
        Db::commit(); // Confirmar transacción en la base de datos

        return array('message' => 'El teléfono ha sido actualizado.'); // Devolver mensaje de éxito
    }

    public function updateCurrentPhone()
    {
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        // var_dump($data);exit;
        if (empty($data->iidpersona) || empty($data->selectedPhone)) {
            throw new ValidatorBoomException(422, 'Falta de información requerida');
        }
        Db::begin(); // Iniciar transacción en la base de datos
        $paramsOld = array('iidpersona' => $data->iidpersona);
        $sql = "UPDATE persona.tbl_persona_telefono SET bactual = false WHERE iidpersona = :iidpersona";
        Db::execute($sql, $paramsOld);
        $paramsNew = array('iidpersona' => $data->iidpersona, 'iidtelefono' => $data->selectedPhone);
        $sql = "UPDATE persona.tbl_persona_telefono SET bactual = true WHERE iidpersona = :iidpersona AND iidtelefono = :iidtelefono";
        Db::execute($sql, $paramsNew);
        Db::commit(); // Confirmar transacción en la base de datos
        return array('message' => 'El teléfono ha sido actualizado.', 'data' => $data);
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

    public function deletePhone()
    {
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        // var_dump($data);exit;
        if (empty($data->iidpersona) || empty($data->selectedPhone)) {
            throw new ValidatorBoomException(422, 'Falta de información requerida');
        }
        Db::begin(); // Iniciar transacción en la base de datos
        $paramsNew = array('iidpersona' => $data->iidpersona, 'iidtelefono' => $data->selectedPhone);
        $sql = "UPDATE persona.tbl_persona_telefono SET bactivo = false WHERE iidpersona = :iidpersona AND iidtelefono = :iidtelefono";
        Db::execute($sql, $paramsNew);
        Db::commit(); // Confirmar transacción en la base de datos
        return array('message' => 'El teléfono ha sido eliminado.', 'data' => $data);
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
        // if($typeValidation == 'person'){
        // }
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
            case 'direction':
                $requiredKeys = array('iidcolonia'); // Claves requeridas
                break;
            case 'phone':
                $requiredKeys = array('inumero', 'iidtelefono_tipo'); // Claves requeridas
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
                case 'inumero':
                    // var_dump(gettype($key));
                    $message = "Tipo de valor incorrecto en $key.";
                    if (!is_int($value)) throw new ValidatorBoomException(422, $message);
                    break;
                case 'iidtelefono_tipo':
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
                dtfecha_modificacion=:dtfecha_modificacion,
                itipo_direccion=:itipo_direccion,
                itipo_vialidad=:itipo_vialidad,
                txtavenida_kilometro=:txtavenida_kilometro,
                txttablaje=:txttablaje,
                txtdescripcion_direccion=:txtdescripcion_direccion
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
            'itipo_direccion' => $data->direction->itipo_direccion !== '' ? $data->direction->itipo_direccion : null,
            'itipo_vialidad' => $data->direction->itipo_vialidad !== '' ? $data->direction->itipo_vialidad : null,
            'txtavenida_kilometro' => $data->direction->txtavenida_kilometro,
            'txttablaje' => $data->direction->txttablaje,
            'txtdescripcion_direccion' => $data->direction->txtdescripcion_direccion,
            'iiddireccion' => $data->direction->iiddireccion,
        );

        Db::execute($sql, $params);
        Db::commit();

        return array('message' => 'La dirección ha sido actualizada.'); // Devolver mensaje de éxito
    }
}
