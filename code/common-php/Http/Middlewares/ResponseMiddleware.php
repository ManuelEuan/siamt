<?php

namespace App\Library\Http\Middlewares;

use App\Library\Http\Exceptions\HttpException;
use App\Library\Http\Exceptions\BoomException;
use App\Library\Http\Status;
use Phalcon\Helper\Json;
use \Phalcon\Mvc\Micro ;
use Phalcon\Mvc\Micro\MiddlewareInterface;

class ResponseMiddleware implements MiddlewareInterface
{

    const KEY_CODE = 'error';
    const KEY_MESSAGE = 'message';
    const KEY_DETAILS = 'details';

    public function call(Micro $app)
    {
        $returnValue = $app->getReturnedValue();
        if(is_object($returnValue) || is_array($returnValue) || is_string($returnValue))
        {
            if($app->request->isPost()) {
                $app->response->setStatusCode(Status::CREATED);
            } else {
                $app->response->setStatusCode(Status::OK);
            }
        }
        else
        {
            $app->response->setStatusCode(Status::NO_CONTENT);
        }


        $this->setContent($app, $returnValue, !is_string($returnValue));
    }

    public function setContent(Micro $app, $content, $autoencode = true)
    {
        $app->response->setContentType('application/json', 'utf-8');
        $app->response->setContent($autoencode? Json::encode($content) : $content);
    }

    public function handler(Micro $app)
    {
        $app->response->send();
    }

    public function notFound(Micro $app)
    {
        $app->response->setStatusCode(Status::NOT_FOUND);
        $this->setContent($app,  self::formatError(Status::NOT_FOUND,Status::NOT_FOUND_MSG));
    }

    // public function error(Micro $app, $exception)
    // {
    //     $httpCode = $exception instanceof HttpException? $exception->getHttpCode() : Status::INTERNAL_SERVER_ERROR;
    //     $app->response->setStatusCode($httpCode);
    //     $this->setContent($app, self::formatError($exception->getCode(),$exception->getMessage()));
    //     $this->handler($app);
    // }

    public function error(Micro $app, $exception)
    {
        
        $isBoomException = $exception instanceof BoomException;
        $isHttpException = $exception instanceof HttpException;
        $content = '';
        if ($isBoomException) {
            $content = $exception->format();
        } else {
            $errorDetails = $isHttpException ? $exception->getDetails() : null;
            $content = self::formatError($exception->getCode(), $exception->getMessage(), $errorDetails);
        }
        
        $httpCode = ($isHttpException || $isBoomException) ? $exception->getHttpCode() : Status::INTERNAL_SERVER_ERROR;
        
        $app->response->setStatusCode($httpCode);
        $this->setContent($app, $content);
        $this->handler($app);
    }

    public static function format(\Exception $e)
    {
        return self::formatError($e->getCode(), $e->getMessage(), $e->getTrace());
    }

    public static function formatError($errorCode, $errorMessage, $errorDetails = null)
    {
        $appError = [
            self::KEY_CODE => $errorCode,
            self::KEY_MESSAGE => $errorMessage,
            self::KEY_DETAILS => ($errorDetails != null)? $errorDetails : $errorMessage
        ];

        return $appError;
    }

    public static function register(Micro $app): ResponseMiddleware
    {
        $responseMiddleware = new ResponseMiddleware();

        $app->after($responseMiddleware);

        $app->notFound(function () use($app,$responseMiddleware) {
            $responseMiddleware->notFound($app);
        });
        // $app->error(function ($e) use($app,$responseMiddleware) {
        //     $responseMiddleware->error($app, $e);
        // });
        $app->setResponseHandler(function () use($app,$responseMiddleware) {
            $responseMiddleware->handler($app);
        });

        return $responseMiddleware;
    }
}