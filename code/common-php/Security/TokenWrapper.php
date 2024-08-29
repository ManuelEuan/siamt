<?php
namespace App\Library\Security;

use Phalcon\Security\JWT\Token\Enum;

class TokenWrapper
{
    private $token;

    public function __construct($token)
    {
        $this->token = $token;
    }

    public function getUserId()
    {
        return $this->token->getClaims()->get(JwtBuilder::USER_ID);
    }

    public function getDomainId()
    {
        return $this->token->getClaims()->get(JwtBuilder::DOMAIN_ID);
    }

    public function getDomainName()
    {
        return $this->token->getClaims()->get(JwtBuilder::DOMAIN_NAME);
    }

    public function getIpAddress()
    {
        return $this->token->getClaims()->get(JwtBuilder::IP_ADDRESS);
    }

    public function getModules()
    {
        return array_keys($this->token->getClaims()->get(JwtBuilder::PERMISSIONS));
    }

    public function getPermissions()
    {
        return $this->token->getClaims()->get(JwtBuilder::PERMISSIONS);
    }
    
    public function hasPermission($module, $permission = null)
    {
        $permissions = $this->getPermissions();
        
        if(array_key_exists($module,$permissions)){
            if(is_null($permission) || in_array($permission, $permissions[$module])){
                return true;
            }
        }
        
        return false;
    }
    
    public function getSubject()
    {
        return $this->token->getClaims()->get(Enum::SUBJECT);
    }

    public function getInspectorId()
    {
        return $this->token->getClaims()->get(JwtBuilder::INSPECTOR_ID);
    }
}