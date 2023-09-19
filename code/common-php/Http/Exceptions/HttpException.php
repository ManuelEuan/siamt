<?php
namespace App\Library\Http\Exceptions;


use App\Library\Http\Exceptions\ExceptionFormatter;

class HttpException extends \RuntimeException
{
    protected $httpCode = 0;

    protected $details = null;

    public function __construct(int $httpCode, ?string $code = null, ?string $message = null, ?string $details = null, \Exception $previous = null)
    {
        $this->httpCode = $httpCode;
        $this->code = $code;
        $this->message = $message;
        $this->details = $details == null? ($previous == null? null : $previous->getTraceAsString()) : $details;

        parent::__construct($this->message, $this->code, $previous);
    }

    public function getHttpCode(): int
    {
        return $this->httpCode;
    }

    public function getDetails(): ?string
    {
        return $this->details;
    }


}