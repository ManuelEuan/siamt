<?php


namespace App\Library\Http\Middlewares;


use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Misc\Utils;
use App\Library\Security\TokenWrapper;
use App\Library\Security\Acl;
use Exception;
use Phalcon\Events\Event;
use Phalcon\Http\Request;
use Phalcon\Mvc\Micro;
use Phalcon\Mvc\Micro\MiddlewareInterface;
use Phalcon\Security\JWT\Signer\Hmac;
use Phalcon\Security\JWT\Token\Parser;
use Phalcon\Security\JWT\Validator;

class SecurityMiddleware implements MiddlewareInterface
{
    private string $alg;
    private string $secret;
    private array $whitelist;

    public function __construct(string $alg, string $secret, array $whitelist = array())
    {
        $this->alg = $alg;
        $this->secret = $secret;

        $this->whitelist = $whitelist;
    }

    public function beforeExecuteRoute(Event $event, Micro $app) 
    {
        // $handler = $app->getActiveHandler();
        // $lazyLoader = $handler[0];
        // $methodName = $handler[1];
        // 
        //     
        //     $lazyLoader->callMethod($methodName,1);
    }
    
    public function beforeHandleRoute(Event $event, Micro $app) {
        $request = $app->getSharedService('request');

        if(in_array($request->getMethod().':'. $request->getURI(true),$this->whitelist)){
            return true;
        }
        $token = Utils::getBearerToken();

        if(empty($token))
        {
            throw new HttpUnauthorizedException(97, 'Token de seguridad es requerido');
        }

        $signer = new Hmac($this->alg);
        $parser = new Parser();
        $t = null;
        try {
            $t = $parser->parse($token);
            $validator = new Validator($t);
            $validator
                ->validateSignature($signer, $this->secret)
                ->validateExpiration(time());
        }catch (Exception $e){
            throw new HttpUnauthorizedException(98, 'Token de seguridad invalido');
        }

        $tokenWrapper = new TokenWrapper($t);
        if($tokenWrapper->getDomainName() !== md5(Utils::getRequestDomain()) ||
            $tokenWrapper->getIpAddress() !== md5(Utils::getClientIp())
        )
        {
            //throw new HttpUnauthorizedException(99, 'Token de seguridad invalido');
        }

        $app->getDI()->setShared('token', $tokenWrapper);

        $acl = new Acl($tokenWrapper);
        $app->getDI()->setShared('acl', $acl);

        return true;
    }

    public function call(Micro $application)
    {
        return true;
    }

}