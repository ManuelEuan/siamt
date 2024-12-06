<?php

namespace App\Controllers;

use Exception;
use App\Library\Db\Db;
use Vokuro\GenericSQL\GenericSQL;
use App\Library\Http\Controllers\BaseController;
use App\Library\Http\Exceptions\ValidatorBoomException;
use App\Services\Validator as ServicesValidator;
use App\Services\Varios;

class CatalogosController extends BaseController {
    /**
     * @var array
     */
    protected $errors;

    ############################## Complejidad ##############################
    public function storeComplejidad(){
        $statusCode = 200;
        $message    = 'Operacion exitosa';

        try {
            $this->validate('add');
            $query = "INSERT INTO comun.tbl_cat_complejidad(txtdescripcion, txtcomentarios) VALUES (:vdescripcion, :vcomentarios)";
            Db::execute($query, $this->getParams());
        } catch (Exception $ex) {
            $statusCode = 403;
            $message = sizeof($this->errors) > 0 ? $this->errors : $ex->getMessage();
        }

        return array('message' => $message, 'statusCode' => $statusCode);
    }

    public function updateComplejidad() {
        $statusCode = 200;
        $message    = 'Operacion exitosa';

        try {
            $this->validate('update');
            $query  = "UPDATE comun.tbl_cat_complejidad SET txtdescripcion =:vdescripcion,txtcomentarios =:vcomentarios,dtfecha_modificacion=now() WHERE iid=:id";
            $data   = $this->request->getJsonRawBody();
            $params = array_merge($this->getParams(), ['id' => $data->id]);
            
            Db::execute($query, $params);
        } catch (Exception $ex) {
            $statusCode = 403;
            $message = sizeof($this->errors) > 0 ? $this->errors : $ex->getMessage();
        }

        return array('message' => $message, 'statusCode' => $statusCode);
    }

    public function deleteComplejidad($id) {
        $params = array('iid' => $id);
        $sql = "UPDATE comun.tbl_cat_complejidad SET bactivo =false, dtfecha_modificacion=now() WHERE iid=:iid";
        Db::execute($sql, $params);
        return array('message' => "Operacion exitosa."); 
    } 

    public function findComplejidad() {
        $id             = $this->request->getQuery('id');
        $descripcion    = $this->request->getQuery('descripcion');
        $comentarios    = $this->request->getQuery('comentarios');
        $condicional    = 'WHERE';
        
        $query = 'SELECT iid,txtdescripcion,txtcomentarios FROM comun.tbl_cat_complejidad as complejidad';

        if(!empty($id)) {
            $query .= "  $condicional iid =".$id;
            $condicional = 'AND';
        }
        if(!empty($descripcion)) {
            $query .= "  $condicional txtdescripcion ILIKE '%".$descripcion."%'";
            $condicional = 'AND';
        }
        if(!empty($comentarios)) {
            $query .= " $condicional txtcomentarios ILIKE '%".$comentarios."%'";
        }

        $query.= Varios::ordering($this->request, 'complejidad' );
        if(!empty($this->request->getQuery('paginate')) && $this->request->getQuery('paginate') == 'true') {
            return Varios::paginate($query, $this->request);
        }
        else{
            $items = GenericSQL::getBySQL($query);
            return array('items' => $items,);
        }
    }

    ############################## Tipo conjunto ##############################
    public function storeTipoConjunto(){
        $statusCode = 200;
        $message    = 'Operacion exitosa';

        try {
            $this->validate('add');
            $query = "INSERT INTO comun.tbl_cat_tipo_conjunto(txtdescripcion, txtcomentarios) VALUES (:vdescripcion, :vcomentarios)";
            Db::execute($query, $this->getParams());
        } catch (Exception $ex) {
            $statusCode = 403;
            $message = sizeof($this->errors) > 0 ? $this->errors : $ex->getMessage();
        }

        return array('message' => $message, 'statusCode' => $statusCode);
    }

    public function updateTipoConjunto() {
        $statusCode = 200;
        $message    = 'Operacion exitosa';

        try {
            $this->validate('update');
            $query  = "UPDATE comun.tbl_cat_tipo_conjunto SET txtdescripcion =:vdescripcion,txtcomentarios =:vcomentarios,dtfecha_modificacion=now() WHERE iid=:id";
            $data   = $this->request->getJsonRawBody();
            $params = array_merge($this->getParams(), ['id' => $data->id]);
            
            Db::execute($query, $params);
        } catch (Exception $ex) {
            $statusCode = 403;
            $message = sizeof($this->errors) > 0 ? $this->errors : $ex->getMessage();
        }

        return array('message' => $message, 'statusCode' => $statusCode);
    }

    public function deleteTipoConjunto($id) {
        $params = array('iid' => $id);
        $sql = "UPDATE comun.tbl_cat_tipo_conjunto SET bactivo =false, dtfecha_modificacion=now() WHERE iid=:iid";
        Db::execute($sql, $params);
        return array('message' => "Operacion exitosa."); 
    }

    public function findTipoConjunto() {
        $id             = $this->request->getQuery('id');
        $descripcion    = $this->request->getQuery('descripcion');
        $comentarios    = $this->request->getQuery('comentarios');
        $condicional    = 'WHERE';

        $query = 'SELECT iid, txtdescripcion, txtcomentarios FROM comun.tbl_cat_tipo_conjunto as conjunto';
        if(!empty($id)) {
            $query .= "  $condicional iid =".$id;
            $condicional = 'AND';
        }
        if(!empty($descripcion)) {
            $query .= "  $condicional txtdescripcion ILIKE '%".$descripcion."%'";
            $condicional = 'AND';
        }
        if(!empty($comentarios)) {
            $query .= " $condicional txtcomentarios ILIKE '%".$comentarios."%'";
        }

        $query.= Varios::ordering($this->request, 'conjunto');
        if(!empty($this->request->getQuery('paginate')) && $this->request->getQuery('paginate') == 'true') {
            return Varios::paginate($query, $this->request);
        }
        else{
            $items = GenericSQL::getBySQL($query);
            return array('items' => $items,);
        }
    }

    ############################## Metodos Privados ##############################
    private function validate($action = 'add') {
        $data       = (array)$this->request->getJsonRawBody();
        $rules      = [ 'descripcion'=> 'required',];
        $rules      = $action == 'add' ? $rules : array_merge($rules,['id' => 'required|numeric']);
        $service    = new ServicesValidator($data, $rules);
        $this->errors = $service->validate();
        
        if(sizeof($this->errors) > 0)
            throw new ValidatorBoomException(403, "Validaciones no aprobadas");
    }

    private function getParams(){
        $data  = $this->request->getJsonRawBody();
        $params = array(
            'vdescripcion'  => $data->descripcion,
            'vcomentarios'  => $data->comentarios,
        );
       
        return $params;
    }
}