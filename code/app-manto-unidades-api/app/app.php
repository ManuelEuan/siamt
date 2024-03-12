<?php

use App\Models\Territory\LocalDistricts;
use Phalcon\Mvc\Micro\Collection;
use App\Db\App;
use App\Library\Misc\Utils;
use App\Controllers\MantoUnidadesController;

$app->mount(
    (new Collection())
    ->setHandler(MantoUnidadesController::class, true)
    ->get("/demo", "demo")
);