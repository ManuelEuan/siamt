<?php

namespace App\Controllers;

use App\Library\Http\Controllers\BaseController;
use App\Library\Misc\Utils;

class DebitsController extends BaseController
{
    public function getServiceVindenUrlDebitaciones()
    {
        if(!$_SESSION['vinden']['token']){
            Utils::getTokenVinden();
        }
        $baseUrl = $_SESSION['vinden']['baseUrl'];
        $clientId = $_SESSION['vinden']['clientId'];
        $token = $_SESSION['vinden']['token'];
        $url = $baseUrl . '?client_id=' . $clientId . '&authorize=' . $token;
        return $url;
    }
}