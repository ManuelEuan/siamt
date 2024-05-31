<?php

namespace App\Controllers;

use Phalcon\Paginator\Adapter\QueryBuilder;
use Phalcon\Mvc\Controller;
use App\Library\Db\Db;
use \App\Library\Http\Exceptions\HttpBadRequestException;
use App\Library\Http\Controllers\BaseController;
use App\Library\Http\Responses\Pagination;
use App\Models\Modules;


class ModulesController extends BaseController 
{
	
	public function getAll()
	{
		$builder = $this
			->modelsManager
			->createBuilder()
			->from(Modules::class);
		
		return $this->paginated($builder);
	}
	
	public function create()
	{
		$obj = $this->request->getJsonRawBody();
		
		$module = new Modules();
		
		foreach (get_object_vars($obj) as $prop_name => $prop_value) {
		   $module->{$prop_name} = $prop_value;
		}
		
		if(!$module->create()){
			throw new HttpBadRequestException(202,$module->getMessages()[0]); 
		}
	}
	
	public function get(int $id)
	{
		return Modules::findFirst('id = '.$id);
	}
	
	public function update(int $id)
	{
		$obj = $this->request->getJsonRawBody();
		$module = Modules::findFirst('id = '.$id);
		foreach (get_object_vars($obj) as $prop_name => $prop_value) {
	   		$module->{$prop_name} = $prop_value;
		}
	
		if(!$module->save()){
			throw new HttpBadRequestException(202,$module->getMessages()[0]); 
		}
	}

    public function getPermissionsOfModule()
	{
	// 	$obj = $this->request->getJsonRawBody();
    //     var_dump($id);
        $data = $this->request->getJsonRawBody();
        $sql = "SELECT 
            id,
            nombre,
            descripcion,
            siglas,
            idmodulo,
            activo
            FROM usuario.permiso
            WHERE activo='t' AND idmodulo = '$data->id'
        ";
        // $params = array('idmodulo' => $data->id);
        $permissions = Db::fetchAll($sql);
        return $permissions;
	}
	
	public function activate(int $id)
	{
		Modules::activate([$id]);
	}
	
	public function deactivate(int $id)
	{
		Modules::deactivate([$id]);
	}
	
	public function delete(int $id)
	{
		Modules::remove([$id]);
	}
	
	public function batch()
	{
		$request = $this->request->getJsonRawBody();
		if(empty($request->operation) || empty($request->data))
		{
			throw new HttpBadRequestException(200,'Hay un problema con su solicitud');
		}
		
		switch($request->operation)
		{
			case 'activate':
				Modules::activate($request->data);
				break;
			case 'deactivate':
				Modules::deactivate($request->data);
				break;
			case 'delete':
				Modules::remove($request->data);
				break;
			default:
				throw new HttpBadRequestException(201,'Hay un problema con su solicitud');
				
		}
	}

	public function createPermission()
	{
		$data = $this->request->getJsonRawBody();
		$sql = "INSERT INTO usuario.permiso (nombre, descripcion, siglas, idmodulo) VALUES (:nombre, :descripcion, :siglas, :idmodulo)";
		$params = array('nombre' => $data->nombre, 'descripcion' => $data->descripcion, 'siglas' => $data->siglas, 'idmodulo' => $data->idmodulo);
		$permiso = Db::execute($sql, $params);
		return $permiso;
	}

	public function updatePermission(){
		$data = $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
        // var_dump($data);exit;
		Db::begin();
       
        $sql = 'UPDATE usuario.permiso SET 
                nombre=:nombre,
                descripcion=:descripcion,
                fecha_modificacion=:fecha_modificacion
            WHERE id=:id
        ';
        $params = array(
            'nombre'  => $data->nombre,
            'descripcion' => $data->descripcion,
            'fecha_modificacion' => date('Y-m-d H:i:s'), // Formato de fecha correcto
            'id'      => $data->id,
        ); // Parámetros para la actualización del inspector

        Db::execute($sql, $params); // Ejecutar actualización del inspector en la base de datos
        Db::commit(); // Confirmar transacción en la base de datos

        return array('message' => 'El permiso ha sido actualizado.');
	}
}