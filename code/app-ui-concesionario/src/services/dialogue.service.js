import ApiService from '@/services/api.service';

export default class AssignmentsService extends ApiService {
	
	static create(baseUrl) {
		return new AssignmentsService(baseUrl);
	}

	constructor(baseUrl) {
		super(baseUrl);
	}
	
	async searchPersons(params = {}) {
		return this.get('/persons/search', params);
	}
	
	async fetchCensus(params = {}) {
		return this.get('/persons/census', params);
	}
	
	async fetchSections(params = {}) {
		return this.get('/persons/sections', params);
	}
	
	async fetchStatuses(params = {}) {
		return this.get('/persons/statuses', params);
	}
	
	async assignPersons(body = {}) {
		return this.post('/persons/assign', body);
	}
	
	async exportPersons(body = {}) {
		return this.postBlob('/downloads/persons/export', body);
	}

	async revokeAssignmentPersons(body = {}) {
		return this.delete('/persons/assignment/revoke', body);
	}
	
	async fetchStatsPersons(params = {}) {
		return this.get('/persons/stats', params);
	}
}