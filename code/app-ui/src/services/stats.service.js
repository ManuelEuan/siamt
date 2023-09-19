import ApiService from '@/services/api.service';

export default class StatsService extends ApiService {
	
	static create(baseUrl) {
		return new StatsService(baseUrl);
	}

	constructor(baseUrl) {
		super(baseUrl);
	}
	
	async search(params = {}) {
		return this.get('/search', params);
	}
	
	async fetchSurveys(params = {}) {
		return this.get('/surveys', params);
	}
}