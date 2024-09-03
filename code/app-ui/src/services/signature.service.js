import ApiService from "@/services/api.service";

export default class AdminService extends ApiService {
  static DOMAIN_CONFIG_KEY = "dmn-config";
  static USER_CONFIG_KEY = "usr-config";
  static MODULES_CONFIG_KEY = "mod-config";

  constructor(basePath) {
    super(basePath);
    console.log("SignaturaService Created");
  }

  // Firmas

  async getDinamycCount() {
    return await this.get("/getDinamycCount");
  }

  async getTemplateById(data) {
    return await this.post("/getTemplateById", JSON.stringify(data));
  }

  
  async getFirmById(data) {
    return await this.post("/getFirmById", JSON.stringify(data));
  }

  async getAllTemplates() {
    return await this.get("/getAllTemplates");
  }

  async getAllFirms() {
    return await this.get("/getAllFirms");
  }

  async createTemplate(data) {
    return await this.post("/templates/new", JSON.stringify(data));
  }

  async updateTemplate(data) {
    return await this.put("/templates", JSON.stringify(data));
  }

  async saveFirmRegisterByUser(data) {
    return await this.post("/saveFirmRegisterByUser", JSON.stringify(data));
  }

  async updateFirmRegisterByUser(data) {
    return await this.put("/updateFirmRegisterByUser", JSON.stringify(data));
  }

}
