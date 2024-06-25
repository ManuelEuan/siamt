<?php

namespace App\Library\Db;

use Phalcon\Db\Enum;
use Phalcon\Di;

class InspectionsDb extends Db
{
  protected static function getDb()
  {
    $di = Di::getDefault();
    return $di->getShared("db_inspecciones");
  }
}