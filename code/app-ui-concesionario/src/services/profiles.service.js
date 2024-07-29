import ApiService from "@/services/api.service";

export default class ProfilesService extends ApiService {

	constructor(basePath) {
		super(basePath);
		console.log("ProfilesService Created");
	}

	async getProfiles(params = {}) {
		return await this.get("/profiles", params);
	}


}
