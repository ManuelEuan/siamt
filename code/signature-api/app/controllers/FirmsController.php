<?php

namespace app\controllers;

use App\Library\Db\Db;
use App\Library\Http\Controllers\BaseController;
use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Http\Exceptions\ValidatorBoomException;

class FirmsController extends BaseController
{
    private function hasClientAuthorized($permission)
    {
        $permissions = $this->token->getPermissions()['fir'];
        if (!in_array($permission, $permissions)) {
            throw new HttpUnauthorizedException(401, 'Permisos insuficientes.');
        }
    }

    function dep($data)
    {
        $format  = print_r('<pre>');
        $format .= print_r($data);
        $format .= print_r('</pre>');
        return $format;
    }

    public function getDinamycCount()
    {

        $sql = "SELECT 
                    COUNT(*) AS cantidad_registros
                FROM 
                    usuario.usuario_dominio_modulo udm
                INNER JOIN 
                    usuario.permiso up ON udm.idmodulo = up.idmodulo
                WHERE 
                    up.siglas = 'vefi';";

        //$counts['firm_users'] = Db::fetchColumn($sql);

        $tables = ["firm_registers" => "comun.tbl_firma", "firm_templates" => "comun.tbl_cat_firma_plantilla"];

        foreach ($tables as $key => $table) {
            $sql = "SELECT COUNT(*) FROM $table";
            $counts[$key] = Db::fetchColumn($sql);
        }
        // self::dep($counts);
        // exit;
        return $counts;
    }

    public function getAllTemplates()
    {
        $sql = "SELECT iid AS iidfirma_plantilla, txtnombre, txtplantilla FROM comun.tbl_cat_firma_plantilla WHERE bactivo = 't'";
        $templates = Db::fetchAll($sql);
        return $templates;
    }

    public function getAllFirms()
    {
        $sql = "SELECT iid AS iidfirma_registro, iidfirma_plantilla, txttitulo, txtnombre, txtapellido_paterno, txtapellido_materno, txtpuesto, txtoficina, txtdepartamento, txtemail, txttelefono, txtextension FROM comun.tbl_firma WHERE bactivo = 't'";
        $firms = Db::fetchAll($sql);
        return $firms;
    }

    public function getTemplateById()
    {
        $data = $this->request->getJsonRawBody();
        $sql = 'SELECT iid AS iidfirma_plantilla, txtnombre, txtplantilla FROM comun.tbl_cat_firma_plantilla WHERE iid=:iidfirma_plantilla';
        $params = array(':iidfirma_plantilla' => $data->iidfirma_plantilla);
        $template = Db::fetch($sql, $params);
        return $template;

    }

    public function getFirmById()
    {
        $data = $this->request->getJsonRawBody();
        $sql = 'SELECT iid AS iidfirma_registro, txtnombre, txtapellido_paterno, txtapellido_materno, txtpuesto, txtoficina, txtdepartamento, txtemail, txttelefono, txtextension, txttitulo, iidfirma_plantilla FROM comun.tbl_firma WHERE iid=:iidfirma_registro';
        $params = array('iidfirma_registro' => $data->iidfirma_registro);
        $firm = Db::fetch($sql, $params);
        return $firm;
    }

    public function createTemplate()
    {
        $data = $this->request->getJsonRawBody();
        if (empty($data->txtnombre) || empty($data->txtplantilla)) throw new ValidatorBoomException(422, 'Datos faltantes');
        Db::begin();
        $params = array(
            'txtnombre' => $data->txtnombre,
            'txtplantilla'  => $data->txtplantilla,
            'dtfecha_creacion' => date('Y-m-d H:i:s'),
        );

        $iidfirma_plantilla = $this->insert('tbl_cat_firma_plantilla', $params);
        Db::commit();
        return array('message' => 'La plantilla ha sido creada.', 'iidfirma_plantilla' => $iidfirma_plantilla);
    }

