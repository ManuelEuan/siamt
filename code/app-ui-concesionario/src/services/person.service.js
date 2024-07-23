import ApiService from '@/services/api.service';

export default class PersonService extends ApiService {
	
	constructor(basePath) {
		super(basePath);
		console.log("PersonService Created");

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
	
	async saveCompound(data) {
		return await this.post('/compound', data);
	}
	
	async getCompound(id) {
		return await this.get(`/${id}/compound`);
	}
	
	async updateCompound(id, data) {
		return await this.post(`/${id}/compound`, data);
	}
	
	async getSingle(id) {
		return await this.get(`/${id}`);
	}
	
	async activate(id) {
		return await this.post(`/${id}/activate`);
	}
	
	async deactivate(id) {
		return await this.post(`/${id}/deactivate`);
	}
	
	async delete(id) {
		return await this.delete(`/${id}`);
	}
	
	async batch(data) {
		return await this.post('/batch', data);
	}

	async getEstatus() {
		return await this.get("/estatus");
	}
}