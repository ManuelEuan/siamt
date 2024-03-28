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

  async getAllCivilStatusPerson() {
    return await this.get("/persons/getAllCivilStatusPerson");
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
