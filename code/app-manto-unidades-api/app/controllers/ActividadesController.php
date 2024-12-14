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
        $modelo_id      = $this->request->getQuery('modelo_id');
        $filtros        = $this->request->getQuery('filters');
        $condicional    = 'AND';

        $query = 'SELECT actividad.*, complejidad.txtdescripcion as complejidad, conjunto.txtdescripcion as conjunto
                    FROM comun.tbl_actividad_mantenimiento as actividad
                    inner join comun.tbl_cat_complejidad complejidad on complejidad.iid = actividad.iidcomplejidad 
                    inner join comun.tbl_cat_tipo_conjunto conjunto on conjunto.iid  = actividad.iidtipo_conjunto 
                    WHERE actividad.bactivo = true  ';
        if(!empty($actividadId)) {
            $query .= "  $condicional actividad.iid = ".$actividadId;
            $condicional = 'AND';
        }
        if(!empty($modelo_id)) {
            $query .= " $condicional actividad.iidmodelo = ".$modelo_id;
        }

        if(!empty($filtros)) {
            $valores = json_decode($filtros);
            
            if($valores->clave != '' ) {
                $query .= " $condicional actividad.vclave ILIKE '%".$valores->clave."%'";
                $condicional = 'AND';
            }
            if($valores->modelo_id != '' ) {
                $query .= " $condicional actividad.iidmodelo = ".$valores->modelo_id;
                $condicional = 'AND';
            }
            if($valores->complejidad_id != '' ) {
                $query .= " $condicional actividad.iidcomplejidad = ".$valores->complejidad_id;
                $condicional = 'AND';
            }
            if($valores->dirigido_a != '' ) {
                $query .= " $condicional actividad.vdirigido_a = '".$valores->dirigido_a."'";
            }
        }

        $query.= Varios::ordering($this->request, 'actividad');
        if(empty($this->request->getQuery('paginate')) && $this->request->getQuery('paginate') == 'false') {
            $items = GenericSQL::getBySQL($query);
            return array('items' => $items);    
        }

        $items = Varios::paginate($query, $this->request);
        $temp = array();
        foreach ($items['items'] as $value) {
            $value->mano_obra   = '$'.number_format($value->fcosto_mano_obra, 2);
            $value->refacciones = '$'.number_format($value->fcosto_refacciones, 2);
            $value->otro        = '$'.number_format($value->fcosto_otro, 2);
            $value->fcosto_total= '$'.number_format($value->fcosto_total, 2);
            
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
            'imeses'            => (int)$data->meses ?? null,
            'vdescripcion'      => $data->descripcion ?? null,
            'itolerancia_kms'   => (int)$data->tolerancia_kms ?? null,
            'itolerancia_meses' => (int)$data->tolerancia_meses ?? null,
            'fcosto_mano_obra'  => (float)$data->costo_mano_obra ?? 0,
            'fcosto_refacciones'=> (float)$data->costo_refacciones ?? 0,
            'fcosto_otro'       => (float)$data->costo_otro ?? 0,
            'fcosto_total'      => (float)$data->costo_total ?? 0,
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