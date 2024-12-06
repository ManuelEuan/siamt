<?php

namespace App\Services;

use Exception;
use Vokuro\GenericSQL\GenericSQL;

class Varios {

    /**
     * Retorna los resultados paginados
     * @param string $query
     * @param Request $request
     */
    public static function paginate($query, $request) {
        $show   = !empty($request->getQuery('itemsPerPage')) ? $request->getQuery('itemsPerPage') : 10;
        $page   = !empty($request->getQuery('page')) ? (int)$request->getQuery('page') : 1;

        $offset = ($page - 1) * $show;
        $total  = GenericSQL::getBySQL($query);
        $total  = sizeof($total);
        $from   = ($offset + 1);
        $to     = min($offset + $show, $total);
        $totalPages = ceil($total / $show);
    
        $query.=' LIMIT '.$show.' OFFSET '.$offset;
        $items = GenericSQL::getBySQL($query);
    
        return array( 
            'items' => $items,
            'from'  => $from, 
            'to'    => $to, 
            'totalItems' => $total, 
            'totalPages'   => $totalPages,
            'current_page'  => $page,
            'last_page'     => $total
        );
    }

    /**
     * Retorna el ordenamiento que se dara en el query
     * @param Request $request
     */
    public static function ordering($request, $tabla){
        if (!empty($request->getQuery('sortBy'))){
            $orderBy    = $request->getQuery('sortBy');
            $order      = $request->getQuery('sortDesc');

            $query = ' ';
            foreach ($orderBy as $key => $value) {
                $desc = $order[$key] == 'false' ? 'asc' : 'desc';
                $query .= $tabla.'.'.$value.' '.$desc.',';
            }

            $query = substr($query, 0, -1);
            return ' ORDER BY '.$query;
        }
        else {
            return  ' ORDER BY iid desc';
        }
       
        
        return ' ORDER BY '.$orderBy.' '.$order;
    }
}