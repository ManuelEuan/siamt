<?php
namespace App\Library\Security;

use Phalcon\Collection;
use Phalcon\Helper\Base64;
use Phalcon\Helper\Json;
use Phalcon\Security\JWT\Builder;
use Phalcon\Security\JWT\Exceptions\ValidatorException;
use Phalcon\Security\JWT\Token\Enum;
use Phalcon\Security\JWT\Token\Item;
use Phalcon\Security\JWT\Token\Signature;
use Phalcon\Security\JWT\Token\Token;

class JwtBuilder extends Builder
{
    const IP_ADDRESS = 'ipa';
    const USER_ID = 'uid';
    const DOMAIN_ID = 'did';
    const DOMAIN_NAME = 'dna';
    const USER_FULL_NAME = 'ufn';
    const PERMISSIONS = 'prm';

    const INSPECTOR_ID = 'inspid';

    public function setIpAddress($ip)
    {
        return $this->setClaim(JwtBuilder::IP_ADDRESS, $ip);
    }
    public function setUserId($id)
    {
        return $this->setClaim(JwtBuilder::USER_ID, $id);
    }
    public function setDomainId($id)
    {
        return $this->setClaim(JwtBuilder::DOMAIN_ID, $id);
    }
    public function setDomain($name)
    {
        return $this->setClaim(JwtBuilder::DOMAIN_NAME, $name);
    }
    public function setUserFullName($name)
    {
        return $this->setClaim(JwtBuilder::USER_FULL_NAME, $name);
    }
    public function setPermissions($data)
    {
        return $this->setClaim(JwtBuilder::PERMISSIONS, $data);
    }
    public function setInspectorId($id)
    {
        return $this->setClaim(JwtBuilder::INSPECTOR_ID, $id);
    }

}