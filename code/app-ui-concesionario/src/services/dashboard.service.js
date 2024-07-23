import ApiService from '@/services/api.service';
//import services from "@/services/index";
//import AppService from "@/services/app.service";

export default class DashboarsService extends ApiService {
	
	constructor(basePath) {
		super(basePath);
		console.log("DashboardService Created");

	}

	async getIndex() {
		const response = await this.get("/");
		return response;
	}

}
