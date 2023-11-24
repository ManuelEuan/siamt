import ApiService from "@/services/api.service";

export default class UsersService extends ApiService {

	constructor(basePath) {
		super(basePath);
		console.log("UsersService Created");
	}

	async getUsers(params = {}) {
		return await this.get("/users", params);
	}


}
