<?php

namespace App\Controllers;
use App\Library\Http\Controllers\BaseController;
use App\Library\Http\Exceptions\CustomError;
use App\Library\Http\Exceptions\HttpBadRequestException;
use App\Library\Http\Exceptions\HttpNotFoundException;
use App\Library\Http\Exceptions\RBoom;
use App\Library\Util\Util;


class ImagesController extends BaseController
{
    public function get(){


            date_default_timezone_set ( "America/Monterrey" );
            setlocale(LC_ALL, 'es_ES');

            $a = $this->request->get("a");
            $b = $this->request->get("b");
            if(!$a)
                throw new HttpBadRequestException(400, "Parámetros incorrectos");

            $file_rout = Util::decryptTxt($a);

            $file = $b;

            $ruta = $a."".$file;

            echo $file_rout;
            die;
            if (!file_exists($file_rout)) {
                throw new HttpNotFoundException(404, "No se encuentra el archivo");
            }

            echo 7777;
            die;
            $split = explode(".", $file);
//            print_r($split);
//            die;

//            print_r(mime_content_type($ruta));
//            die;
            header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
            header('Content-Disposition: inline; filename="'.basename($ruta).'"');
            header('Accept-Ranges: bytes');
            header('Content-type: ' . mime_content_type($ruta));
            header('Content-length: ' . filesize($ruta));
            readfile($ruta);
            die();


    }
}