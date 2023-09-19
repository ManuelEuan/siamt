<?php
namespace App\Library\Http\Exceptions;


use App\Library\Http\Exceptions\ExceptionFormatter;

class BoomException extends \RuntimeException
{
    protected $httpCode = 0;

    protected $details = null;

    public function __construct(int $httpCode, ?string $code = null, ?string $message = null, ?array $details = [], \Exception $previous = null)
    {
        $this->httpCode = $httpCode;
        $this->message = $message;
        $this->details = $details;
        
        parent::__construct($this->message, $this->httpCode, $previous);
        $this->code = $code;
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
            'code' => $this->code,
            'message' => $this->message,
            'details' => $this->details
        ];
    }
}