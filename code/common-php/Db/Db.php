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

  public static function insert($table, $params)
  {
    $cols = implode(', ', array_keys($params)); // Obtener nombres de columnas
    $phs = ':' . str_replace(', ', ', :', $cols); // Obtener marcadores de posición para los valores
    $sql = "INSERT INTO $table ($cols) VALUES ($phs)"; // Consulta de inserción
    return self::execute($sql, $params); // Ejecutar inserción en la base de datos
  }

  public static function dep($data)
  {
      $format  = print_r('<pre>');
      $format .= print_r($data);
      $format .= print_r('</pre>');
      return $format;
  }

  public static function update($table, $params, $where)
  {
    $setClause = '';
    foreach ($params as $key => $value) {
      $setClause .= "$key = :$key, ";
    }
    $setClause = rtrim($setClause, ', '); 

    $sql = "UPDATE $table SET $setClause WHERE $where";

    return self::execute($sql, $params);
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
