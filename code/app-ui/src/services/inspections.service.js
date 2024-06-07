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

  async getPersonByDinamycSearch(data) {
    return await this.post("/persons/getPersonByDinamycSearch", JSON.stringify(data));
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


  async getAllSexes() {
    return await this.get("/persons/getAllSexes");
  }

  async createPerson(info) {
    return await this.post("/persons/new", JSON.stringify(info));
  }

  async updatePerson(data) {
    return await this.put("/persons/update", JSON.stringify(data));
  }

  async updateAddress(data) {
    return await this.put("/persons/direction", JSON.stringify(data));
  }

  async getAllPostalCodes() {
    return await this.get("/territory/getAllPostalCodes");
  }

  async getAllLadaIdentifiers() {
    return await this.get("/persons/getAllLadaIdentifiers");
  }

  

  async getMunicipalityAndEntityByPostalCode(data) {
    return await this.post("/territory/getMunicipalityAndEntityByPostalCode", JSON.stringify(data));
  }

  async getColoniesByPostalCode(data) {
    return await this.post("/territory/getColoniesByPostalCode", JSON.stringify(data));
  }

  async createAddress(data) {
    return await this.post("/persons/direction/new", JSON.stringify(data));
  }

  async createPhone(data) {
    return await this.post("/persons/phone/new", JSON.stringify(data));
  }

  async updatePhone(data) {
    return await this.put("/persons/phone", JSON.stringify(data));
  }

  async getPersonAddresses(data) {
    return await this.post("/persons/getPersonAddresses", JSON.stringify(data));
  }

  async getGeneralPersonData(data) {
    return await this.post("/persons/getGeneralPersonData", JSON.stringify(data));
  }

  async getPersonPhones(data) {
    return await this.post("/persons/getPersonPhones", JSON.stringify(data));
  }

  async updateCurrentPhone(data) {
    return await this.post("/persons/updateCurrentPhone", JSON.stringify(data));
  }

  async updateCurrentAddress(data) {
    return await this.post("/persons/updateCurrentAddress", JSON.stringify(data));
  }

  async deleteAddress(data) {
    return await this.post(`/persons/deleteAddress`, JSON.stringify(data));
  }

  async deletePhone(data) {
    return await this.post(`/persons/deletePhone`, JSON.stringify(data));
  }

  async getAllCivilStatus() {
    return await this.get("/persons/getAllCivilStatus");
  }

  async getInfoProcess(data) {
    return await this.post("/inspectors/getInfoProcess", JSON.stringify(data));
  }

  async hasFlowAfter(data) {
    return await this.post("/inspectors/hasFlowAfter", JSON.stringify(data));
  }

  async getInfoBySubStage(data) {
    return await this.post("/process/getInfoBySubStage", JSON.stringify(data));
  }

  

  async getAllFlowBySubStage(subStage) {
    return await this.post("/inspectors/getAllFlowBySubStage", JSON.stringify(subStage));
  }

  async getAllTypesPhone() {
    return await this.get("/persons/getAllTypesPhone");
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

  async newDinamycSubStage(data) {
    return await this.post("/process/newDinamycSubStage", JSON.stringify(data));
  }

  async updateInspectorSubStage(data) {
    return await this.put("/inspectors/updateInspectorSubStage", JSON.stringify(data));
  }

  async insertInspectorTrace(data) {
    return await this.post("/inspectors/insertInspectorTrace", JSON.stringify(data));
  }
  
  async getAllModules() {
    return await this.get("/process/getAllModules");
  }

  async getAllProcess() {
    return await this.get("/process/getAllProcess");
  }

  async getAllStages() {
    return await this.get("/process/getAllStages");
  }

  async getAllSubStages() {
    return await this.get("/process/getAllSubStages");
  }

  async getStructureFirstForm() {
    return await this.get("/process/getStructureFirstForm");
  }

  async getStructureFormWorkloads() {
    return await this.get("/workloads/getStructureFormWorkloads");
  }
  

  async getProcessWithStagesAndSubstages(data) {
    return await this.post("/process/getProcessWithStagesAndSubstages", JSON.stringify(data));
  }

  async getAllNextSubStagesEnabled(data) {
    return await this.post("/process/getAllNextSubStagesEnabled", JSON.stringify(data));
  }

  async getFlowByProcess(data) {
    return await this.post("/process/getFlowByProcess", JSON.stringify(data));
  }
  

  async newRegisterInProcess(data) {
    return await this.post("/process/newRegisterInProcess", JSON.stringify(data));
  }

  async updateRegisterInProcess(data) {
    return await this.put("/process/updateRegisterInProcess", JSON.stringify(data));
  }
  
  async getDinamycRegisterInProcess(data) {
    return await this.post("/process/dinamycRegisterInProcess", JSON.stringify(data));
  }

  async getTickets(data) {
    return await this.post("/tickets/getTickets", JSON.stringify(data));
  }

  // async downloadTickets(data) {
  //   return await this.post("/tickets/downloadTickets", JSON.stringify(data));
  // }

  async downloadTickets(params = {}) {
    return await this.get("/tickets/downloadTickets", params);
  }
  
   
  
  
}
