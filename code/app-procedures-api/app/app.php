<?php


use Phalcon\Mvc\Micro\Collection;
use App\Db\App;
use App\Library\Misc\Utils;
use App\Controllers\RightController;


$app->mount(
    (new Collection())
    ->setHandler(RightController::class, true)
    ->get("/right", "right")
);