    public function saveFirmRegisterByUser()
    {
        // $this->hasClientAuthorized('edus');
        $data = $this->request->getJsonRawBody();
        // self::dep($data);
        // exit;
        // $this->validRequiredData($data);
        if (empty($data->firm) || empty($data->iidusuario)) throw new ValidatorBoomException(422, 'Datos faltantes');
        $firm = $data->firm;
        $iidusuario = $data->iidusuario;
        Db::begin();
        $params = array(
            'iidfirma_plantilla'  => $firm->iidfirma_plantilla,
            'txttitulo'  => $firm->txttitulo,
            'txtnombre' => $firm->txtnombre,
            'txtapellido_paterno'  => $firm->txtapellido_paterno,
            'txtapellido_materno'  => $firm->txtapellido_materno,
            'txtpuesto'  => $firm->txtpuesto,
            'txtoficina'  => $firm->txtoficina,
            'txtdepartamento'  => $firm->txtdepartamento,
            'txtemail'  => $firm->txtemail,
            'txttelefono'  => $firm->txttelefono,
            'txtextension'  => $firm->txtextension,
            'dtfecha_creacion' => date('Y-m-d H:i:s'),
        );
        // self::dep($data);
        // exit;
        $iidfirma_registro = $this->insert('tbl_firma', $params);
        // self::dep($iidfirma_registro);
        // exit;
        $params = array(
            'iidfirma_registro'  => $iidfirma_registro,
            'iidusuario' => $iidusuario,
            'dtfecha_creacion' => date('Y-m-d H:i:s'),
        );

        $iidfirma_registro_usuario = $this->insert('tbl_firma_usuario', $params);
        Db::commit();
        return array('message' => 'La firma ha sido creada.', 'iidfirma_registro' => $iidfirma_registro, 'iidfirma_registro_usuario' => $iidfirma_registro_usuario);
    }

    

    public function updateTemplate()
    {
        // $this->hasClientAuthorized('edus');
        $data = $this->request->getJsonRawBody();
        if (empty($data->txtnombre) || empty($data->txtplantilla)) throw new ValidatorBoomException(422, 'Datos faltantes');
        // self::dep($data);exit;
        Db::begin();
        $sql = 'UPDATE comun.tbl_cat_firma_plantilla
                SET 
                    txtnombre=:txtnombre, 
                    txtplantilla=:txtplantilla, 
                    dtfecha_modificacion=CURRENT_TIMESTAMP
                WHERE iid=:iidfirma_plantilla
        ';

        $params = array(
            'txtnombre' => $data->txtnombre,
            'txtplantilla'  => $data->txtplantilla,
            'iidfirma_plantilla'      => $data->iidfirma_plantilla
        );
        Db::execute($sql, $params);
        Db::commit();
        return array('message' => 'La plantilla ha sido actualizada.');
    }

    public function updateFirmRegisterByUser()
    {
        // $this->hasClientAuthorized('edus');
        $data = $this->request->getJsonRawBody();
        //   self::dep($data);
        // exit;

        if (empty($data->firm) || empty($data->iidusuario)) throw new ValidatorBoomException(422, 'Datos faltantes');

        $firm = $data->firm;
        // $iidusuario = $data->iidusuario;
        Db::begin();
        $sql = 'UPDATE usuario.tbl_firma
                SET 
                    txtnombre=:txtnombre, 
                    txtapellido_paterno=:txtapellido_paterno, 
                    txtapellido_materno=:txtapellido_materno, 
                    txtpuesto=:txtpuesto, 
                    txtoficina=:txtoficina, 
                    txtdepartamento=:txtdepartamento, 
                    txtemail=:txtemail, 
                    txttelefono=:txttelefono, 
                    txtextension=:txtextension, 
                    txttitulo=:txttitulo, 
                    iidfirma_plantilla=:iidfirma_plantilla, 
                    dtfecha_modificacion=CURRENT_TIMESTAMP
                WHERE iid=:iidfirma_registro
        ';

        $params = array(
            'txtnombre' => $firm->txtnombre,
            'txtapellido_paterno'  => $firm->txtapellido_paterno,
            'txtapellido_materno'  => $firm->txtapellido_materno,
            'txtpuesto'  => $firm->txtpuesto,
            'txtoficina'  => $firm->txtoficina,
            'txtdepartamento'  => $firm->txtdepartamento,
            'txtemail'  => $firm->txtemail,
            'txttelefono'  => $firm->txttelefono,
            'txtextension'  => $firm->txtextension,
            'txttitulo'  => $firm->txttitulo,
            'iidfirma_plantilla'  => $firm->iidfirma_plantilla,
            'iidfirma_registro'      => $firm->iidfirma_registro
        );
        Db::execute($sql, $params);
        Db::commit();
        return array('message' => 'La firma ha sido actualizada.');
    }

    

    private function insert($table, $params)
    {
        $cols = implode(', ', array_keys($params));
        $phs = ':' . str_replace(', ', ', :', $cols);

        $sql = "INSERT INTO comun.$table ($cols) VALUES ($phs)";
        return Db::execute($sql, $params);
    }
}
