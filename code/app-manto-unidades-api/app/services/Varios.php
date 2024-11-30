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
        $show   = !empty($request->getQuery('show')) ? $request->getQuery('show') : 10;
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
            'total' => $total, 
            'total_pages'   => $totalPages,
            'current_page'  => $page,
            'last_page'     => $total
        );
    }

    /**
     * Retorna el ordenamiento que se dara en el query
     * @param Request $request
     */
    public static function ordering($request){
        $order   = !empty($request->getQuery('order')) ? $request->getQuery('order') : "desc";
        $orderBy = !empty($request->getQuery('orderBy')) ? $request->getQuery('orderBy') : "iid";
        
        return ' ORDER BY '.$orderBy.' '.$order;
    }
}