import BaseService from "@/services/base.service";
import api from '@/core/api.axios';
import ApiError from '@/core/api.error';

export default class ApiService extends BaseService{
	#api;
	#baseUrl;
	
	constructor(baseUrl) {
		super();
		console.log("ApiService Created", baseUrl);
		
		this.baseUrl = baseUrl;
		this.#api = api;

	}
	
	url(path){
		return this.baseUrl + path;
	}
	
	async get(path, queryParams = {}, anonymous = false){
		console.log(path,queryParams)
		let response = {};
		try {
			response = await api.get(
				this.url(path),
				{
					headers: {
						...(!anonymous  && { 'Authorization': 'Bearer ' + this.getAuthorizationToken() })
					},
					params: queryParams
				}
			);
		} catch (error) {
			throw new ApiError(error);
		}
		
		return response.data;
	}
	
	async post(path, data, anonymous = false){
		let response = {};
		try {
			response = await api.post(
				this.url(path),
				data,
				{
					headers: {
						...(!anonymous  && { 'Authorization': 'Bearer ' + this.getAuthorizationToken() })
					}
				}
			);
		} catch (error) {
			throw new ApiError(error);
		}
		
		return response.data;
	}
	
	async postForm(path, data, anonymous = false){
		let response = {};
		try {
			response = await api.post(
				this.url(path),
				data,
				{
					headers: {
						...(!anonymous  && { 'Authorization': 'Bearer ' + this.getAuthorizationToken() }),
						'Content-Type': 'multipart/form-data',
					}
				}
			);
		} catch (error) {
			throw new ApiError(error);
		}
		
		return response.data;
	}
	
	async putForm(path, data, anonymous = false){
		let response = {};
		try {
			response = await api.put(
				this.url(path),
				data,
				{
					headers: {
						...(!anonymous  && { 'Authorization': 'Bearer ' + this.getAuthorizationToken() }),
						'Content-Type': 'multipart/form-data',
					}
				}
			);
		} catch (error) {
			throw new ApiError(error);
		}
		
		return response.data;
	}
	
	async put(path, data, anonymous = false){
		let response = {};
		try {
			response = await api.put(
				this.url(path),
				data,
				{
					headers: {
						...(!anonymous  && { 'Authorization': 'Bearer ' + this.getAuthorizationToken() })
					}
				}
			);
		} catch (error) {
			throw new ApiError(error);
		}
		
		return response.data;
	}
	
	
	async postBlob(path, data, anonymous = false){
		let response = {};
		try {
			response = await api.post(
				this.url(path),
				data,
				{
					headers: {
						...(!anonymous  && { 'Authorization': 'Bearer ' + this.getAuthorizationToken() })
					},
					responseType: 'blob'
				}
			);
		} catch (error) {
			throw new ApiError(error);
		}
		
		return response.data;
	}

	
	async delete(path, data={}, anonymous = false){
		let response = {};
		try {
			response = await api.delete(
				this.url(path),
				{
					headers: {
						...(!anonymous  && { 'Authorization': 'Bearer ' + this.getAuthorizationToken() })
					},
					data
				}
			);
		} catch (error) {
			throw new ApiError(error);
		}
		
		return response.data;
	}
	
	getAuthorizationToken() {
		return this.getServices().security().getToken();
	}
	
	addResponseInterceptors(fnResponse, fnError){
		this.#api.interceptors.response.use(fnResponse, fnError);
	}

}