<?php

namespace App\Library\Http\Controllers;

use Phalcon\Mvc\Controller;
use Phalcon\Paginator\Adapter\QueryBuilder;

use App\Library\Http\Responses\Pagination;


class BaseController extends Controller 
{
	public function paginated($builder)
	{
		$search = $this->request->getQuery('search', 'string', null);
		$page = $this->request->getQuery('page', 'int', 1);
		$limit = $this->request->getQuery('limit', 'int', 10);
		$sortBy = $this->request->getQuery('sortBy', 'string', null);
		$sortDesc = $this->request->getQuery('sortDesc', 'bool', false);
		
		if(!empty($search)) $builder->andWhere('busqueda ILIKE :search:', [ 'search' => '%'.$search.'%']);
		if(empty($sortBy)) { 
			$builder->orderBy('id asc');
		} else {
			$builder->orderBy($sortBy.' '.($sortDesc? 'desc': 'asc'));
		}
		
		$paginator = new QueryBuilder(
			[
				"builder" => $builder,
				"limit"   => $limit,
				"page"    => $page,
			]
		);
		
		$paginated = $paginator->paginate();
		error_log(json_encode($builder->getQuery()) ,0);
		return [
			'data' => $paginated->getItems(), 
			'totalItems' => $paginated->getTotalItems(), 
			'totalPages' => $paginated->getLast()
		];
	}

    public function eventPaginated($builder)
    {
        $search = $this->request->getQuery('search', 'string', null);
        $page = $this->request->getQuery('page', 'int', 1);
        $limit = $this->request->getQuery('limit', 'int', 10);
        $sortBy = $this->request->getQuery('sortBy', 'string', null);
        $sortDesc = $this->request->getQuery('sortDesc', 'bool', false);

        if(!empty($search))
        {
            $builder->where('nombre ILIKE :search:', [ 'search' => '%'.$search.'%']);
           // $builder->orWhere('fecha_evento ILIKE :search:', [ 'search' => '%'.$search.'%']);
           // $builder->orWhere('hora_inicio ILIKE :search:', [ 'search' => '%'.$search.'%']);
        }

        if(empty($sortBy)) {
            $builder->orderBy('id asc');
        } else {
            $builder->orderBy($sortBy.' '.($sortDesc? 'desc': 'asc'));
        }

        $paginator = new QueryBuilder(
            [
                "builder" => $builder,
                "limit"   => $limit,
                "page"    => $page,
            ]
        );

        $paginated = $paginator->paginate();

        return [
            'data' => $paginated->getItems(),
            'totalItems' => $paginated->getTotalItems(),
            'totalPages' => $paginated->getLast()
        ];
    }
	
	public function paginate($builder)
	{
		$page = $this->request->getQuery('page', 'int', 1);
		$limit = $this->request->getQuery('limit', 'int', 10);
		
		$paginator = new QueryBuilder(
			[
				"builder" => $builder,
				"limit"   => $limit,
				"page"    => $page,
			]
		);
		
		$paginated = $paginator->paginate();
		
		return [
			'data' => $paginated->getItems(), 
			'totalItems' => $paginated->getTotalItems(), 
			'totalPages' => $paginated->getLast()
		];
	}
}
