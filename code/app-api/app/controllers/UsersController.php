<?php

namespace app\controllers;

use Phalcon\Registry;

use App\Library\Http\Controllers\BaseController;
use App\Library\Misc\Utils;
use App\Models\Layers\Layer;
use App\Models\Layers\BaseLayer;
use App\Models\Territory\LocalDistricts;
use App\Models\Territory\Sections;
use GuzzleHttp\Client;
use GuzzleHttp\Psr7;

class UsersController extends BaseController {

	public function users()
    {

        $params=['client_id'=>'PTbV7govNXW2HJX', 'filters'=>["codes"=>"Todos", "from" =>"", "page"=>1, "search" =>"081465", "sort" => "ASC", "until"=>""]];

        $options = array(
            CURLOPT_URL => "https://vnd-balance-tool.vinden.cloud/api/movements_history",
            CURLOPT_CONNECTTIMEOUT => 0,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_SSL_VERIFYPEER => false,
            CURLOPT_SSL_VERIFYHOST => false,
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => $params,
            CURLOPT_RETURNTRANSFER => true,
//            CURLOPT_HTTPHEADER => $headers,
        );

        //$this->logger->info(json_encode($options));

        $client = new Client();
        $res = $client->request('POST', 'https://vnd-balance-tool.vinden.cloud/?client_id=PTbV7govNXW2HJX&authorize=fwZfyDyz7pOReFujepJWkxAEvel0XSfo');

        echo $res->getBody();
        die;
        $soap_do = curl_init();

        curl_setopt_array($soap_do, $options);

        $response = curl_exec($soap_do);

        echo json_encode($response);

//        return "777777";
        die;

		return Layer::findPermission($anaper);
	}
	

}