import ApiService from "@/services/api.service";

export default class MantoUnidadesService extends ApiService {
  static DOMAIN_CONFIG_KEY = "dmn-config";
  static USER_CONFIG_KEY = "usr-config";
  static MODULES_CONFIG_KEY = "mod-config";

  constructor(basePath) {
    super(basePath);
    console.log("MantoUnidadesService Created");
  }


  async getComplejidad() {
    return await this.get("/admin//complejidad");
  }

  async getTipoConjunto() {
    return await this.get("/admin//tipoConjunto");
  }

  /***********  Actividades  ***********/
  async getActividades(params = {}) {
		return await this.get("/admin//actividades", params);
	}

  async saveActividad(data) {
    return await this.post("/admin//actividades", data);
  }

  async updateActividad(data) {
    return await this.put("/admin//actividades", data);
  }

  /***********  Planes  ***********/
  async savePlan(data) {
    return await this.post("/admin//planes", data);
  }
}
