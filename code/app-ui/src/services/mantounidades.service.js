import ApiService from "@/services/api.service";

export default class MantoUnidadesService extends ApiService {
  static DOMAIN_CONFIG_KEY = "dmn-config";
  static USER_CONFIG_KEY = "usr-config";
  static MODULES_CONFIG_KEY = "mod-config";

  constructor(basePath) {
    super(basePath);
  }

  /***********  Catalogos  ***********/
  async getComplejidad() {
    return await this.get("/admin//complejidad");
  }

  async getTipoConjunto() {
    return await this.get("/admin//tipoConjunto");
  }

  async getEstatus(params = {}) {
    return await this.get("/admin//estatus", params);
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

  /***********  Mantenimientos Correctivos y Preventivos  ***********/
  async getMantenimientos(params = {}) {
		return await this.get("/admin//mantenimientos", params);
	}

  async saveMantenimiento(data) {
    return await this.post("/admin//mantenimientos", data);
  }

  async updateMantenimiento(data) {
    return await this.put("/admin//mantenimientos", data);
  }

  async deleteMantenimiento(id) {
    return await this.delete(`/admin//mantenimientos/${id}`);
  }

  async uploadFactura(data) {
    return await this.post("/admin//mantenimientos/upload/factura", data);
  }

  async getPreventivos() {
    return await [
      { id: 1, placa : 'A-04998-Z', numeroEconomico: 'CM-28', nombreMarca: 'MERCEDES BENZ' ,modelo: 'N/A',anio: '2024', serie: '2323', Odometro: '99999', "nombreEmpresa": 'CIRCUITO METROPOLITANO S.A. DE C.V.' },
      { id: 2, placa : 'A-05029-Z', numeroEconomico: 'CM-29', nombreMarca: 'MERCEDES BENZ' ,modelo: 'N/A',anio: '2024', serie: '2323', Odometro: '99999', "nombreEmpresa": 'CIRCUITO METROPOLITANO S.A. DE C.V.'},
      { id: 3, placa : 'A-04998-Z', numeroEconomico: 'CM-30', nombreMarca: 'MERCEDES BENZ' ,modelo: 'N/A',anio: '2024', serie: '2323', Odometro: '99999', "nombreEmpresa": 'CIRCUITO METROPOLITANO S.A. DE C.V.'},
      { id: 4, placa : 'A-04998-Z', numeroEconomico: 'CM-31', nombreMarca: 'MERCEDES BENZ' ,modelo: 'N/A',anio: '2024', serie: '2323', Odometro: '99999', "nombreEmpresa": 'CIRCUITO METROPOLITANO S.A. DE C.V.'}
    ];
  }



  /***********  Api de SIAMT  ***********/
  async getUnidades(params = {}) {
    console.log(params);
    return await [
      { id: 1, placa : 'A-04998-Z', numeroEconomico: 'CM-28', nombreMarca: 'MERCEDES BENZ' ,modelo: 'N/A',anio: '2024', serie: '2323', Odometro: '99999', "nombreEmpresa": 'CIRCUITO METROPOLITANO S.A. DE C.V.' },
      { id: 2, placa : 'A-05029-Z', numeroEconomico: 'CM-29', nombreMarca: 'MERCEDES BENZ' ,modelo: 'N/A',anio: '2024', serie: '2323', Odometro: '99999', "nombreEmpresa": 'CIRCUITO METROPOLITANO S.A. DE C.V.'},
      { id: 3, placa : 'A-04998-Z', numeroEconomico: 'CM-30', nombreMarca: 'MERCEDES BENZ' ,modelo: 'N/A',anio: '2024', serie: '2323', Odometro: '99999', "nombreEmpresa": 'CIRCUITO METROPOLITANO S.A. DE C.V.'},
      { id: 4, placa : 'A-04998-Z', numeroEconomico: 'CM-31', nombreMarca: 'MERCEDES BENZ' ,modelo: 'N/A',anio: '2024', serie: '2323', Odometro: '99999', "nombreEmpresa": 'CIRCUITO METROPOLITANO S.A. DE C.V.'}
    ];
  }

  async getUnidad(id){
    let unidades = [
      { id: 1, placa : 'A-04998-Z', numeroEconomico: 'CM-28', nombreMarca: 'MERCEDES BENZ' ,modelo: 'N/A',anio: '2024', serie: '2323', Odometro: '99999', "nombreEmpresa": 'CIRCUITO METROPOLITANO S.A. DE C.V.' },
      { id: 2, placa : 'A-05029-Z', numeroEconomico: 'CM-29', nombreMarca: 'MERCEDES BENZ' ,modelo: 'N/A',anio: '2024', serie: '2323', Odometro: '99999', "nombreEmpresa": 'CIRCUITO METROPOLITANO S.A. DE C.V.'},
      { id: 3, placa : 'A-04998-Z', numeroEconomico: 'CM-30', nombreMarca: 'MERCEDES BENZ' ,modelo: 'N/A',anio: '2024', serie: '2323', Odometro: '99999', "nombreEmpresa": 'CIRCUITO METROPOLITANO S.A. DE C.V.'},
      { id: 4, placa : 'A-04998-Z', numeroEconomico: 'CM-31', nombreMarca: 'MERCEDES BENZ' ,modelo: 'N/A',anio: '2024', serie: '2323', Odometro: '99999', "nombreEmpresa": 'CIRCUITO METROPOLITANO S.A. DE C.V.'}
    ]

    const value  = unidades.filter(i => i.id == id);
    return await value;
  }
  async getEmpresas() {
		return await [
			{ id: 1, nombre : 'CIRCUITO METROPOLITANO S.A. DE C.V."' },
			{ id: 2, nombre : 'LINEAS URBE' },
			{ id: 3, nombre : 'MAYAN BUS CO' },
			{ id: 4, nombre : 'MINI JARDINES DE MERIDA' },
			{ id: 5, nombre : 'MINIBUSES DEL MAYAB'}
		];
  }

  async getMarcas() {
		return await [
			{ id: 1, nombre : 'AYCON' },
			{ id: 2, nombre : 'BECCAR' },
			{ id: 3, nombre : 'DINA' },
			{ id: 4, nombre : 'IRIZAR' },
			{ id: 5, nombre : 'JAC'}
		];
  }

  async getModelos() {
		return await [
			{ id: 1, nombreModelo : 'N/A', idMarca: 1, nombreMarca: 'MERCEDES BENZ' },
			{ id: 2, nombreModelo : 'N/A', idMarca: 2, nombreMarca: 'VOLVO' },
			{ id: 3, nombreModelo : 'N/A', idMarca: 3, nombreMarca: 'YUTONG' },
			{ id: 4, nombreModelo : 'N/A', idMarca: 4, nombreMarca: 'MARCO POL' },
			{ id: 5, nombreModelo : 'N/A', idMarca: 5, nombreMarca: 'MERCEDEZ' }
		];
  }
}
