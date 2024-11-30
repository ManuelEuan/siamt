<?php

namespace App\Controllers;

use Exception;
use App\Library\Db\Db;
use App\Services\Varios;
use Vokuro\GenericSQL\GenericSQL;
use App\Library\Http\Controllers\BaseController;
use App\Services\Validator as ServicesValidator;
use App\Library\Http\Exceptions\ValidatorBoomException;

class EquiposCargaController extends BaseController {
    /**
     * @var array
     */
    protected $errors;

    public function find() {
        $equipoId       = $this->request->getQuery('id');
        $num_economico  = $this->request->getQuery('numero_economico');
        $numero_serie   = $this->request->getQuery('numero_serie');
        $modelo         = $this->request->getQuery('modelo');
        $marca          = $this->request->getQuery('marca');
        $condicional    = 'WHERE';
        
        $query = 'SELECT * FROM comun.tbl_equipos_carga';
        if(!empty($equipoId)) {
            $query .= "  $condicional iid = ".$equipoId;
            $condicional = 'AND';
        }
        if(!empty($num_economico)) {
            $query .= "  $condicional inumero_economico = ".$num_economico;
            $condicional = 'AND';
        }
        if(!empty($numero_serie)) {
            $query .= " $condicional vnumero_serie = ".$numero_serie;
            $condicional = 'AND';
        }
        if(!empty($modelo)) {
            $query .= " $condicional vmodelo = ".$modelo;
            $condicional = 'AND';
        }
        if(!empty($marca)) {
            $query .= " $condicional vmarca = ".$marca;
            $condicional = 'AND';
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
            $query = "INSERT INTO comun.tbl_equipos_carga 
                        (inumero_economico,vnumero_serie,vmodelo,vmarca,fcapacidad_carga,fconsumo_corriente,fvoltaje_operacion,ihoras_operacion,txtnotas_tecnicas) 
                        VALUES (:inumero_economico,:vnumero_serie,:vmodelo,:vmarca,:fcapacidad_carga,:fconsumo_corriente,:fvoltaje_operacion,:ihoras_operacion,:vnotas_tecnicas)";
            
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
            $query = "UPDATE comun.tbl_equipos_carga SET 
                        inumero_economico   = :inumero_economico,
                        vnumero_serie       = :vnumero_serie,
                        vmodelo             = :vmodelo,
                        vmarca              = :vmarca,
                        fcapacidad_carga    = :fcapacidad_carga,
                        fconsumo_corriente  = :fconsumo_corriente,
                        fvoltaje_operacion  = :fvoltaje_operacion,
                        ihoras_operacion    = :ihoras_operacion,
                        txtnotas_tecnicas   = :vnotas_tecnicas,
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
        $sql = "UPDATE comun.tbl_equipos_carga SET bactivo =false, dtfecha_modificacion=now() WHERE iid=:iid";
        Db::execute($sql, $params);
        return array('message' => "Operacion exitosa."); 
    }

    ############################## Metodos Privados ##############################
    private function validate($action = 'add') {
        $data = (array)$this->request->getJsonRawBody();
        $rules = [
            'numero_economico'  => 'required|numeric',
            'numero_serie'      => 'required',
            'modelo'            => 'required',
            'marca'             => 'required',
            'capacidad_carga'   => 'required|numeric',
            'consumo_corriente' => 'required|numeric',
            'voltaje_operacion' => 'required|numeric',
            'horas_operacion'   => 'required|numeric',
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
            'inumero_economico' => $data->numero_economico,
            'vnumero_serie'     => $data->numero_serie,
            'vmodelo'           => $data->modelo,
            'vmarca'            => $data->marca,
            'fcapacidad_carga'  => $data->capacidad_carga,
            'fconsumo_corriente'=> $data->consumo_corriente ?? 0,
            'fvoltaje_operacion'=> $data->voltaje_operacion ?? 0,
            'ihoras_operacion'  => $data->horas_operacion ?? 0,
            'vnotas_tecnicas'   => $data->notas_tecnicas ?? null,
        );
       
        return $params;
    }
}