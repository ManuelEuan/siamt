<?php

namespace App\Library\Di;
use Phalcon\Filter\FilterFactory;
use Phalcon\Di\Service;
class MicroDi extends \Phalcon\Di
{
    public function __construct()
    {
        parent::__construct();

        //$filter = new FilterFactory();

        $this->services = [
            //"annotations"=>        new Service("Phalcon\\Annotations\\Adapter\\Memory", true),
            //"assets"=>             new Service("Phalcon\\Assets\\Manager", true),
            //"crypt"=>              new Service("Phalcon\\Crypt", true),
            //"cookies"=>            new Service("Phalcon\\Http\\Response\\Cookies", true),
            //"dispatcher"=>         new Service("Phalcon\\Mvc\\Dispatcher", true),
            //"escaper"=>            new Service("Phalcon\\Escaper", true),
            //"eventsManager"=>      new Service("Phalcon\\Events\\Manager", true),
            //"flash"=>              new Service("Phalcon\\Flash\\Direct", true),
            //"flashSession"=>       new Service("Phalcon\\Flash\\Session", true),
            //"filter"=>             new Service($filter->newInstance(), true),
            //"modelsManager"=>      new Service("Phalcon\\Mvc\\Model\\Manager", true),
            //"modelsMetadata"=>     new Service("Phalcon\\Mvc\\Model\\MetaData\\Memory", true),
            "request"=>            new Service("Phalcon\\Http\\Request", true),
            "response"=>           new Service("Phalcon\\Http\\Response", true),
            "router"=>             new Service("Phalcon\\Mvc\\Router", true),
            //"security"=>           new Service("Phalcon\\Security", true),
            //"tag"=>                new Service("Phalcon\\Tag", true),
            //"transactionManager"=> new Service("Phalcon\\Mvc\\Model\\Transaction\\Manager", true),
            //"url"=>                new Service("Phalcon\\Url", true)
        ];
    }
}