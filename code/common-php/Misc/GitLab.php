<?php
namespace App\Library\Misc;

class GitLab
{
    public static function isAuthorizedEvent($secret)
    {
        $key = null;
        if(array_key_exists('HTTP_X_GITLAB_TOKEN', $_SERVER))
        {

            $key = $_SERVER['HTTP_X_GITLAB_TOKEN'];
        }

        return !empty($key) && $key === $secret;
    }

}