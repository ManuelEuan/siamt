<?php

namespace App\Library\Http\Responses;


class Pagination
{
	public $data;
	public $totalItems;
	public $totalPages;
	
	public function __construct($data, $totalItems, $totalPages)
	{
		$this->data = $data;
		$this->totalItems = $totalItems;
		$this->totalPages = $totalPages;
	}
}