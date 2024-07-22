<?php
namespace Vokuro\GenericSQL\User;
use App\Library\Db\SiamtDb as Db;
use Phalcon\Mvc\Model\Query\Builder;

class Modules
{
    public static function getAllModules($onlyParents = false)
    {
        $sqlParents = "SELECT DISTINCT idpadre
                FROM usuario.modulo
                WHERE idpadre IS NOT NULL;";
        $parents = Db::fetchAll($sqlParents);

        $sql = "SELECT 
            id, nombre, idpadre
        FROM 
            usuario.modulo
        WHERE 
            activo='t'";

        if ($onlyParents) {
            $sql = $sql . " AND idpadre IS NULL";

            // Obtener los IDs de padres
            $parentIds = array_column($parents, 'idpadre');

            // Excluir los resultados obtenidos de $parents
            if (!empty($parentIds)) {
                $sql = $sql . " AND id NOT IN (" . implode(",", $parentIds) . ")";
            }
        }

        $modules = Db::fetchAll($sql);
        return $modules;
    }
}