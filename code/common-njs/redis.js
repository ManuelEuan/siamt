class Redis {
    #connection = null;
    #blockingConnection = null;

    #getList = name => `${name}-l`;
    #getChannel = name => `${name}-c`;
    #subscribeHandler = (error, count) => {
        error? console.log(`Failed to subscribe ${error.message}`) : console.log(`Subscribed successfully! to ${count} channels.`);
    };
    shutdownHandler = (signal) => {
        this.#connection.quit();
        if(this.#blockingConnection !== null){
            this.#blockingConnection.quit();
        }
    };

    constructor(conf) {
        const IORedis = require('ioredis');
        this.#connection = new IORedis(conf)
    }

    publishToQueue(name, value) {
        this.#connection.lpush(this.#getList(name), value);
        this.#connection.publish(this.#getChannel(name), '');
    }

    subscribetoQueue(name, handler) {
        if(this.#blockingConnection === null){
            this.#blockingConnection = this.#connection.duplicate();
        }

        this.#blockingConnection.subscribe(this.#getChannel(name), this.#subscribeHandler);
        this.#blockingConnection.on('message',(channel, message) => {
            console.log(`[redis][${channel}] msg: ${message}`);

            this.#connection.rpop(this.#getList(name), handler);
        });
    }

    api(){
        return this.#connection;
    }

    blockingApi() {
        return this.#blockingConnection;
    }
}

exports.Redis = Redis;