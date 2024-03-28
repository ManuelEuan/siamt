<?php

use App\Models\Territory\LocalDistricts;
use Phalcon\Mvc\Micro\Collection;
use App\Db\App;
use App\Library\Misc\Utils;
use App\Controllers\InspectorsController;
use App\Controllers\WorkloadsController;
use App\Controllers\PersonsController;
use App\Controllers\TerritoryController;

$app->mount(
    (new Collection())
    ->setHandler(InspectorsController::class, true)
    ->post("/inspectors", "getInspectors")
    ->post("/inspectors/getPersonByCurp", "getPersonByCurp")
    ->get("/inspectors/getAllCategoriesInspector", "getAllCategoriesInspector")
    ->get("/inspectors/getAllStagesInspector", "getAllStagesInspector")
    ->get("/inspectors/getAllShiftsInspector", "getAllShiftsInspector")
    ->post("/inspectors/new", "createInspector")
    ->put("/inspectors", "updateInspector")
    ->delete("/inspectors/{id}", "deleteInspector")
    ->post("/inspectors/getInspectorInfo", "getInspectorInfo")
);

$app->mount(
    (new Collection())
    ->setHandler(WorkloadsController::class, true)
    // ->post("/inspectors", "getInspectors")
    // ->post("/inspectors/getPersonByCurp", "getPersonByCurp")
    // ->get("/inspectors/getAllCategoriesInspector", "getAllCategoriesInspector")
    // ->get("/inspectors/getAllStagesInspector", "getAllStagesInspector")
    ->get("/workloads/getAllZonesInspector", "getAllZonesInspector")
    // ->post("/inspectors/new", "createInspector")
    // ->put("/inspectors", "updateInspector")
    // ->delete("/inspectors/{id}", "deleteInspector")
    // ->post("/inspectors/getInspectorInfo", "getInspectorInfo")
);

$app->mount(
    (new Collection())
    ->setHandler(PersonsController::class, true)
    ->get("/persons/getAllSexesPerson", "getAllSexesPerson")
    ->get("/persons/getAllCivilStatusPerson", "getAllCivilStatusPerson")
    ->post("/persons/new", "createPerson")
);


$app->mount(
    (new Collection())
    ->setHandler(TerritoryController::class, true)
    ->get("/territory/getAllPostalCodes", "getAllPostalCodes")
);

