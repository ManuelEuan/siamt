const { Redis } = require('../common-njs/redis');
const { onShutdown } = require('../common-njs/shutdown');
const jwt = require("jsonwebtoken");
const uws = require('uWebSockets.js');

const ws_port = 3000;
const waitingTimeForAuth = 5 * 1000; //5 secs
const QUEUE_NAME = process.env.RD_WSS_QUEUE;
const JWT_SECRET = process.env.JWT_SECRET;

const decoder = new TextDecoder('utf-8');
const redis = new Redis({
    host: process.env.RD_HOST,
    port: process.env.RD_PORT
});

const MSG_TYPE = Object.freeze({
    AUTH_REQUIRED: "AUTH_REQUIRED",
    AUTH_REQUEST: "AUTH_REQUEST",
    AUTH_SUCCESS: "AUTH_SUCCESS",
    AUTH_FAILURE: "AUTH_FAILURE",
    INVALID_REQUEST: "INVALID_REQUEST",
    CLIENT_CONNECTED: "CLIENT_CONNECTED",
    CLIENT_DISCONNECTED: "CLIENT_DISCONNECTED"
});

const clients = new Map();
let count = 0;

redis.subscribetoQueue(QUEUE_NAME, (err, res) => {
    if(err) {
        console.log("Error while retrieving value");
    }
    if(res){
        console.log("The retrieved value is: " + res);
        db.query('SELECT NOW()', (err,res) => {
            console.log(err,res);
        });
        console.log(res);
    }
});

function msg(type) {
    return JSON.stringify({ type: type});
}
let waitingForAuth = function(ws){
    if(!ws.isAuthenticated){
        console.log("Client hasn't been authenticated, closing connection.");
        ws.end();
    } else {
        console.log("Client has been authenticated");
    }
}

const app = uws./*SSL*/App({
    key_file_name: 'misc/key.pem',
    cert_file_name: 'misc/cert.pem',
}).ws('/*', {

    idleTimeout: 40,
    maxBackpressure: 1024 * 2014,
    maxPayloadLength: 16 * 1024,
    compression: uws.DISABLED,

    open: (ws) => {
        console.log('A Websocket connected!');

        setTimeout(waitingForAuth,waitingTimeForAuth,ws);

        ws.send(msg(MSG_TYPE.AUTH_REQUIRED));
    },
    message: (ws, message, isBinary) => {
        let clientMsg = JSON.parse(decoder.decode(message));
        switch (clientMsg.type) {
            case MSG_TYPE.AUTH_REQUEST:
                if(ws.isAuthenticated) { ws.send(msg(MSG_TYPE.INVALID_REQUEST)); }
                if(clientMsg.body && clientMsg.body.token){
                    console.log("Auth req received");
                    jwt.verify(clientMsg.body.token, JWT_SECRET, function(err, decoded){
                        if(err){
                            ws.send(msg(MSG_TYPE.AUTH_FAILURE));
                            console.log("Error verifying jwt: " + JSON.stringify(err));
                        } else {
                            ws.uid = decoded.uid;
                            ws.isAuthenticated = true;
                            ws.send(msg(MSG_TYPE.AUTH_SUCCESS));

                            clients.set(ws.uid, ws);
                            console.log("Auth req validated");
                        }
                    });
                } else {
                    ws.send(msg(MSG_TYPE.INVALID_REQUEST));
                }

                break;
            default:
                console.log("Unknow message type " + clientMsg.type);
        }
        //let ok = ws.send(message, isBinary, true);
    },
    drain: (ws) => {

    },
    close: (ws, code, message) => {
        if(clients.delete(ws.uid) === false) {
            console.log(`Client connection with unknown uid ${ws.uid} has been closed`);
        } else {
            console.log(`Client connection with uid ${ws.uid} has been closed`);
        }
    }
}).listen(ws_port, (listenSocket) => {
    if(listenSocket){
        console.log('Listening to port 3000');

        onShutdown((signal) => { uws.us_listen_socket_close(listenSocket); })
    }else{
        console.log(`Failed to listen ${ws_port}`);
    }
});
onShutdown(redis.shutdownHandler);