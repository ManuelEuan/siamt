<?php

namespace App\Controllers;

use Phalcon\Registry;

use App\Library\Http\Controllers\BaseController;
use App\Library\Misc\Utils;
use App\Models\Layers\Layer;
use App\Models\Layers\BaseLayer;
use App\Models\Territory\LocalDistricts;
use App\Models\Territory\Sections;

class LayersController extends BaseController {
	public function get()
  {
    $token = $this->di->getShared('token');
    $idUsuario = $token->getUserId();
    $permissions = $token->getPermissions();
    $anaper = $permissions['ana'];

		return Layer::findPermission($anaper);
	}
	
  public function fetchGroupedLayers()
  {
    $token = $this->di->getShared('token');
    $idUsuario = $token->getUserId();
    $permissions = $token->getPermissions();
    $anaper = $permissions['ana'];

    $filter = new Registry([
      'permissions' => $anaper
    ]);

		return Layer::fetchGroupedLayers($filter);
	}

  public function fetchBaseLayers() 
  {
		return BaseLayer::find([
      'conditions' => 'activo = TRUE',
      'order' => 'orden'
    ]);
	}
}