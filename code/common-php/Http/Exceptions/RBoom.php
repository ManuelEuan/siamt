<?php
namespace App\Library\Http\Exceptions;

use App\Library\Http\Status;

class RBoom
{
    public static function generic($statusCode, $error, $message)
    {
        return new BoomError(
            $statusCode,
            $error,
            $message
        );
    }

    public static function notFound($messageDetails = Status::NOT_FOUND_MSG)
    {
        return new BoomError(
            Status::NOT_FOUND,
            Status::NOT_FOUND_MSG,
            $messageDetails
        );
    }

    public static function badRequest($messageDetails = Status::BAD_REQUEST_MSG)
    {
        return new BoomError(
            Status::BAD_REQUEST,
            Status::BAD_REQUEST_MSG,
            $messageDetails
        );
    }

    public static function badData($messageDetails = Status::BAD_DATA_MSG)
    {
        return new BoomError(
            Status::BAD_DATA,
            Status::BAD_DATA_MSG,
            $messageDetails
        );
    }

    public static function conflict($messageDetails = Status::CONFLICT_MSG)
    {
        return new BoomError(
            Status::CONFLICT,
            Status::CONFLICT_MSG,
            $messageDetails
        );
    }

    public static function internal($messageDetails = Status::INTERNAL_SERVER_ERROR_MSG)
    {
        return new BoomError(
            Status::INTERNAL_SERVER_ERROR,
            Status::INTERNAL_SERVER_ERROR_MSG,
            $messageDetails
        );
    }

    public static function unavailable($messageDetails = Status::SERVICE_UNAVAILABLE_MSG)
    {
        return new BoomError(
            Status::SERVICE_UNAVAILABLE,
            Status::SERVICE_UNAVAILABLE_MSG,
            $messageDetails
        );
    }
}