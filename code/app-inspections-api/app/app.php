<?php

use App\Models\Territory\LocalDistricts;
use Phalcon\Mvc\Micro\Collection;
use App\Db\App;
use App\Library\Misc\Utils;
use App\Controllers\InspectorsController;
use App\Controllers\WorkloadsController;
use App\Controllers\TerritoryController;
use App\Controllers\TicketsController;

$app->mount(
    (new Collection())
    ->setHandler(InspectorsController::class, true)
    // INSPECTORES
    ->get("/inspectors/demoMultipleDemo", "demoMultipleDemo")
    ->post("/inspectors", "getInspectors")
    ->post("/inspectors/getPersonByCurp", "getPersonByCurp")
    ->get("/inspectors/getAllCategoriesInspector", "getAllCategoriesInspector")
    ->post("/inspectors/getAllSubStagesInspector", "getAllSubStagesInspector")
    ->get("/inspectors/getAllShiftsInspector", "getAllShiftsInspector")
    ->post("/inspectors/new", "createInspector")
    ->put("/inspectors", "updateInspector")
    ->delete("/inspectors/{id}", "deleteInspector")
    ->post("/inspectors/getInspectorInfo", "getInspectorInfo")
    ->post("/inspectors/getInfoProcess", "getInfoProcess")
    ->post("/inspectors/getAllFlowBySubStage", "getAllFlowBySubStage")
    ->post("/inspectors/hasFlowAfter", "hasFlowAfter")
    ->put("/inspectors/updateInspectorSubStage", "updateInspectorSubStage")
    ->post("/inspectors/insertInspectorTrace", "insertInspectorTrace")
    ->post("/inspectors/getDinamycTrace", "getDinamycTrace")

    // CARGAS DE TRABAJO
    
    // VINDEN
    ->get("/inspectors/getServiceVindenUrlDebitaciones", "getServiceVindenUrlDebitaciones")
);

$app->mount(
    (new Collection())
    ->setHandler(WorkloadsController::class, true)
    ->get("/workloads/getStructureFormWorkloads", "getStructureFormWorkloads")
);



$app->mount(
    (new Collection())
    ->setHandler(TicketsController::class, true)
    ->post("/tickets/getTickets", "getTickets")
    // ->post("/tickets/downloadTickets", "downloadTickets")
    ->get("/tickets/downloadTickets", "downloadTickets")
    // ->get("/tickets/downloadXLSX", "downloadXLSX")
    
);




