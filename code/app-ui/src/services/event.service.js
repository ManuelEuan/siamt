import ApiService from '@/services/api.service';

export default class EventService extends ApiService {
	
	constructor(basePath) {
		super(basePath);
		console.log("EventService Created");
		
	}
	
	async getAll(params = {}) {
		return await this.get("", params);
	}
	
	/* eslint-disable no-unused-vars */
	async update(id, data) {
		return await this.post(`/${id}`,data);
	}
	
	async save(data) {
		return await this.post('/', data);
	}
	
	async activate(id) {
		return await this.post(`/${id}/activate`);
	}
	
	async deactivate(id) {
		return await this.post(`/${id}/deactivate`);
	}
	
	async getInChargePeople(params = {}) {
		return await this.get('/in-charge-people', params);
	}
	
	async getTypes(params = {}) {
		return await this.get('/types', params);
	}

	async getOne(id){
		return await this.get(`/${id}`);
	}

	async uploadImages(data) {
		return await this.post('/uploadimages',JSON.stringify(data));
	}

	async getEventImages(data) {
		return await this.post('/geteventimages',JSON.stringify(data));
	}
}