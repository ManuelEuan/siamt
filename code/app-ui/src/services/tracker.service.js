import ApiService from '@/services/api.service';

export default class TrackerService extends ApiService {


    constructor(basePath) {
        super(basePath);
        console.log("TrackerService Created");

    }

    async getInfo(params = null) {
        return await this.post("/getinfo",JSON.stringify(params));
    }

    async getMonths() {
        return await this.get("/getmonths");
    }

    getScopeItems() {
        return [
            {
                id : 1,
                text : "Federal",
                subItems : [
                    {
                        id : 1,
                        text : "Presidente"
                    },
                    {
                        id : 2,
                        text : "Diputado Federal"
                    }
                ]
            },{
                id : 2,
                text : "Local",
                subItems : [
                    {
                        id : 1,
                        text : "Gobernador"
                    },
                    {
                        id : 2,
                        text : "Diputados Locales"
                    }
                ]
            }
        ]
    }


}