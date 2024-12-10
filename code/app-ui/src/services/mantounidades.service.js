import ApiService from "@/services/api.service";

export default class MantoUnidadesService extends ApiService {
  static DOMAIN_CONFIG_KEY = "dmn-config";
  static USER_CONFIG_KEY = "usr-config";
  static MODULES_CONFIG_KEY = "mod-config";

  constructor(basePath) {
    super(basePath);
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

  async savePlanActividad(data) {
    return await this.post('/admin//planes/detalles', data);
  }

  async getPlanActividades(id) {
		return await this.get(`/admin//planes/detalles/${id}`);
	}

  /***********  Mantenimientos Correctivos  ***********/
  async getCorrectivos(params = {}) {
		return await this.get("/admin//correctivos", params);
	}

  async saveCorrectivo(data) {
    return await this.post("/admin//correctivos", data);
  }

  async updateCorrectivo(data) {
    return await this.put("/admin//correctivos", data);
  }

  async deleteCorrectivos(id) {
    return await this.delete(`/admin//correctivos/${id}`);
  }

  /***********  Api de SIAMT  ***********/
  async getUnidades() {
    return await [
          { id: 1, placa : '234', nume_econ: '123456', marca: 'Irizar' ,modelo: 'IETRAM',anio: '2024', serie: '2323', Odometro: '99999' },
          { id: 2, placa : '123456', nume_econ: 'ZASDF', marca: 'Irizar' ,modelo: 'IETRAM',anio: '2024', serie: '2323', Odometro: '99999' },
          { id: 3, placa : '876543', nume_econ: 'QWERTY', marca: 'Irizar' ,modelo: 'IETRAM',anio: '2024', serie: '2323', Odometro: '99999' },
          { id: 4, placa : '0csad78', nume_econ: 'OIUYTR', marca: 'Irizar' ,modelo: 'IETRAM',anio: '2024', serie: '2323', Odometro: '99999' }
        ];
    //return await this.delete(`/admin//correctivos/${id}`);
  }

  async getEstatus(params = {}) {
    return await this.get("/admin//estatus", params);
  }

  async getModelos() {
    return await [{ id: 1, nombre : 'Chevrolet' },{id:2, nombre : 'Nissan'},{id:3, nombre : 'Toyota'},{id:4, nombre : 'Mazda'}];
  }
}
