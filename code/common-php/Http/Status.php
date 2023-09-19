<?php
namespace App\Library\Http;

class Status
{
    const OK                    = 200;
    const CREATED               = 201;
    const NO_CONTENT            = 204;
    const MOVED_PERMANENTLY     = 301;
    const BAD_REQUEST           = 400;
    const UNAUTHORIZED          = 401;
    const FORBIDDEN             = 403;
    const NOT_FOUND             = 404;
    const BAD_DATA              = 422;
    const INTERNAL_SERVER_ERROR = 500;

    const OK_MSG                    = 'OK';
    const CREATED_MSG               = 'Created';
    const NO_CONTENT_MSG            = 'No Content';
    const MOVED_PERMANENTLY_MSG     = 'Moved Permanently';
    const BAD_REQUEST_MSG           = 'Bad Request';
    const UNAUTHORIZED_MSG          = 'Unauthorized';
    const FORBIDDEN_MSG             = 'Forbidden';
    const NOT_FOUND_MSG             = 'Not Found';
    const BAD_DATA_MSG             = 'Unprocessable Entity';
    const INTERNAL_SERVER_ERROR_MSG = 'Internal Server Error';
}