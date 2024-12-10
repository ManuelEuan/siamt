<?php

namespace App\Controllers;

use Exception;
use App\Library\Db\Db;
use Vokuro\GenericSQL\GenericSQL;
use App\Library\Http\Controllers\BaseController;
use App\Library\Http\Exceptions\ValidatorBoomException;
use App\Services\Validator as ServicesValidator;
use App\Services\Varios;

class CorrectivosController extends BaseController {

    /**
     * @var array
     */
    protected $errors;

    public function find() {
        $correctivoId    = $this->request->getQuery('id');
        $filtros        = $this->request->getQuery('filters');
        $condicional    = 'AND';

        $query = 'SELECT correctivo.*, estatus.txtdescripcion as estatus
                    FROM comun.tbl_mantenimiento_correctivo as correctivo
                    inner join comun.tbl_cat_estatus estatus on correctivo.iidestatus = estatus.iid
                    WHERE correctivo.bactivo = true  ';
        if(!empty($correctivoId)) {
            $query .= "  $condicional correctivo.iid = ".$correctivoId;
            $condicional = 'AND';
        }

        if(!empty($filtros)) {
            $valores = json_decode($filtros);

            if($valores->estatus_id != '' ) {
                $query .= " $condicional correctivo.iidestatus = ".$valores->estatus_id;
                $condicional = 'AND';
            }
        }

        $query.= Varios::ordering($this->request, 'tbl_mantenimiento_correctivo');
        if(empty($this->request->getQuery('paginate')) && $this->request->getQuery('paginate') == 'false') {
            $items = GenericSQL::getBySQL($query);
            return array('items' => $items);    
        }

        $items = Varios::paginate($query, $this->request);
        $temp = array();
        foreach ($items['items'] as $value) {
            $value->costo   = $value->fcosto_total;
            $value->ingreso = $value->dtfecha_ingreso;
            $value->salida  = $value->dtfecha_salida;

            $ingreso      = strtotime($value->dtfecha_ingreso);
            $value->dtfecha_ingreso = date('d/m/Y', $ingreso);

            if(!is_null($value->dtfecha_salida)) {
                $salida      = strtotime($value->dtfecha_salida);
                $value->dtfecha_salida = date('d/m/Y', $salida);
            }
            $value->fcosto_total    = '$'.number_format($value->fcosto_total, 2);

            array_push($temp, $value);
        }
        $items['items'] = $temp;
        return $items;
    }

    public function store() {
        $statusCode = 200;
        $message    = 'Operacion exitosa';

        try {
            $this->validate('add');
            $query = "INSERT INTO comun.tbl_mantenimiento_correctivo 
                        (iidestatus,iidunidad,dtfecha_ingreso,dtfecha_salida,txtlugar,fcosto_total,txtdescripcion,txtcomentarios,txtarchivo) 
                        VALUES (:iidestatus,:iidunidad,:dtfecha_ingreso,:dtfecha_salida,:txtlugar,:fcosto_total,:txtdescripcion,:txtcomentarios,:txtarchivo)";

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
            $query = "UPDATE comun.tbl_mantenimiento_correctivo SET
                        iidestatus      = :iidestatus,
                        iidunidad       = :iidunidad,
                        dtfecha_ingreso = :dtfecha_ingreso,
                        dtfecha_salida  = :dtfecha_salida,
                        txtlugar        = :txtlugar,
                        fcosto_total    = :fcosto_total,
                        txtdescripcion  = :txtdescripcion,
                        txtcomentarios  = :txtcomentarios,
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
        $sql = "UPDATE comun.tbl_mantenimiento_correctivo SET bactivo =false, dtfecha_modificacion=now() WHERE iid=:iid";
        Db::execute($sql, $params);
        return array('message' => "Operacion exitosa."); 
    }

    ############################## Metodos Privados ##############################
    private function getParams(){
        $data  = $this->request->getJsonRawBody();
        $params = array(
            'iidestatus'    => $data->estatusId,
            'iidunidad'     => $data->unidadId,
            'dtfecha_ingreso' => $data->fecha_ingreso,
            'dtfecha_salida'  => $data->fecha_salida ?? null,
            'txtlugar'      => $data->lugar,
            'fcosto_total'  => $data->costo_total,
            'txtdescripcion'=> $data->descripcion ?? null,
            'txtcomentarios'=> $data->comentarios ?? null,
        );

        return $params;
    }

    private function validate($action = 'add') {
        $data = (array)$this->request->getJsonRawBody();
        $rules = [
            'estatusId' => 'required|numeric|exists:tbl_cat_estatus,iid',
            'unidadId'  => 'required|numeric',
            'lugar'     => 'required',
            'fecha_ingreso' => 'required',
            'costo_total'   => 'required',
        ];

        $rules      = $action == 'add' ? $rules : array_merge($rules,['id' => 'required|numeric']);
        $service    = new ServicesValidator($data, $rules);
        $this->errors = $service->validate();
        
        if(sizeof($this->errors) > 0)
            throw new ValidatorBoomException(403, "Validaciones no aprobadas");
    }
}