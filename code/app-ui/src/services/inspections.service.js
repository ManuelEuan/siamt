import ApiService from "@/services/api.service";

export default class InspectionsService extends ApiService {
  static DOMAIN_CONFIG_KEY = "dmn-config";
  static USER_CONFIG_KEY = "usr-config";
  static MODULES_CONFIG_KEY = "mod-config";

  constructor(basePath) {
    super(basePath);
    console.log("InspectionsService Created");
  }

  async getInspectors(data) {
    return await this.post("/inspectors", JSON.stringify(data));
  }

  async getPersonByCurp(curp) {
    return await this.post("/inspectors/getPersonByCurp", JSON.stringify(curp));
  }


  async getAllCategoriesInspector() {
    return await this.get("/inspectors/getAllCategoriesInspector");
  }


  

  async getAllSubStagesByStage(stage){
    return await this.post("/inspectors/getAllSubStagesByStage", JSON.stringify(stage));
  }

  async getAllShiftsInspector() {
    return await this.get("/inspectors/getAllShiftsInspector");
  }




  async getInfoProcess(data) {
    return await this.post("/inspectors/getInfoProcess", JSON.stringify(data));
  }

  async hasFlowAfter(data) {
    return await this.post("/inspectors/hasFlowAfter", JSON.stringify(data));
  }

  async getAllFlowBySubStage(subStage) {
    return await this.post("/inspectors/getAllFlowBySubStage", JSON.stringify(subStage));
  }

  async createInspector(data) {
    // console.log(data)
    return await this.post("/inspectors/new", JSON.stringify(data));
  }

  async updateInspector(data) {
    return await this.put("/inspectors", JSON.stringify(data));
  }
  
  async deleteInspector(id) {
    return await this.delete(`/inspectors/${id}`);
  }

  async getInspectorInfo(id){
    return await this.post("/inspectors/getInspectorInfo", JSON.stringify(id));
  }
  
  async createWorkload(data) {
    return await this.post("/workloads/new", JSON.stringify(data));
  }
  
  async getServiceVindenUrlDebitaciones() {
    return await this.get("/inspectors/getServiceVindenUrlDebitaciones");
  }

  async updateInspectorSubStage(data) {
    return await this.put("/inspectors/updateInspectorSubStage", JSON.stringify(data));
  }

  async insertInspectorTrace(data) {
    return await this.post("/inspectors/insertInspectorTrace", JSON.stringify(data));
  }
  
  async getTickets(data) {
    console.log('dataiii');
    console.log(data);
    return await this.post("/tickets/getTickets", JSON.stringify(data));
  }

  async downloadTickets(params = {}) {
    return await this.get("/tickets/downloadTickets", params);
  }

  async getStructureFormWorkloads() {
    return await this.get("/workloads/getStructureFormWorkloads");
  }
  
  
   
  
  
}
