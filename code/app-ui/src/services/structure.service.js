import ApiService from '@/services/api.service';

export default class StructureService extends ApiService {
	
	constructor(basePath) {
		super(basePath);
		console.log("PersonService Created");

	}
	
	async getAll(params = {}) {
		return await this.get("", params);
	}
	
	async getLevels(params = {}) {
		return await this.get("/levels", params);
	}
	
	async getTree(id, params = {}) {
		return await this.get(`/tree/${id}`, params);
	}
	
	async getUsers(id, params = {}) {
		return await this.get(`/${id}/users`, params);
	}
	
	async assignUsers(id, data) {
		return await this.post(`/${id}/users`, data);
	}
	async unassignPerson(id) {
		return await this.delete(`/${id}/person`);
	}
	async validatePersonLevel(data) {
		return await this.post(`/validate-person-level`,data);
	}
	
	/* eslint-disable no-unused-vars */
	async update(id, data) {
		return await this.post(`/${id}`,data);
	}
	
	async save(data) {
		return await this.post('/', data);
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
	
	async deleteSingle(id) {
		return await this.delete(`/${id}`);
	}
	
	async batch(data) {
		return await this.post('/batch', data);
	}

	async getEstatus() {
		return await this.get("/estatus");
	}
	async changeTraining(data) {
		return await this.post('/change-training',JSON.stringify(data));
	}
	async changeValidation(data) {
		return await this.post('/change-validation',JSON.stringify(data));
	}

	async getPrintInfo(data){
		return await this.post('/get-print-info',JSON.stringify(data));
	}
}