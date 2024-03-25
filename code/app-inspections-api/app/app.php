<?php

use App\Models\Territory\LocalDistricts;
use Phalcon\Mvc\Micro\Collection;
use App\Db\App;
use App\Library\Misc\Utils;
use App\Controllers\InspectorsController;

$app->mount(
    (new Collection())
    ->setHandler(InspectorsController::class, true)
    ->post("/inspectors", "getInspectors")
    ->post("/inspectors/getPersonByCurp", "getPersonByCurp")
);