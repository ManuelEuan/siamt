import ApiService from "@/services/api.service";

export default class MantoUnidadesService extends ApiService {
  static DOMAIN_CONFIG_KEY = "dmn-config";
  static USER_CONFIG_KEY = "usr-config";
  static MODULES_CONFIG_KEY = "mod-config";

  constructor(basePath) {
    super(basePath);
    console.log("ProcedureService Created");
  }

  async right(vclave) {
    return await this.get(`/right/${vclave}`);
  }
}
