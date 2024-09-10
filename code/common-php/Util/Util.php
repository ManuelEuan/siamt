<?php

namespace App\Library\Util;
use Phalcon\Crypt;
use Phalcon\Di;

class Util
{

    public static function encryptTxt($txt = ''){
        $cfg = Di::getDefault()->getConfig();
        $crypt = new Crypt();
        $crypt->setCipher('aes-256-ctr');
        //$encrypted = $crypt->encrypt($txt, $key);
        $encrypted = $crypt->encryptBase64($txt, $cfg->app->keyDocumentos, true);
        //$logger->info("encrypted: ".$encrypted);
        return $encrypted;
    }

    public static function decryptTxt($txtEncripted = ''){
        $cfg = Di::getDefault()->getConfig();
        $crypt = new Crypt();
        $crypt->setCipher('aes-256-ctr');
        //$decrypted = $crypt->decrypt($txtEncripted, $key);
        $decrypted = $crypt->decryptBase64($txtEncripted, $cfg->app->keyDocumentos, true);
        //$logger->info("decrypted: ".$decrypted);
        return $decrypted;
    }

}