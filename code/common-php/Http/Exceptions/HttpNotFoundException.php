<?php
namespace App\Library\Http\Exceptions;

use App\Library\Http\Status;

class HttpNotFoundException extends HttpException
{
    public function __construct(int $code, string $message, ?string $details = null, \Exception $previous = null)
    {
        parent::__construct(
            Status::NOT_FOUND,
            $code,
            $message,
            $details,
            $previous
        );
    }

}