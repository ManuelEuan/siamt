export default class UsersService extends ApiService {

	constructor(basePath) {
		super(basePath);
		console.log("AppService Created");

		this.addHooks();
	}
	async getUsers(params = {}) {
		return await this.get("/users", params);
	}


}

import ApiService from '@/services/api.service';
