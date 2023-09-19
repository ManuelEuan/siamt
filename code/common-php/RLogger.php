<?php
declare(strict_types = 1);
namespace App\Library;

class RLogger
{
    public static function info(string $string)
    {
        $date = date("Y/m/d H:i:s");
        $title = "${date} [info]";
        
        return fwrite(fopen('php://stdout', 'w'), "${title}: ${string}".PHP_EOL);
    }
}