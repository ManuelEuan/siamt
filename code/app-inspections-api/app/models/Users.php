<?php

namespace App\Models;

use Phalcon\Mvc\Model;
use Phalcon\Mvc\Model\ResultsetInterface;
use Vokuro\GenericSQL\GenericSQL;
use App\Library\Db\Db;

class Users extends Model {
	public function initialize() {
		$this->setSource('usuario');
		$this->setSchema('usuario');
	}
	
    public static function fetchAll() {
		return self::find([
            'conditions' => 'activo = TRUE',
			'columns' => [
                'id',
                'usuario',
                'nombre',
                'apepat',
                'apemat',
                'correo',
                'activo',
                'fecha_creacion',
                'fecha_modificacion'
            ]
		]);
	}
	
	public static function findByDomain($domainId) {
		$sql = "SELECT u.id, u.usuario, u.nombre, u.apepat, u.apemat, u.correo, u.activo, u.fecha_creacion, u.fecha_modificacion FROM usuario.usuario_dominio AS ud LEFT JOIN usuario.usuario AS u ON (ud.idusuario=u.id) WHERE ud.iddominio = :domainId";
		
		return Db::fetchAll($sql, ['domainId' => $domainId]);
	}

	public function jsonSerialize() : array {
		return [
			'id' => $this->id,
			'usuario' => $this->usuario,
			'nombre' => $this->nombre,
			'apepat' => $this->apepat,
			'apemat' => $this->apemat,
			'correo' => $this->correo,
			'activo' => $this->activo,
			'fecha_creacion' => $this->fecha_creacion,
			'fecha_modificacion' => $this->fecha_modificacion
		];
	}

    public static function getAll($filters) {
        $sql = "SELECT *,CONCAT(nombre,' ',apepat,' ',apemat) AS nombre_completo FROM usuario.usuario LIMIT ".$filters->itemsPerPage." OFFSET ".($filters->currentPage-1)*$filters->itemsPerPage;
        $sqlTotales = "SELECT COUNT(*) AS total FROM usuario.usuario";
        $total = GenericSQL::getBySQL($sqlTotales)[0]->total;
        $res = GenericSQL::getBySQL($sql);
        $pages = ceil((integer)$total/(integer)$filters->itemsPerPage);
        $result = array(
            "data" => $res,
            "total" => $total,
            "pages" => $pages
        );
        return $result;
    }

    public static function getEditInfo($id) {
        $user = parent::findFirst($id);
        $roles =GenericSQL::getBySQL("SELECT * FROM usuario.perfil_usuario WHERE idusuario = ".$id);
        $rolesIds = array();
        $permisosRoles = array();
        foreach ($roles as $role) {
            $permisosRol = GenericSQL::getBySQL("SELECT * FROM usuario.perfil_permiso WHERE idperfil = ".$role->id);

            $rolesIds[] = $role->idperfil;
        }
        return array(
            'usuario' => $user,
            'perfiles' => $rolesIds
        );
    }
}