<?php

namespace App\Library\Util;
use DateTime;
use Phalcon\Crypt;
use Phalcon\Di;
use App\Library\Http\Middlewares\SecurityMiddleware;
use Symfony\Bridge\Twig\Mime\BodyRenderer;
use Symfony\Component\Mailer\Mailer;
use Symfony\Component\Mailer\Transport\Smtp\EsmtpTransport;
use Symfony\Bridge\Twig\Mime\TemplatedEmail;
use Symfony\Component\Mime\Address;
use Symfony\Component\Mime\Email;
use Twig\Environment;
use Twig\Extra\CssInliner\CssInlinerExtension;
use Twig\Loader\FilesystemLoader;
use Vokuro\GenericSQL\Common\NonWorkingDay;

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

    public static function encryptURLImage($txtEncripted){
        return  "/api/admin/images?a=". Util::encryptTxt($txtEncripted);
    }

    public static function sendMail($asunto, $para, array $paraCC, $contenido, $adjunto, $template, array $context =[], &$mensajeReturn)
    {
        try {
            $di = DI::getDefault();
            $mailer = $di->getShared('internetFailturesMailer');
            $smtp = $di->getConfig()->internetFailtures->sender;
            if($mailer)
            {
                $email = (new TemplatedEmail())
                    ->from(new Address($smtp->email, $smtp->name))
                    ->to(new Address($para))
                    ->cc(...$paraCC)
                    ->subject($asunto);

                if($contenido != null && $contenido != "")
                    $email->html($contenido);
                else if($template != null && $template != "")
                {
                    $twig = $di->getShared('twig');
                    $email->htmlTemplate($template);
                    $email->context($context);

                    $twigBodyRenderer = new BodyRenderer($twig);
                    $twigBodyRenderer->render($email);
                }


                $mailer->send($email);
            }
            return true;
        } catch (Exception $e) {
            error_log($e->getMessage());
            $mensajeReturn = "ocurrio un error al enviar mensaje.";
            return false;
        }

    }

    public static function agregarDias($fecha, int $dias, bool $inhabiles)
    {
        $fecha = new DateTime($fecha);
        $diasAgregados = 0;

        while ($diasAgregados < $dias) {
            $fecha->modify('+1 day');
            // Verifica si es un día de semana (lunes a viernes)
            if ($fecha->format('N') < 6) {
                if($inhabiles == true) {
                    $día = NonWorkingDay::findFirst([
                        "dfecha = '".$fecha->format('Y-m-d')."' AND bactivo"
                    ]);
                    if(!$día)
                        $diasAgregados++;
                }
                else
                    $diasAgregados++;
            }
        }

        return $fecha;
    }
}