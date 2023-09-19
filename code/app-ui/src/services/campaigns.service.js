import ApiService from '@/services/api.service';

export default class CampaignsService extends ApiService {
	
	constructor(basePath) {
		super(basePath);
		console.log('CampaignsService Created');
	}
	
	async search(params = {}) {
		return this.get('/search', params);
	}
	
	async searchStats(params = {}) {
		return this.get('/stats/search', params);
	}

	async findById(id) {
		return this.get(`/${id}`);
	}
	
	async fetchStrategies() {
		return this.get('/strategies');
	}
	
	async fetchTemplates(campaignTye) {
		return this.get(`/${campaignTye}/templates`);
	}

	async fetchEventList() {
		return this.get('/events/list');
	}
	
	async fetchEventData(id) {
		return this.get(`/events/${id}/data`);
	}

	async fetchSurveyList() {
		return this.get('/surveys/list');
	}

	async fetchSurveyData(id) {
		return this.get(`/surveys/${id}/data`);
	}
	
	async update(id, data) {
		return await this.postForm(`/${id}/update`, data);
	}
	
	async register(id) {
		return await this.put(`/${id}/register`, { });
	}
	
	async save(data) {
		return await this.postForm('/', data);
	}
	
	// async save(data) {
	// 	return await this.post('/', data);
	// }
	
	async activate(id) {
		return await this.post(`/${id}/activate`);
	}
	
	async deactivate(id) {
		return await this.post(`/${id}/deactivate`);
	}

	async deleteFile(id) {
		return await this.delete(`/files/${id}`);
	}
	
	async getTypes(params = {}) {
		return await this.get('/types', params);
	}

	async batch(data) {
		return await this.post('/batch', data);
	}
}