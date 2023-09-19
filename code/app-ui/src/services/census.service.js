import ApiService from '@/services/api.service';
import services from "@/services/index";
import AppService from "@/services/app.service";

export default class CensusService extends ApiService {
	
	constructor(basePath) {
		super(basePath);
		console.log("CensusService Created");

	}

	async getPadrones() {
		const response = await this.get("/list");
		return response;
	}

	/**
	 * This function will return a promise that will resolve to the response of the get request to the
	 * /surveys endpoint.
	 * @returns The response from the get request.
	 */
	async getSurveys() {
		const response = await this.get("/surveys");
		return response;
	}

	async getPadronPersonas(idpadron, idSeccion){
		const response = await this.get("/" + idpadron + "?seccion=" + idSeccion);
		return response;
	}

	async getCensusTable(filters) {
		console.log("entra");
		const response = await this.post("/censusTable",JSON.stringify(filters));
		if(response.lError) {
			return null
		}
		return response;
	}

	async getCensusTable2(filters) {
		const response = await this.post("/censustable2",JSON.stringify(filters));
		if(response.lError) {
			return null
		}
		return response;
	}

	async getSurveyTable(filters) {
		const response = await this.post("/surveytable",JSON.stringify(filters));
		return response;
	}

	async getCensusMap(filters) {
		const response = await this.post("/censusMap",JSON.stringify(filters));
		return response;
	}

	async updateRowInCensus(item) {
		const response = await this.post("/updatecensusrow", JSON.stringify(item));
		if(response.lError) {
			return null;
		}
		return response;
	}

	async getVisitsByCensusAndPerson(item) {
		const response = await this.post("/getvisits", JSON.stringify(item));
		return response;
	}

	async addNewRowInCensus(item) {
		const response = await this.post('/newcensusrow',JSON.stringify(item));
		return response;
	}

	async save(data){
		console.log("-> data", data);
		const response = await this.post("/" + data.idpadron + '/' + data.idpersona, data);
		return response;
	}

	async saveCall(data){
		console.log("-> data", data);
		const response = await this.post("/call/" + data.idpadron + '/' + data.idpersona, data);
		return response;
	}

	updatePersonToVisis(person){
		let persToVisit = services.storage().get(AppService.USER_PERSONS_TO_VISIT);
		for(let i in persToVisit){
			const aux = persToVisit[i];
			if(aux.idpersona == person.idpersona){
				aux.idestatus = person.idestatus;
				aux.correo = person.correo;
				aux.telefono = person.telefono;
				aux.estatus_visita = person.estatus;
				services.storage().set(AppService.USER_PERSONS_TO_VISIT, persToVisit);
				break;
			}
		}
	}

	async exportData(filters) {
		const response = await this.post('/export',JSON.stringify(filters));
		return response;
	}

	async checkPersonaPadron(data) {
		const response = await this.post('/checkpersonapadron', JSON.stringify(data));
		return response;
	}


	//Dashboard urls
	async getDashboardIndex() {
		const response = await this.get("/dashboard");
		return response;
	}

	async getDocumentInfo(document) {
		const response = await this.post('/dashboard/document', JSON.stringify(document));
		return response;
	}

	async searchByText(data) {
		const response = await this.post('/censussearchbytext', JSON.stringify(data));
		return response;
	}

	async getEditRowInCensus(data) {
		const response = await this.post('/censusgetrow', JSON.stringify(data));
		return response;
	}
	

}
