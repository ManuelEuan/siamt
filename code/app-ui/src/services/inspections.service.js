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

}
