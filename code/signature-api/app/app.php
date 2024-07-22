<?php


use App\Controllers\FirmsController;
use Phalcon\Mvc\Micro\Collection;
use App\Db\App;

$app->mount(
    (new Collection())
        ->setHandler(FirmsController::class, true)
        ->get("/getDinamycCount", "getDinamycCount")
        ->post("/getTemplateById", "getTemplateById")
        ->post("/getFirmById", "getFirmById")
        ->get("/getAllTemplates", "getAllTemplates")
        ->get("/getAllFirms", "getAllFirms")
        ->post('/templates/new', 'createTemplate')
        ->put('/templates', 'updateTemplate')
        ->post('/saveFirmRegisterByUser', 'saveFirmRegisterByUser')
        ->put('/updateFirmRegisterByUser', 'updateFirmRegisterByUser')
);