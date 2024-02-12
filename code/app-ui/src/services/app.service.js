import ApiService from '@/services/api.service';

export default class AppService extends ApiService {
	
	static DOMAIN_CONFIG_KEY = "dmn-config";
	static USER_CONFIG_KEY = "usr-config";
	static MODULES_CONFIG_KEY = "mod-config";
	static USER_WORKLOAD = "usr-workload";
	static USER_VISIT_PERSON = "usr-visit-person";
	static USER_PERSONS_TO_VISIT = "usr-persons-to-visit";
	
	constructor(basePath) {
		super(basePath);
		console.log("AppService Created");
		
		this.addHooks();
	}
	async getUsers(params = {}) {
		return await this.get("/users", params);
	}

	async getModuleConfig(code) {
		let config = this.getLoadedModulesConfig();
	
		if (config == null) {
			config = await this.loadModulesConfig();
		}
		
		const search = (items) => {
			for(let i = 0; i < items.length; i++){
				let e = items[i];
				
				// if(e.code === code) {
				// 	console.log("FOUND!",code);
				// 	return e;
				// } else if( e.items) {
				// 	return search(e.items);
				// }
				
				if(e.code === code) {
					console.log("FOUND!", code);
					return e;
				} else if( e.items) {
					const found = search(e.items);
					if (found) return found;
				}
			}
		};

		return search(config);
	}

	async hasModule(code) {
		const config = this.getModuleConfig(code);
		const has = config ?  true : false;

		return has;
	}

	async getUserDomainModuleConfig(code) {
		let config = this.getLoadedUserDomainModulesConfig();
		console.log("=>(app.service.js:52) config", config);

		if (config === null) {
			config = await this.loadUserDomainModulesConfig();
		}

		const search = (it) => {
			for(let i = 0; i < it.length; i++){
				let e = it[i];
				if(e.code === code) {
					console.log("FOUND!", code);
					return e;
				} else if( e.items) {
					const found = search(e.items);
					if (found) return found;
				}
			}
		};

		return search(config);
	}

	async getModulesConfig() {
		let config = this.getLoadedModulesConfig();
	
		if (config == null) {
			config = await this.loadModulesConfig();
		}
	
		return config;
	}
	
	async getUserConfig() {
		let config = this.getLoadedUserConfig();
		return config;
	}
	
	async loadModulesConfig() {
		console.log("LOAD_MODULES")
		const response = await this.get("/modules/config");
		this.getServices().storage().set(AppService.MODULES_CONFIG_KEY, response);
		console.log("LOAD USER")
		const responseUser = await this.get("/user/info");
		this.getServices().storage().set(AppService.USER_CONFIG_KEY, responseUser);
	
		return response;
	}

	async loadUserDomainModulesConfig(data) {
		return await this.get("/modules/config/all", data);
	}
	
	getLoadedModulesConfig() {
		return this.getServices().storage().get(AppService.MODULES_CONFIG_KEY);
	}

	getLoadedUserConfig() {
		return this.getServices().storage().get(AppService.USER_CONFIG_KEY);
	}

	getLoadedUserDomainModulesConfig() {
		return this.getServices().storage().get(AppService.MODULES_CONFIG_KEY);
	}
	
	clearLoadedModulesConfig() {
		return this.getServices().storage().remove(AppService.MODULES_CONFIG_KEY);
	}
	
	addHooks(){
		this.getServices().security().addEventListener('logout', () => this.clearLoadedModulesConfig() );
		this.getServices().storage().addEventListener('storage', (e) => {
			console.log(e);
			if( e.key === AppService.MODULES_CONFIG_KEY && !e.newValue ){
				this.loadModulesConfig();
			}
		});
	}

	async getDL(params = {}) {
		const response = await this.get("/territory/dl", params);
		return response;
	}

	async getSecciones(dl, params = {}) {
		const response = await this.get("/territory/seccion?dl=" + dl, params);
		return response;
	}

	async getAllSections() {
		return await this.get("/territory/allsections");
	}

	async getLayers() {
		const response = await this.get("/layers");
		return response;
	}
	
	async fetchBaseLayers() {
		const response = await this.get("/layers/base");
		return response;
	}
	
	async fetchGroupedLayers() {
		const response = await this.get("/layers/grouped");
		return response;
	}
	
	async getMunicipalities(params = {}) {
		return await this.get('/territory/municipalities', params);
	}
	
	async getLocalities(params = {}) {
		return await this.get('/territory/localities', params);
	}
	
	async getLocalDistricts(params = {}) {
		return await this.get('/territory/localdistricts', params);
	}
	
	async getSections(params = {}) {
		return await this.get('/territory/sections', params);
	}
}