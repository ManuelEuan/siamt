import ApiService from "@/services/api.service";

export default class AdminService extends ApiService {
  static DOMAIN_CONFIG_KEY = "dmn-config";
  static USER_CONFIG_KEY = "usr-config";
  static MODULES_CONFIG_KEY = "mod-config";

  constructor(basePath) {
    super(basePath);
    console.log("AdminService Created");
  }

  //Módulos

  async getModulesConfig() {
    let config = this.getLoadedModulesConfig();

    if (config == null) {
      config = await this.loadModulesConfig();
    }

    return config;
  }

  async getPermissionsOfModule(data) {
    return await this.post("/modules/getPermissionsOfModule", JSON.stringify(data));
  }
  
  async updatePermission(data) {
    return await this.post(`/modules/updatePermission`, JSON.stringify(data));
  }

  async createPermission(data) {
    return await this.post("/modules/createPermission", JSON.stringify(data));
  }

  async getModules(params = {}) {
    return await this.get("/modules", params);
  }

  async updateModule(id, data) {
    return await this.post(`/modules/${id}`, data);
  }

  async saveModule(data) {
    return await this.post("/modules", data);
  }

  async getModule(id) {
    return await this.get(`/modules/${id}`);
  }

  async activateModule(id) {
    return await this.post(`/modules/${id}/activate`);
  }

  async deactivateModule(id) {
    return await this.post(`/modules/${id}/deactivate`);
  }

  async deleteModule(id) {
    return await this.delete(`/modules/${id}`);
  }

  async batchModules(data) {
    return await this.post("/modules/batch", data);
  }

  //Permisos

  async getPermissions() {
    return await this.get("/permissions");
  }

  //Perfiles

  async getRoles() {
    return await this.get("/roles");
  }

  //Dominios

  async getDomains() {
    return await this.get("/domains");
  }

  //Usuarios

  async getUsers(data) {
    return await this.post("/users", JSON.stringify(data));
  }

  async createUser(data) {
    return await this.post("/users/new", JSON.stringify(data));
  }

  async deleteUser(id) {
    return await this.delete(`/users/${id}`);
  }

  async updateUser(data) {
    return await this.put("/users", JSON.stringify(data));
  }

  async getPermissionsFromUser(id) {
    return await this.post(`/users/${id}/permissions`, JSON.stringify(id));
  }

  async resetUserPass(data) {
    return await this.put("/users/reset", JSON.stringify(data));
  }

  async changeUserPass(data) {
    return await this.put("/users/change", JSON.stringify(data));
  }

  async getEditUserInfo(data) {
    return await this.post("/users/getedituserinfo", JSON.stringify(data));
  }

  async getActivePermissionsFromUser(id) {
    return await this.post("/users/getActivePermissionsFromUser", JSON.stringify(id));
  }


  //Perfiles

  async getProfiles(data) {
    return await this.post("/profiles", JSON.stringify(data));
  }

  async getEditProfileInfo(data) {
    return await this.post("/profiles/geteditprofileinfo", JSON.stringify(data));
  }

  async getUsersFromProfile(id) {
    return await this.post(`/profiles/${id}/users`, JSON.stringify(id));
  }

  async getPermissionsFromProfile(id) {
    return await this.post(`/profiles/${id}/permissions`, JSON.stringify(id));
  }

  async getModulesFromProfile(id) {
    return await this.post(`/profiles/${id}/modules`, JSON.stringify(id));
  }


  async createProfile(data) {
    return await this.post("/profiles/new", JSON.stringify(data));
  }

  async deleteProfile(id) {
    return await this.delete(`/profiles/${id}`);
  }

  async updateProfile(data) {
    return await this.put("/profiles", JSON.stringify(data));
  }
  
  async getServiceVindenUrlDebitaciones() {
    return await this.get("/debits/getServiceVindenUrlDebitaciones");
  }

  // Firmas

  async getDinamycCount() {
    return await this.get("/firms/getDinamycCount");
  }

  async getTemplateById(data) {
    return await this.post("/firms/getTemplateById", JSON.stringify(data));
  }

  
  async getFirmById(data) {
    return await this.post("/firms/getFirmById", JSON.stringify(data));
  }

  async getAllTemplates() {
    return await this.get("/firms/getAllTemplates");
  }

  async getAllFirms() {
    return await this.get("/firms/getAllFirms");
  }

  async createTemplate(data) {
    return await this.post("/firms/templates/new", JSON.stringify(data));
  }

  async updateTemplate(data) {
    return await this.put("/firms/templates", JSON.stringify(data));
  }

  async saveFirmRegisterByUser(data) {
    return await this.post("/firms/saveFirmRegisterByUser", JSON.stringify(data));
  }

  async updateFirmRegisterByUser(data) {
    return await this.put("/firms/updateFirmRegisterByUser", JSON.stringify(data));
  }

  // Personas

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

  async getAllLadaIdentifiers() {
    return await this.get("/persons/getAllLadaIdentifiers");
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

  async getAllTypesPhone() {
    return await this.get("/persons/getAllTypesPhone");
  }

  async getPersonByDinamycSearch(data) {
    return await this.post("/persons/getPersonByDinamycSearch", JSON.stringify(data));
  }

  // Procesos
  async newDinamycSubStage(data) {
    return await this.post("/process/newDinamycSubStage", JSON.stringify(data));
  }

  async getStructureFormDinamycProcess() {
    return await this.get("/process/getStructureFormDinamycProcess");
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

  async getInfoBySubStage(data) {
    return await this.post("/process/getInfoBySubStage", JSON.stringify(data));
  }

  // Territorio
  async getMunicipalityAndEntityByPostalCode(data) {
    return await this.post("/territory/getMunicipalityAndEntityByPostalCode", JSON.stringify(data));
  }

  async getColoniesByPostalCode(data) {
    return await this.post("/territory/getColoniesByPostalCode", JSON.stringify(data));
  }

  async getAllPostalCodes() {
    return await this.get("/territory/getAllPostalCodes");
  }
}
