import ApiService from '@/services/api.service';

export default class FinderService extends ApiService {
	
	constructor(basePath) {
		super(basePath);
	}
	
	async searchPeople(params = {}) {
		return this.get('/people/search', params);
	}

	async searchStats(params = {}) {
		return this.get('/stats/search', params);
	}

	async findById(id) {
		return this.get(`/people/${id}`);
	}

	async searchAddressByPerson(id, params = {}) {
		return this.get(`/people/${id}/addresses/search`, params);
	}
	
	async fetchAllPhonesByPerson(id, params = {}) {
		return this.get(`/people/${id}/phones`, params);
	}
	
	async fetchAllEmailsByPerson(id, params = {}) {
		return this.get(`/people/${id}/emails`, params);
	}
	
	async fetchPersonPicture(id, params = {}) {
		return this.get(`/people/${id}/picture`, params);
	}
	
	// async fetchStateList() {
	// 	return this.get('/states');
	// }
	
	// async fetchLocalityList(municipalityId) {
	// 	return this.get(`/municipalities/${municipalityId}/localities`);
	// }
	
	async fetchLocalDistrictList() {
		return this.get('/territory/local-districts');
	}
	
	async fetchMunicipalityList(localDistrictId) {
		return this.get(`/territory/local-districts/${localDistrictId}/municipalities`);
	}

	async fetchSectionList(localDistrictId, minicipalityId) {
		return this.get(`/territory/local-districts/${localDistrictId}/municipalities/${minicipalityId}/sections`);
	}
	
	async fetchCensusList() {
		return this.get('/census');
	}
	
	async fetchAcademicLevelList() {
		return this.get('/academic-levels');
	}
	
	async fetchGenderList() {
		return this.get('/genders');
	}
	
	async fetchDisabilityList() {
		return this.get('/disabilities');
	}
	
	async fetchCivilStatusList() {
		return this.get('/civil-statuses');
	}
	
	async fetchPersonStatusList() {
		return this.get('/person-statuses');
	}
	
	async fetchLifeStatusList() {
		return this.get('/life-statuses');
	}
}