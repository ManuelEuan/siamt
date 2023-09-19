var shutdown = function(handler){
    ['SIGHUP','SIGINT','SIGTERM']
        .forEach((signal) => {
            process.on(signal, () => {
                console.log(`Handling shutdown: ${signal}`);
                handler(signal);
            });
        });
}

exports.onShutdown = shutdown;