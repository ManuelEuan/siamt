<?php

namespace app\controllers;

use Phalcon\Registry;

use App\Library\Http\Controllers\BaseController;
use App\Library\Misc\Utils;
use App\Models\Layers\Layer;
use App\Models\Layers\BaseLayer;
use App\Models\Territory\LocalDistricts;
use App\Models\Territory\Sections;

class UsersController extends BaseController {

	public function users()
    {

        return "777777";
        die;

		return Layer::findPermission($anaper);
	}
	

}