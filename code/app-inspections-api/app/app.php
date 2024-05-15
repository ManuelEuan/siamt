<?php

use App\Models\Territory\LocalDistricts;
use Phalcon\Mvc\Micro\Collection;
use App\Db\App;
use App\Library\Misc\Utils;
use App\Controllers\InspectorsController;
use App\Controllers\WorkloadsController;
use App\Controllers\PersonsController;
use App\Controllers\ProcessController;
use App\Controllers\TerritoryController;

$app->mount(
    (new Collection())
    ->setHandler(InspectorsController::class, true)
    ->post("/inspectors", "getInspectors")
    ->post("/inspectors/getPersonByCurp", "getPersonByCurp")
    ->get("/inspectors/getAllCategoriesInspector", "getAllCategoriesInspector")

    ->post("/inspectors/getAllSubStagesInspector", "getAllSubStagesInspector")
    ->get("/inspectors/getAllShiftsInspector", "getAllShiftsInspector")
    ->post("/inspectors/new", "createInspector")
    ->put("/inspectors", "updateInspector")
    ->delete("/inspectors/{id}", "deleteInspector")
    ->post("/inspectors/getInspectorInfo", "getInspectorInfo")
    // PROCESOS
    ->post("/inspectors/getInfoProcess", "getInfoProcess")
    ->post("/inspectors/getAllFlowBySubStage", "getAllFlowBySubStage")
    ->post("/inspectors/hasFlowAfter", "hasFlowAfter")
    // ->post("/inspectors/getInfoBySubStage", "getInfoBySubStage")
    ->put("/inspectors/updateInspectorSubStage", "updateInspectorSubStage")
    ->post("/inspectors/insertInspectorTrace", "insertInspectorTrace")
    ->post("/inspectors/getDinamycTrace", "getDinamycTrace")
    
    // VINDEN
    ->get("/inspectors/getServiceVindenUrlDebitaciones", "getServiceVindenUrlDebitaciones")
);

$app->mount(
    (new Collection())
    ->setHandler(WorkloadsController::class, true)
    ->get("/workloads/getAllZonesInspector", "getAllZonesInspector")
);

$app->mount(
    (new Collection())
    ->setHandler(PersonsController::class, true)
    ->get("/persons/getAllSexes", "getAllSexes")
    ->get("/persons/getAllTypesPhone", "getAllTypesPhone")
    ->get("/persons/getAllLadaIdentifiers", "getAllLadaIdentifiers")
    ->get("/persons/getAllCivilStatus", "getAllCivilStatus")
    ->post("/persons/new", "createPerson")
    ->put("/persons/update", "updatePerson")
    ->post("/persons/direction/new", "createAddress")
    ->post("/persons/getPersonAddresses", "getPersonAddresses")
    ->post("/persons/getPersonPhones", "getPersonPhones")
    ->post("/persons/getGeneralPersonData", "getGeneralPersonData")
    ->post("/persons/updateCurrentAddress", "updateCurrentAddress")
    ->post("/persons/updateCurrentPhone", "updateCurrentPhone")
    ->post("/persons/deleteAddress", "deleteAddress")
    ->post("/persons/deletePhone", "deletePhone")
    ->put("/persons/direction", "updateAddress")
    ->post("/persons/phone/new", "createPhone")
    ->put("/persons/phone", "updatePhone")
    ->post("/persons/getPersonByDinamycSearch", "getPersonByDinamycSearch")
);

$app->mount(
    (new Collection())
    ->setHandler(TerritoryController::class, true)
    ->get("/territory/getAllPostalCodes", "getAllPostalCodes")
    ->post("/territory/getMunicipalityAndEntityByPostalCode", "getMunicipalityAndEntityByPostalCode")
    ->post("/territory/getColoniesByPostalCode", "getColoniesByPostalCode")
);

$app->mount(
    (new Collection())
    ->setHandler(ProcessController::class, true)
    ->post("/process/dinamycRegisterInProcess", "dinamycRegisterInProcess")
    ->post("/process/getInfoBySubStage", "getInfoBySubStage")
    ->post("/process/newDinamycSubStage", "newDinamycSubStage")
    ->get("/process/getAllModules", "getAllModules")
    ->get("/process/getAllProcess", "getAllProcess")
    ->get("/process/getAllStages", "getAllStages")
    ->get("/process/getAllSubStages", "getAllSubStages")
    ->post("/process/getProcessWithStagesAndSubstages", "getProcessWithStagesAndSubstages")
    ->post("/process/getFlowByProcess", "getFlowByProcess")
    ->post("/process/newRegisterInProcess", "newRegisterInProcess")
    ->post("/process/getAllNextSubStagesEnabled", "getAllNextSubStagesEnabled")
    ->put("/process/updateRegisterInProcess", "updateRegisterInProcess")
    ->get("/process/getStructureFirstForm", "getStructureFirstForm")
    

    
);

