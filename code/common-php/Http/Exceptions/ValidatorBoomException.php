<?php
namespace App\Library\Http\Exceptions;

use App\Library\Http\Status;

class ValidatorBoomException extends BoomException
{
    public function __construct(string $code, string $message, array $details = [], \Exception $previous = null)
    {
        parent::__construct(
            Status::BAD_DATA,
            $code,
            $message,
            $details,
            $previous
        );
    }
}