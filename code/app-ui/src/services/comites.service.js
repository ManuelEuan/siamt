import ApiService from '@/services/api.service';

export default class TrackerService extends ApiService {


    constructor(basePath) {
        super(basePath);
        console.log("TrackerService Created");

    }

    async index() {
        return await this.get("/");
    }

    async newComite(data = {}) {
        return await this.post("/new",JSON.stringify(data));
    }

    async getComite(data = {}) {
        return await this.post("/getcomite",JSON.stringify(data));
    }

    async getMonths() {
        return await this.get("/getmonths");
    }

    async update(data = {}) {
        return await this.post("/update",JSON.stringify(data));
    }
    async destroy(data = {}) {
        return await this.post("/destroy",JSON.stringify(data));
    }

    async show(data = {}) {
        return await this.post("/show",JSON.stringify(data));
    }

    getScopeItems() {
        return [
            {
                id : 1,
                text : "Estatal",

            },{
                id : 2,
                text : "Municipal",

            },{
                id : 3,
                text : "Subcomité",
            }
        ]
    }


}