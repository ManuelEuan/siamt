import ApiService from "@/services/api.service";

export default class MantoUnidadesService extends ApiService {
  static DOMAIN_CONFIG_KEY = "dmn-config";
  static USER_CONFIG_KEY = "usr-config";
  static MODULES_CONFIG_KEY = "mod-config";

  constructor(basePath) {
    super(basePath);
  }

  async getModelos() {
    return await [{ id: 1, nombre : 'Chevrolet' },{id:2, nombre : 'Nissan'},{id:3, nombre : 'Toyota'},{id:4, nombre : 'Mazda'}];
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

  async deleteActividad(id) {
    return await this.delete(`/admin//actividades/${id}`);
  }

  /***********  Planes  ***********/
  async getPlanes(params = {}) {
		return await this.get("/admin//planes", params);
	}

  async savePlan(data) {
    return await this.post("/admin//planes", data);
  }

  async updatePlan(data) {
    return await this.put("/admin//planes", data);
  }

  async deletePlan(id) {
    return await this.delete(`/admin//planes/${id}`);
  }
}
