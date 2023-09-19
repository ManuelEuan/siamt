import ApiService from '@/services/api.service';

export default class CallcenterService extends ApiService {

    constructor(basePath) {
        super(basePath);
        console.log("CallcenterService Created");

    }

    async getSurveys() {
        return await this.get("/surveys");
    }

   async getSurveyCallTable(params = {}) {
        return await this.post("/getcallcenterdatatable", JSON.stringify(params));
    }

    async editCall(params = {}) {
        return await this.post("/editcall", JSON.stringify(params));
    }

    async getCallsStatus() {
        return await this.get("/estatus/getall");
    }

    async getAllSecondaryStatus() {
        return await this.get("/secondaryestatus/getall");
    }

    //métodos para las campañas del callcenter
    async getAllCampaigns() {
        return await this.get("/campaigns/getall");
    }

    //Método para traer reporte en Excel
    async getExcelReport(params = {}) {
        return await this.post('/getexcelreport', JSON.stringify(params))
    }

    //Método para validar el bloqueo de una persona
    async validateLock(params = {}) {
        return await this.post('/validatelock',JSON.stringify(params));
    }

    async unlockPerson(params = {}) {
        return await this.post('unlockperson',JSON.stringify(params));
    }

    async getCampaignTable(params = {}) {
        return await this.post('/campaigns/getcampaigntable', JSON.stringify(params));
    }

    async newCall(params = {}) {
        return await this.post("/newcall", JSON.stringify(params));
    }
    async storeCanceledCall(params = {}) {
        return await this.post("/cancelcall", JSON.stringify(params));
    }

    async getCallsByPerson(params = {}) {
        return await this.post("/getcallsbyperson", JSON.stringify(params));
    }

    async getExcelReportInfo(params = {}){
        return await this.post('/getexcelreportinfo',JSON.stringify(params));
    }
/*
    /!* eslint-disable no-unused-vars *!/
    async update(id, data) {
        return await this.post(`/${id}`,data);
    }

    async save(data) {
        return await this.post('/', data);
    }

    async activate(id) {
        return await this.post(`/${id}/activate`);
    }

    async deactivate(id) {
        return await this.post(`/${id}/deactivate`);
    }

    async getInChargePeople(params = {}) {
        return await this.get('/in-charge-people', params);
    }

    async getTypes(params = {}) {
        return await this.get('/types', params);
    }

    async getOne(id){
        return await this.get(`/${id}`);
    }

    async uploadImages(data) {
        return await this.post('/uploadimages',JSON.stringify(data));
    }

    async getEventImages(data) {
        return await this.post('/geteventimages',JSON.stringify(data));
    }*/
}