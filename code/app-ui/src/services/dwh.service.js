import ApiService from '@/services/api.service';

export default class PersonService extends ApiService {
	
	static DOMAIN_CONFIG_KEY = "dmn-config";
	static USER_CONFIG_KEY = "usr-config";
	static MODULES_CONFIG_KEY = "mod-config";
	
	constructor(basePath) {
		super(basePath);
		console.log("PersonService Created");

	}
	
	async searchPersons(params = {}) {
		return await this.get("/persons/search", params);
	}
	async getSearchPerson(id) {
		return await this.get(`/persons/${id}/search-info`);
	}
	async getPersonImage(id) {
		return await this.get(`/persons/${id}/image`);
	}
	async getPersonAddresses(id) {
		return await this.get(`/persons/${id}/addresses`);
	}
	async getPersonEmails(id) {
		return await this.get(`/persons/${id}/emails`);
	}
	async getPersonPhones(id) {
		return await this.get(`/persons/${id}/phones`);
	}
	async getPerson(id) {
		return await this.get(`/persons/${id}`);
	}
	
	async getGenders(params = {}) {
		return await this.get('/genders', params);
	}
	
	async getMaritalStatus(params = {}) {
		return await this.get('/maritalStatus', params);
	}
	
	async getStates(params = {}) {
		return await this.get('/states', params);
	}
	
	async getMunicipalities(params = {}) {
		return await this.get('/municipalities', params);
	}
	
	async getLocalities(params = {}) {
		return await this.get('/localities', params);
	}

	async getEducationLevels(params = {}) {
		return await this.get('/education-levels', params);
	}
	
	async getDisabilities(params = {}) {
		return await this.get('/disabilities', params);
	}
	
	async getLifeStates(params = {}) {
		return await this.get('/life-states', params);
	}

	async searchCensusPersons(data = {}) {
		return await this.post('/search/persons',JSON.stringify(data));
	}

	async getPersonCollections() {
		return await this.post('/person/add/collections');
	}
}