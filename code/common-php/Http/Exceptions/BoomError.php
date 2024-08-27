<?php
namespace App\Library\Http\Exceptions;


use App\Library\Http\Exceptions\ExceptionFormatter;

class BoomError extends \RuntimeException
{
    protected $httpCode = 0;
    protected $error = null;
    protected $message = null;
    protected $details = null;

    public function __construct(int $httpCode, string $error, string $message, $details = null, \Exception $previous = null)
    {
        $this->httpCode = $httpCode;
        $this->error = $error;
        $this->message = $message;
        $this->details = $details;

        parent::__construct($this->message, $this->httpCode, $previous);
    }

    public function getHttpCode(): int
    {
        return $this->httpCode;
    }

    public function getDetails(): ?string
    {
        return $this->details;
    }

    public function format(): ? array
    {
        return [
            'statusCode' => $this->httpCode,
            'error' => $this->error,
            'message' => $this->message,
            'details' => $this->details
        ];
    }
}