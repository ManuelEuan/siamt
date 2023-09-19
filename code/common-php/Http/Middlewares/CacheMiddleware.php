<?php


namespace App\Library\Http\Middlewares;


use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Misc\Utils;
use App\Library\Security\TokenWrapper;
use Exception;
use Phalcon\Events\Event;
use Phalcon\Http\Request;
use Phalcon\Mvc\Micro;
use Phalcon\Mvc\Micro\MiddlewareInterface;
use Phalcon\Security\JWT\Signer\Hmac;
use Phalcon\Security\JWT\Token\Parser;
use Phalcon\Security\JWT\Validator;
use Phalcon\Helper\Json;

class CacheMiddleware implements MiddlewareInterface
{
    private string $id;
    
    private int $ttl;
    private array $whitelist;
    
    public function __construct(string $id, int $ttl = 60, array $whitelist = array() )
    {
        $this->id = $id;
        $this->ttl = $ttl;
        
        $this->whitelist = $whitelist;
    }
    
    public function beforeExecuteRoute(Event $event, Micro $app) 
    {
        error_log("CacheMiddleware - beforeExecuteRoute", 0);        
        $request = $app->getSharedService('request');
        
        if(!$this->isRequestValid($request)) {
            return true;
        }
        
        $key = $this->getKey($request);
        
        $redis = $app->getSharedService('redis');
        $returnValue = $redis->get($key);
        
        if($returnValue !== false) {
            error_log("CacheMiddleware - Cached response ".$request->getURI(true), 0);
            
            $app->response
                ->setContentType('application/json', 'utf-8')
                ->setContent($returnValue)
                ->send();
            
            return false;
        }
        
    }

    public function afterExecuteRoute(Event $event, Micro $app) 
    {
        error_log("CacheMiddleware - afterExecuteRoute", 0);
        $request = $app->getSharedService('request');
        if(!$this->isRequestValid($request)) {
            return true;
        }
        
        $returnValue = $app->getReturnedValue();
        $key = $this->getKey($request);
        
        $redis = $app->getSharedService('redis');
        error_log("CacheMiddleware - Caching response for ".$request->getURI(true), 0);
        
        $redis->set($key, Json::encode($returnValue), $this->ttl);
            
    }

    public function call(Micro $application)
    {
        error_log("CacheMiddleware - call", 0);
        return true;
    }

    private function isRequestValid($request) {
        if(!$request->isGet()) {
            return false;
        }
        
        if(in_array($request->getMethod().':'. $request->getURI(true),$this->whitelist)){
            return false;
        }
        
        return true;
    }
    
    private function getKey($request) {
        return md5($request->getMethod().':'.$this->id.':'. $request->getURI());
    }
}