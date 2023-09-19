<?php
namespace App\Library\Http\Exceptions;

use App\Library\Http\Status;

class HttpBadRequestException extends HttpException
{

    public function __construct(int $code, string $message, ?string $details = null, \Exception $previous = null)
    {
        parent::__construct(
            Status::BAD_REQUEST,
            $code,
            $message,
            $details,
            $previous
        );
    }
}