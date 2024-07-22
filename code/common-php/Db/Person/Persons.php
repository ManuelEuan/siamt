<?php

namespace Vokuro\GenericSQL\Person;

use App\Library\Http\Exceptions\ValidatorBoomException;
use App\Library\Db\SiamtDb as Db;

class Persons
{

    public static function create($data)
    {

        try{
            $params = [];
            foreach ($data as $key => $value) {
                switch ($key) {
                    case 'iidpersona':
                    case 'dtfecha_creacion':
                    case 'dtfecha_modificacion':
                        break;
                    case 'bfisica':
                        $params[$key] = $value == "" ? 'f' : $value;
                        break;
                    default:
                        $params[$key] = $value;
                        break;
                }
            }

            return Db::insert('persona.tbl_persona', $params);
        } catch (\Exception $e) {
            // Db::rollback();
            throw new ValidatorBoomException(422, 'Error en persona. ' . $e->getMessage());
        }
    }

    public static function update($data)
    {
        try{

            $table = "persona.tbl_persona";
            $params = [];
            foreach ($data as $key => $value) {
                switch ($key) {
                    case 'txtnombre_completo':
                        break;
                    case 'iidpersona':
                        $params['iid'] = $value;
                    break;
                    default:
                        $params[$key] = $value;
                        break;
                }
            }

            $where = "iid = :iid";
            Db::update($table, $params, $where);
        } catch (\Exception $e) {
            // Db::rollback();
            throw new ValidatorBoomException(422, 'Error en persona. ' . $e->getMessage());
        }
    }

    public static function getById($iid)
    {
        $sql = "SELECT
                    iid AS iidpersona, 
                    bfisica, 
                    txtnombre, 
                    txtapellido_paterno, 
                    txtapellido_materno, 
                    dfecha_nacimiento, 
                    iidnacionalidad, 
                    txtrfc, 
                    txtcurp, 
                    txtine, 
                    iidestado_civil, 
                    iidsexo, 
                    txtcorreo, 
                    bactivo,
                    CASE 
                        WHEN txtapellido_materno != '' THEN 
                            CONCAT(txtnombre, ' ', txtapellido_paterno, ' ', txtapellido_materno)
                        ELSE 
                            CONCAT(txtnombre, ' ', txtapellido_paterno) 
                    END AS txtnombre_completo
                FROM
                    persona.tbl_persona
                WHERE
                    bactivo = true AND iid = :iid";
        $params = array('iid' => $iid);
        return Db::fetchOne($sql, $params);
    }

    public static function searchCURP($txtcurp)
    {
        $sql = 'SELECT iid, nombre_completo FROM persona.tbl_persona WHERE txtcurp=:txtcurp';
        $params = array('txtcurp' => $txtcurp);
        return Db::fetchOne($sql, $params);
    }

    public static function searchRFC($txtrfc)
    {
        $sql = 'SELECT iid, nombre_completo FROM persona.tbl_persona WHERE txtrfc=:txtrfc';
        $params = array('txtrfc' => $txtrfc);
        return Db::fetchOne($sql, $params);
    }

    public static function getAddressesById($iid)
    {
        $params = array('iidpersona' => $iid);
        $sql = "SELECT 
                    pd.iid AS iiddireccion, 
                    c.txtnombre as colony,
                    CONCAT(
                        CASE
                            WHEN d.iidtipo_direccion = 1 THEN
                                CONCAT(
                                    CASE
                                        WHEN d.iidtipo_vialidad = 1 THEN
                                            CASE
                                                WHEN d.txtcalle_letra <> '' THEN CONCAT('Calle ', d.txtcalle, ' ', d.txtcalle_letra)
                                                ELSE d.txtcalle
                                            END
                                        WHEN d.iidtipo_vialidad = 2 THEN CONCAT('AVENIDA O KM ', d.txtavenida_kilometro)
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
                            WHEN d.iidtipo_direccion = 2 THEN
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
                            WHEN d.iidtipo_direccion = 3 THEN
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
                    d.txtcruzamiento_dos,
                    d.txtcruzamiento_dos_letra,
                    d.txtreferencia,
                    d.nlatitud,
                    d.nlongitud,
                    d.iidtipo_direccion,
                    d.iidtipo_vialidad,
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
                    persona.tbl_direccion d ON d.iid = pd.iiddireccion
                JOIN 
                    territorio.tbl_cat_colonia c ON d.iidcolonia = c.iid
                JOIN (
                    SELECT DISTINCT ON (c.icodigo_postal)
                        e.txtnombre AS entity,
                        m.txtnombre AS municipality,
                        c.icodigo_postal
                    FROM
                        territorio.tbl_cat_colonia AS c
                    JOIN
                        territorio.tbl_cat_municipio AS m ON c.iclave_municipio = m.iclave_municipio
                    JOIN
                        territorio.tbl_cat_estado AS e ON m.iclave_estado = e.iclave_estado
                ) AS m ON c.icodigo_postal = m.icodigo_postal
                WHERE pd.bactivo='t' AND pd.iidpersona=:iidpersona
        ";
        $addresses = Db::fetchAll($sql, $params);
        return $addresses;
    }

    public static function getPersonByDinamycSearch($data)
    {
        $typeSearch = $data->data->typeSearch;
        $dataSearch = $data->data->dataSearch;
        $sql = "SELECT 
                    p.iid AS iidpersona,
                    p.bfisica,
                    p.txtnombre,
                    p.txtapellido_paterno,
                    p.txtapellido_materno,
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
                        WHEN p.txtapellido_materno != '' THEN 
                            CONCAT(p.txtnombre, ' ', p.txtapellido_paterno, ' ', p.txtapellido_materno)
                        ELSE 
                            CONCAT(p.txtnombre, ' ', p.txtapellido_paterno) 
                    END AS txtnombre_completo,
                    TO_CHAR(p.dtfecha_creacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_creacion,
                    TO_CHAR(p.dtfecha_modificacion, 'DD-MM-YYYY HH24:MI:SS') AS fecha_modificacion
                FROM 
                    persona.tbl_persona p 
                LEFT JOIN 
                    persona.tbl_cat_estado_civil ec ON p.iidestado_civil = ec.iid
                LEFT JOIN 
                    persona.tbl_cat_sexo s ON p.iidsexo = s.iid
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
                                     OR UPPER(p.txtapellido_paterno) ILIKE UPPER(:dataSearch) 
                                     OR UPPER(p.txtapellido_materno) ILIKE UPPER(:dataSearch))';
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
        $where = $where . " AND p.bactivo='t'";
        $sqlComplete = $sql . $where;

        $params = array('dataSearch' => $dataSearch);
        if ($typeSearch == 'CURP' || $typeSearch == 'RFC') {
            $persons[] = Db::fetchOne($sqlComplete, $params);
        } else {
            $persons = Db::fetchAll($sqlComplete, $params);
        }

        return $persons;
    }
}
