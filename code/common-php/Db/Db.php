<?php

namespace App\Library\Db;

use Phalcon\Db\Enum;
use Phalcon\Di;

class Db
{
  public static function fetch(string $sql, ?array $params = null)
  {
    return static::commonFetch($sql, $params)->fetch();
  }

  private static function commonFetch(string $sql, ?array $params = null)
  {
    $db = static::getDb();
    $pdo = $db->query($sql, $params);
    $pdo->setFetchMode(Enum::FETCH_CLASS, \stdClass::class);
    return $pdo;
  }

  public static function fetchColumn(string $sql, ?array $params = [])
  {
    $db = static::getDb();
    return $db->fetchColumn($sql, $params);
  }

  public static function fetchAll(string $sql, ?array $params = null)
  {
    $db = static::getDb();
    $pdo = $db->fetchAll($sql, Enum::FETCH_OBJ, $params);
    return $pdo;
  }

  public static function fetchOneAssoc(string $sql, ?array $params = null)
  {
    $db = static::getDb();
    $pdo = $db->fetchOne($sql, Enum::FETCH_ASSOC, $params);
    return $pdo;
  }

  public static function fetchOne(string $sql, ?array $params = null)
  {
    $db = static::getDb();
    $pdo = $db->fetchOne($sql, Enum::FETCH_OBJ, $params);
    return $pdo;
  }

  // public static function execute(string $sql, ?array $params = null)
  // {
  //   $db = static::getDb();
  //   return $db->execute($sql, $params);
  // }

  public static function execute(string $sql, ?array $params = null, $returnId = true)
  {
    $db = static::getDb();
    $result = $db->execute($sql, $params);
    
    // Obtener el ID del último registro insertado si la operación fue una inserción
    if (strpos($sql, 'INSERT') === 0 && $returnId) {
        $lastInsertId = $db->lastInsertId();
        return $lastInsertId;
    }
    
    return $result;
  }

  public static function begin()
  {
    static::getDb()->begin();
  }

  public static function commit()
  {
    static::getDb()->commit();
  }

  public static function rollback()
  {
    $db = static::getDb();
    if ($db->isUnderTransaction()) $db->rollback();
  }

  protected static function getDb()
  {
    $di = Di::getDefault();
    return $di->getShared("db");
  }
}
