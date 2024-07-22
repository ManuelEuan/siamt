<?php

namespace App\Library\Misc;

class Utils
{
    public static function getRequestDomain()
    {
        $domain = explode(':', $_SERVER['HTTP_HOST']);
        return $domain[0];
    }
    public static function getBearerToken()
    {
        if (isset($_SERVER['HTTP_AUTHORIZATION'])) {
            $headers = trim($_SERVER["HTTP_AUTHORIZATION"]);
            if (preg_match('/Bearer\s(\S+)/', $headers, $matches)) {
                return $matches[1];
            }
        }
        return null;
    }

    public static function getClientIp()
    {
        return $_SERVER['HTTP_CLIENT_IP']
            ?? $_SERVER["HTTP_CF_CONNECTING_IP"]
            ?? $_SERVER['HTTP_X_FORWARDED']
            ?? $_SERVER['HTTP_X_FORWARDED_FOR']
            ?? $_SERVER['HTTP_FORWARDED']
            ?? $_SERVER['HTTP_FORWARDED_FOR']
            ?? $_SERVER['REMOTE_ADDR']
            ?? null;;
    }

    // FUNCIÓN PARA GENERAR TOKEN
    public static function getTokenVinden()
    {
        if (!isset($_SESSION['vinden']['token']) || !isset($_SESSION['vinden']['vinden_expiration']) || round(microtime(true) * 1000) > $_SESSION['vinden']['vinden_expiration']) {
            // Si no hay un token almacenado en la sesión o el token ha expirado, generar uno nuevo
            $baseUrl = 'https://vnd-closeloop-balancetool.vinden.cloud';
            $userName = 'imdut@vinden.cloud';
            $pass = 'B7LqOIJFTQJ7MCobvc50';
            $clientId = 'PTbV7govNXW2HJX';
            try {
                $postData = http_build_query([
                    'user' => $userName,
                    'password' => $pass
                ]);
                $ch = curl_init();
                curl_setopt($ch, CURLOPT_URL, "$baseUrl/api/authorize");
                curl_setopt($ch, CURLOPT_POST, 1);
                curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

                $response = curl_exec($ch);
                $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
                curl_close($ch);
                if ($httpCode >= 200 && $httpCode < 300) {
                    $responseData = json_decode($response, true);
                    $_SESSION['vinden'] = [
                        'baseUrl' => $baseUrl,
                        'clientId' => $clientId,
                        'token' => $responseData['token'],
                        'vinden_expiration' => $responseData['token_expiration_instant'],
                    ];
                    return $_SESSION;
                } else {
                    throw new \Exception('Error al obtener el token. Código HTTP: ' . $httpCode);
                }
            } catch (\Exception $e) {
                echo 'Error al obtener el token: ' . $e->getMessage();
                return null;
            }
        }
    }
}
