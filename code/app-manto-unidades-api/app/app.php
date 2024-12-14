<?php


use Phalcon\Mvc\Micro\Collection;
use App\Controllers\PlanesController;
use App\Controllers\CatalogosController;
use App\Controllers\ActividadesController;
use App\Controllers\MantenimientosController;
use App\Controllers\EquiposCargaController;
use App\Controllers\MantoUnidadesController;

$app->mount(
    (new Collection())
    ->setHandler(MantoUnidadesController::class, true)
    ->setPrefix('/admin')
    ->get("/demo", "demo")
);

$app->mount(
    (new Collection())
    ->setHandler(CatalogosController::class, true)
    ->setPrefix('/admin/complejidad')
    ->post("/", "storeComplejidad")
    ->put("/", "updateComplejidad")
    ->delete("/{id}", "deleteComplejidad")
    ->get("/", "findComplejidad")
);

$app->mount(
    (new Collection())
    ->setHandler(CatalogosController::class, true)
    ->setPrefix('/admin/tipoConjunto')
    ->post("/", "storetipoConjunto")
    ->put("/", "updatetipoConjunto")
    ->delete("/{id}", "deletetipoConjunto")
    ->get("/", "findtipoConjunto")
);

$app->mount(
    (new Collection())
    ->setHandler(CatalogosController::class, true)
    ->setPrefix('/admin/estatus')
    /* ->post("/", "storetipoConjunto")
    ->put("/", "updatetipoConjunto")
    ->delete("/{id}", "deletetipoConjunto") */
    ->get("/", "findEstatus")
);

$app->mount(
    (new Collection())
    ->setHandler(ActividadesController::class, true)
    ->setPrefix('/admin/actividades')
    ->post("/", "store")
    ->put("/", "update")
    ->delete("/{id}", "delete")
    ->get("/", "find")
);

$app->mount(
    (new Collection())
    ->setHandler(EquiposCargaController::class, true)
    ->setPrefix('/admin/equiposCarga')
    ->post("/", "store")
    ->put("/", "update")
    ->delete("/{id}", "delete")
    ->get("/", "find")
);

$app->mount(
    (new Collection())
    ->setHandler(PlanesController::class, true)
    ->setPrefix('/admin/planes')
    ->post("/", "store")
    ->put("/", "update")
    ->delete("/{id}", "delete")
    ->get("/", "find")

    ->post("/detalles", "storeDetalle")
    ->delete("/detalles/{id}", "deleteDetalle")
    ->get("/detalles/{id}", "getDetalles")
);

$app->mount(
    (new Collection())
    ->setHandler(MantenimientosController::class, true)
    ->setPrefix('/admin/mantenimientos')
    ->post("/", "store")
    ->put("/", "update")
    ->delete("/{id}", "delete")
    ->get("/", "find")
);

