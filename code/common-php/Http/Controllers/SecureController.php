<?php

namespace App\Library\Http\Controllers;


use Phalcon\Paginator\Adapter\QueryBuilder;
use App\Library\Http\Controllers\BaseController;
use App\Library\Http\Responses\Pagination;


class SecureController extends BaseController 
{
	public function beforeExecuteRoute($dispatcher)
	{
		error_log(json_encode('hi'),0);
	}
}
