<?php

namespace App\Controllers;

use Exception;
use App\Library\Db\Db;
use App\Services\Varios;
use Vokuro\GenericSQL\GenericSQL;
use App\Library\Http\Controllers\BaseController;
use App\Services\Validator as ServicesValidator;
use App\Library\Http\Exceptions\ValidatorBoomException;

class PlanesController extends BaseController {
    /**
     * @var array
     */
    protected $errors;

    public function find() {
        $planId     = $this->request->getQuery('id');
        $nombre     = $this->request->getQuery('nombre');
        $comentarios= $this->request->getQuery('comentarios');
        $modelo_id  = $this->request->getQuery('modelo_id');
        $condicional = 'WHERE';
        
        $query = 'SELECT * FROM comun.tbl_plan_matenimiento';
        if(!empty($planId)) {
            $query .= "  $condicional iid = ".$planId;
            $condicional = 'AND';
        }
        if(!empty($nombre)) {
            $query .= "  $condicional vnombre ILIKE '%".$nombre."%'";
            $condicional = 'AND';
        }
        if(!empty($comentarios)) {
            $query .= " $condicional txtcomentarios ILIKE '%".$comentarios."%'";
            $condicional = 'AND';
        }
        if(!empty($modelo_id)) {
            $query .= " $condicional iidmodelo = ".$modelo_id;
        }
       

        $query.= Varios::ordering($this->request);
        if(!empty($this->request->getQuery('paginate')) && $this->request->getQuery('paginate') == 'true') {
            return Varios::paginate($query, $this->request);
        }
        else{
            $items = GenericSQL::getBySQL($query);
            return array('items' => $items,);
        }
    }

    public function store() {
        $statusCode = 200;
        $message    = 'Operacion exitosa';

        try {
            $this->validate('add');
            $query = "INSERT INTO comun.tbl_plan_matenimiento (iidmodelo,vnombre,iciclo,imeses,txtcomentarios) 
                        VALUES (:iidmodelo,:vnombre,:iciclo,:imeses,:vcomentarios)";
            
            Db::execute($query, $this->getParams());
        } catch (Exception $ex) {
            $statusCode = 403;
            $message = sizeof($this->errors) > 0 ? $this->errors : $ex->getMessage();
        }

        return array('message' => $message, 'statusCode' => $statusCode);
    }

    public function update() {
        $statusCode = 200;
        $message    = 'Operacion exitosa';

        try {
            $this->validate('update');
            $query = "UPDATE comun.tbl_plan_matenimiento SET 
                        iidmodelo   = :iidmodelo,
                        vnombre     = :vnombre,
                        iciclo      = :iciclo,
                        imeses      = :imeses,
                        txtcomentarios      = :vcomentarios,
                        dtfecha_modificacion= now() 
                        WHERE iid=:id";

            $data   = $this->request->getJsonRawBody();
            $params = array_merge($this->getParams(), ['id' => $data->id]);
            
            Db::execute($query, $params);
        } catch (Exception $ex) {
            $statusCode = 403;
            $message = sizeof($this->errors) > 0 ? $this->errors : $ex->getMessage();
        }

        return array('message' => $message, 'statusCode' => $statusCode);
    }

    public function delete($id) {
        $params = array('iid' => $id);
        $sql = "UPDATE comun.tbl_plan_matenimiento SET bactivo =false, dtfecha_modificacion=now() WHERE iid=:iid";
        Db::execute($sql, $params);
        return array('message' => "Operacion exitosa."); 
    }

    public function storeDetalle() {
        $statusCode = 200;
        $message    = 'Operacion exitosa';

        try {
            $this->validateDetalle();
            $query = "INSERT INTO comun.tbl_plan_matenimiento_actividades (iidplan_mantenimiento,iidactividad,txtcomentarios) 
                        VALUES (:iidplan_mantenimiento,:iidactividad,:vcomentarios)";
            
            Db::execute($query, $this->getParams());
        } catch (Exception $ex) {
            $statusCode = 403;
            $message = sizeof($this->errors) > 0 ? $this->errors : $ex->getMessage();
        }

        return array('message' => $message, 'statusCode' => $statusCode);
    }

    public function deleteDetalle($id) {
        $params = array('iid' => $id);
        $sql = "UPDATE comun.tbl_plan_matenimiento_actividades SET bactivo =false, dtfecha_modificacion=now() WHERE iid=:iid";
        Db::execute($sql, $params);
        return array('message' => "Operacion exitosa."); 
    }

    public function getDetalles($id) {
        $plan   = 'SELECT * FROM comun.tbl_plan_matenimiento where iid = '.$id;
        $item   =  GenericSQL::getBySQL($plan);
        $query  = 'SELECT d.iid, d.txtcomentarios, d.dtfecha_creacion, am.vclave AS clave_actividad, am.vdirigido_a, 
                    fcosto_mano_obra, fcosto_refacciones, fcosto_otro, fcosto_total, am.txtnotas_tecnicas as notas_actividad , am.txtdescripcion descripcion_actividad
                    FROM comun.tbl_plan_matenimiento_actividades AS d
                    INNER JOIN comun.tbl_actividad_mantenimiento am ON d.iidactividad = am.iid 
                    WHERE d.bactivo = true and  d.iidplan_mantenimiento = '.$id.' ORDER BY d.iid';

        $response['datos']    = (array)$item;
        $response['detalles'] =  GenericSQL::getBySQL($query);
        return $response;
    }

    ############################## Metodos Privados ##############################
    private function validate($action = 'add') {
        $data = (array)$this->request->getJsonRawBody();
        $rules = [
            'modeloId'  => 'required|numeric',
            'nombre'    => 'required',
            'ciclo'     => 'required|numeric',
            'meses'     => 'required|numeric'
        ];

        $rules      = $action == 'add' ? $rules : array_merge($rules,['id' => 'required|numeric']);
        $service    = new ServicesValidator($data, $rules);
        $this->errors = $service->validate();
        
        if(sizeof($this->errors) > 0)
            throw new ValidatorBoomException(403, "Validaciones no aprobadas");
    }

    private function getParams(){
        $data  = $this->request->getJsonRawBody();
        $params = array(
            'iidmodelo' => $data->modeloId,
            'vnombre'   => $data->nombre,
            'iciclo'    => $data->ciclo,
            'imeses'    => $data->meses,
            'vcomentarios'  => $data->comentarios ?? ''
        );
       
        return $params;
    }

    private function validateDetalle(){
        $data = (array)$this->request->getJsonRawBody();
        $rules = [
            'planMantenimientoId' => 'required|numeric|exists:tbl_plan_matenimiento,iid',
            'actividadId'         => 'required|numeric|exists:tbl_actividad_mantenimiento,iid',
        ];

        //$rules      = $action == 'add' ? $rules : array_merge($rules,['id' => 'required|numeric']);
        $service    = new ServicesValidator($data, $rules);
        $this->errors = $service->validate();
        
        if(sizeof($this->errors) > 0)
            throw new ValidatorBoomException(403, "Validaciones no aprobadas");
    }
}