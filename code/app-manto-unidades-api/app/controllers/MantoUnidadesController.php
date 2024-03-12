<?php

namespace App\Controllers;

use Phalcon\Registry;

use App\Library\Http\Controllers\BaseController;
use App\Library\Misc\Utils;
// use App\Models\Layers\Layer;
// use App\Models\Layers\BaseLayer;
// use App\Models\Territory\LocalDistricts;
// use App\Models\Territory\Sections;

class MantoUnidadesController extends BaseController {
	public function demo()
  {
    $token = $this->di->getShared('token');
    return 'Su usuario es: ' . $token->getSubject();
	}
}