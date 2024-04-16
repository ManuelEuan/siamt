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
    ->post("/inspectors/getPersonByDinamycSearch", "getPersonByDinamycSearch")
    ->get("/inspectors/getAllCategoriesInspector", "getAllCategoriesInspector")
    ->get("/inspectors/getAllProcessesInspector", "getAllProcessesInspector")
    ->get("/inspectors/getAllStagesInspector", "getAllStagesInspector")
    ->post("/inspectors/getAllSubStagesInspector", "getAllSubStagesInspector")
    ->get("/inspectors/getAllShiftsInspector", "getAllShiftsInspector")
    ->post("/inspectors/new", "createInspector")
    ->put("/inspectors", "updateInspector")
    ->delete("/inspectors/{id}", "deleteInspector")
    ->post("/inspectors/getInspectorInfo", "getInspectorInfo")
);

$app->mount(
    (new Collection())
    ->setHandler(WorkloadsController::class, true)
    ->get("/workloads/getAllZonesInspector", "getAllZonesInspector")
);

$app->mount(
    (new Collection())
    ->setHandler(PersonsController::class, true)
    ->get("/persons/getAllSexesPerson", "getAllSexesPerson")
    ->get("/persons/getAllTypePhones", "getAllTypePhones")
    ->get("/persons/getAllLadas", "getAllLadas")
    ->get("/persons/getAllCivilStatusPerson", "getAllCivilStatusPerson")
    ->post("/persons/new", "createPerson")
    ->put("/persons/update", "updatePerson")
    ->post("/persons/direction/new", "createDirection")
    ->post("/persons/getPersonAddresses", "getPersonAddresses")
    ->post("/persons/getPersonPhones", "getPersonPhones")
    ->post("/persons/updateCurrentAddress", "updateCurrentAddress")
    ->post("/persons/updateCurrentPhone", "updateCurrentPhone")
    ->post("/persons/deleteAddress", "deleteAddress")
    ->post("/persons/deletePhone", "deletePhone")
    ->put("/persons/direction", "updateAddress")
    ->post("/persons/phone/new", "createPhone")
    ->put("/persons/phone", "updatePhone")
);


$app->mount(
    (new Collection())
    ->setHandler(TerritoryController::class, true)
    ->get("/territory/getAllPostalCodes", "getAllPostalCodes")
    ->post("/territory/getMunicipalityAndEntityByPostalCode", "getMunicipalityAndEntityByPostalCode")
    ->post("/territory/getColoniesByPostalCode", "getColoniesByPostalCode")
);

