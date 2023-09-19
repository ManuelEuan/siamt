<?php
namespace App\Library\Misc;

use Phalcon\Di;

class Redis extends \Redis
{
    public function publishToQueue($queue, $value)
    {
        $this->lPush("$queue-l", $value);
        $this->publish("$queue-c", '');
    }
}