<?php

namespace App\Controllers;

use Exception;
use App\Library\Db\Db;
use App\Services\Varios;
use Vokuro\GenericSQL\GenericSQL;
use App\Library\Http\Controllers\BaseController;
use App\Services\Validator as ServicesValidator;
use App\Library\Http\Exceptions\ValidatorBoomException;

class ActividadesController extends BaseController {
    /**
     * @var array
     */
    protected $errors;

    public function find() {
        $actividadId    = $this->request->getQuery('id');
        $clave          = $this->request->getQuery('clave');
        $modeloId       = $this->request->getQuery('modeloId');
        $dirigido_a     = $this->request->getQuery('dirigido_a');
        $tipoConjuntoId = $this->request->getQuery('tipoConjuntoId');
        $complejidadId  = $this->request->getQuery('complejidadId');
        $condicional    = 'WHERE';
        
        $query = 'SELECT * FROM comun.tbl_actividad_mantenimiento';
        if(!empty($actividadId)) {
            $query .= "  $condicional iid = ".$actividadId;
            $condicional = 'AND';
        }
        if(!empty($tipoConjuntoId)) {
            $query .= "  $condicional iidtipo_conjunto = ".$tipoConjuntoId;
            $condicional = 'AND';
        }
        if(!empty($complejidadId)) {
            $query .= "  $condicional iidcomplejidad = ".$complejidadId;
            $condicional = 'AND';
        }
        if(!empty($modeloId)) {
            $query .= " $condicional iidmodelo = ".$modeloId;
            $condicional = 'AND';
        }
        if(!empty($clave)) {
            $query .= " $condicional vclave = ".$clave;
            $condicional = 'AND';
        }
        if(!empty($dirigido_a)) {
            $query .= " $condicional vdirigido_a = ".$dirigido_a;
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
            $query = "INSERT INTO comun.tbl_actividad_mantenimiento 
                        (iidtipo_conjunto,iidcomplejidad,iidmodelo,vclave,vdirigido_a,txtdescripcion,ikms,imeses,itolerancia_kms,itolerancia_meses,fcosto_mano_obra,fcosto_refacciones,fcosto_otro,fcosto_total,txtnotas_tecnicas) 
                        VALUES (:itipo_conjunto,:icomplejidad,:imodelo,:vclave,:vdirigido_a,:vdescripcion,:ikms,:imeses,:itolerancia_kms,:itolerancia_meses,:fcosto_mano_obra,:fcosto_refacciones,:fcosto_otro,:fcosto_total,:vnotas_tecnicas)";
            
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
            $query = "UPDATE comun.tbl_actividad_mantenimiento SET 
                        iidtipo_conjunto    = :itipo_conjunto,
                        iidcomplejidad      = :icomplejidad,
                        iidmodelo           = :imodelo,
                        vclave              = :vclave,
                        vdirigido_a         = :vdirigido_a,
                        ikms                = :ikms,
                        imeses              = :imeses,
                        txtdescripcion      = :vdescripcion,
                        itolerancia_kms     = :itolerancia_kms,
                        itolerancia_meses   = :itolerancia_meses,
                        fcosto_mano_obra    = :fcosto_mano_obra,
                        fcosto_refacciones  = :fcosto_refacciones,
                        fcosto_otro         = :fcosto_otro,
                        fcosto_total        = :fcosto_total,
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
        $sql = "UPDATE comun.tbl_actividad_mantenimiento SET bactivo =false, dtfecha_modificacion=now() WHERE iid=:iid";
        Db::execute($sql, $params);
        return array('message' => "Operacion exitosa."); 
    }

    ############################## Metodos Privados ##############################
    private function getParams(){
        $data  = $this->request->getJsonRawBody();
        $params = array(
            'itipo_conjunto'    => $data->tipoConjuntoId,
            'icomplejidad'      => $data->complejidadId,
            'imodelo'           => $data->modeloId,
            'vclave'            => $data->clave,
            'vdirigido_a'       => $data->dirigido_a ?? 'vehiculos',
            'ikms'              => $data->kms,
            'imeses'            => $data->meses ?? null,
            'vdescripcion'      => $data->descripcion ?? null,
            'itolerancia_kms'   => $data->tolerancia_kms ?? null,
            'itolerancia_meses' => $data->tolerancia_meses ?? null,
            'fcosto_mano_obra'  => $data->costo_mano_obra ?? 0,
            'fcosto_refacciones'=> $data->costo_refacciones ?? 0,
            'fcosto_otro'       => $data->costo_otro ?? 0,
            'fcosto_total'      => $data->costo_total ?? 0,
            'vnotas_tecnicas'   => $data->notas_tecnicas ?? null,
        );
       
        return $params;
    }

    private function validate($action = 'add') {
        $data = (array)$this->request->getJsonRawBody();
        $rules = [
            'tipoConjuntoId'=> 'required|numeric|exists:tbl_cat_tipo_conjunto,iid',
            'complejidadId' => 'required|numeric|exists:tbl_cat_complejidad,iid',
            'modeloId'      => 'required|numeric',
            'clave'         => 'required',
            'descripcion'   => 'required',
            'dirigido_a'    => 'required|in:vehiculo,equipo_de_carga',
            'kms'           => 'required',
        ];

        $rules      = $action == 'add' ? $rules : array_merge($rules,['id' => 'required|numeric']);
        $service    = new ServicesValidator($data, $rules);
        $this->errors = $service->validate();
        
        if(sizeof($this->errors) > 0)
            throw new ValidatorBoomException(403, "Validaciones no aprobadas");
    }
}