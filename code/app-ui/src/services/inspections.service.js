import ApiService from "@/services/api.service";

export default class InspectionsService extends ApiService {
  static DOMAIN_CONFIG_KEY = "dmn-config";
  static USER_CONFIG_KEY = "usr-config";
  static MODULES_CONFIG_KEY = "mod-config";

  constructor(basePath) {
    super(basePath);
    console.log("InspectionsService Created");
  }

  //Módulos
  async getInspectors(data) {
    console.log(data)
    return await this.post("/inspectors", JSON.stringify(data));
  }

  async getPersonByCurp(curp) {
    console.log(curp)
    return await this.post("/inspectors/getPersonByCurp", JSON.stringify(curp));
  }

  async getPersonByDinamycSearch(data) {
    console.log('data search')
    console.log(data)
    return await this.post("/inspectors/getPersonByDinamycSearch", JSON.stringify(data));
  }

  async getAllCategoriesInspector() {
    console.log('suhdfiehfdiejofjmeowfjmowejfopw')
    return await this.get("/inspectors/getAllCategoriesInspector");
  }

  async getAllStagesInspector() {
    return await this.get("/inspectors/getAllStagesInspector");
  }

  async getAllShiftsInspector() {
    return await this.get("/inspectors/getAllShiftsInspector");
  }

  async getAllZonesInspector() {
    return await this.get("/workloads/getAllZonesInspector");
  }

  async getAllSexesPerson() {
    return await this.get("/persons/getAllSexesPerson");
  }

  async createPerson(data) {
    return await this.post("/persons/new", JSON.stringify(data));
  }

  async updateAddress(data) {
    return await this.put("/persons/direction", JSON.stringify(data));
  }

  async getAllPostalCodes() {
    return await this.get("/territory/getAllPostalCodes");
  }

  async getAllLadas() {
    return await this.get("/persons/getAllLadas");
  }

  

  async getMunicipalityAndEntityByPostalCode(data) {
    return await this.post("/territory/getMunicipalityAndEntityByPostalCode", JSON.stringify(data));
  }

  async getColoniesByPostalCode(data) {
    return await this.post("/territory/getColoniesByPostalCode", JSON.stringify(data));
  }

  async createDirection(data) {
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
  async getPersonPhones(data) {
    return await this.post("/persons/getPersonPhones", JSON.stringify(data));
  }

  async updateCurrentAddress(data) {
    return await this.post("/persons/updateCurrentAddress", JSON.stringify(data));
  }

  async deleteAddress(data) {
    return await this.post(`/persons/deleteAddress`, JSON.stringify(data));
  }
  

  async getAllCivilStatusPerson() {
    return await this.get("/persons/getAllCivilStatusPerson");
  }

  async getAllTypePhones() {
    return await this.get("/persons/getAllTypePhones");
  }

  async createInspector(data) {
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

  
  
  
}
