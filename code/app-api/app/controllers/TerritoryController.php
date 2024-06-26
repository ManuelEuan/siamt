<?php

namespace App\Controllers;

use App\Library\Db\Db;
use App\Library\Http\Controllers\BaseController;
use App\Library\Http\Exceptions\HttpBadRequestException;
use App\Models\Territory\Colonies;
use Phalcon\Mvc\Controller;
use App\Models\Territory\LocalDistricts;
use App\Models\Territory\Townships;
use App\Models\Territory\Towns;
use App\Models\Territory\Sections;
use Vokuro\GenericSQL\GenericSQL;

class TerritoryController extends BaseController
{
    public function getDL()
    {
        $isAsig = $this->request->getQuery('asig', null, 'y');
        $where = "";
        if ($isAsig == 'y') {
            $token = $this->di->getShared('token');
            $idUsuario = $token->getUserId();

            $sql = "select cc.* from persona.cat_padron cc 
            left join usuario.usuario_padron up on cc.id = up.idcat_padron 
            where cc.activo and up.activo and up.idusuario =" . $idUsuario;

            $censusCat = Db::fetchAll($sql);
            if ($censusCat) {
                $sqlp = "";
                foreach ($censusCat as $cs) {
                    $sqlp .= "SELECT iid, idistritolocal, iidseccionln, " . $cs->id . " idpadron FROM " . $cs->esquema . "." . $cs->tabla . " t" . $cs->id . " union ";
                }
                $sqlp = trim($sqlp, ' union ');
                $sql = "select DISTINCT(idistritolocal) dl from (
                select * from (" . $sqlp . ") t
            join persona.usuario_padron_persona upp on upp.id_padron = t.idpadron and upp.id_persona = t.iid
            where upp.id_usuario = " . $idUsuario . " and upp.fecha_inicio_asignacion <=  CURRENT_DATE and CURRENT_DATE <= upp.fecha_fin_asignacion) t";
                $odls = Db::fetchAll($sql);
                $dls = "";
                foreach ($odls as $dl) {
                    $dls .= $dl->dl . ", ";
                }
            } else {
                $dls = "";
            }

            if ($dls) {
                $dls = trim($dls, ', ');
                $where .= " dl in (" . $dls . ")";
            } else {
                $where .= " dl in (-1)";
            }
        }
        return LocalDistricts::find([
            $where,
            "order" => "dl asc"
        ]);
    }

    public function getAllSections()
    {
        $sql = "SELECT id as code, nombre as name, ST_AsGeoJSON(the_geom) AS geojson FROM territorio.seccion WHERE activo = true";
        return GenericSQL::getBySQL($sql);
    }

    public function getSeccion()
    {
        $isAsig = $this->request->getQuery('asig', null, 'y');
        $hasDL = $this->request->has("dl");
        $where = "";
        if ($hasDL) {
            $dl = $this->request->get("dl");
            if ($dl) {
                $where .= "dl = " . $dl;
            }
        }

        if ($isAsig == 'y') {
            $token = $this->di->getShared('token');
            $idUsuario = $token->getUserId();

            $sql = "select cc.* from persona.cat_padron cc 
            left join usuario.usuario_padron up on cc.id = up.idcat_padron 
            where cc.activo and up.activo and up.idusuario =" . $idUsuario;

            $censusCat = Db::fetchAll($sql);
            if ($censusCat) {
                $sqlp = "";
                foreach ($censusCat as $cs) {
                    $sqlp .= "SELECT iid, idistritolocal, iidseccionln, " . $cs->id . " idpadron FROM " . $cs->esquema . "." . $cs->tabla . " t" . $cs->id . " union ";
                }
                $sqlp = trim($sqlp, ' union ');
                $sql = "select DISTINCT(iidseccionln) seccion from (
                select * from (" . $sqlp . ") t
            join persona.usuario_padron_persona upp on upp.id_padron = t.idpadron and upp.id_persona = t.iid
            where upp.id_usuario = " . $idUsuario . " and upp.fecha_inicio_asignacion <=  CURRENT_DATE and CURRENT_DATE <= upp.fecha_fin_asignacion) t";
                $odls = Db::fetchAll($sql);
                $dls = "";
                foreach ($odls as $dl) {
                    $dls .= $dl->seccion . ", ";
                }
                $dls = trim($dls, ', ');
                if ($where != "") $where .= " and ";
                $where .= " seccion in (" . $dls . ")";
            } else {
                $where = " seccion in (-1)";
            }
        }

        return Sections::find([
            $where,
            "order" => "seccion asc"
        ]);
    }

    public function getMunicipalities()
    {
        return Townships::find(['order' => 'nombre']);
    }

    public function getLocalities()
    {
        $mid = $this->request->getQuery('mid', 'int', null);
        if ($mid)
            return Towns::findCveMun($mid);
        else
            return Towns::find([
                "order" => 'cve_mun, nomloc',
            ]);
    }

    public function getLocalDistricts()
    {
        return LocalDistricts::find(['order' => 'dl asc']);
    }

    public function getSections()
    {
        $dl = $this->request->getQuery('dl', 'int', null);
        return Sections::findLocalDistrict($dl);
    }

    public function getColonies()
    {
        $mid = $this->request->getQuery('mid', 'int', null);
        $lic = $this->request->getQuery('lid', 'int', null);

        return Colonies::findCveMunandCveLoc($mid, $lic);
    }


    // V2
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
        return Colonies::getAllPostalCodes();
    }

    public function getMunicipalityAndEntityByPostalCode()
    {
        $data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        $params = array('icodigo_postal' => $data);
        $sql = "SELECT DISTINCT ON (m.txtnombre)
                    m.txtnombre AS entity,
                    e.txtnombre AS municipality
                FROM
                    territorio.tbl_cat_colonia AS c
                JOIN
                    territorio.tbl_cat_municipio AS m ON c.iclave_municipio = m.iclave_municipio
                JOIN
                    territorio.tbl_cat_estado AS e ON m.iclave_estado = e.iclave_estado
                WHERE
                    c.icodigo_postal = :icodigo_postal";
        $municipalityAndEntity = Db::fetchOne($sql, $params);
        return $municipalityAndEntity;
    }

    public function getColoniesByPostalCode()
    {
        $postalCode = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        return Colonies::getColoniesByPostalCode($postalCode);
    }
}
