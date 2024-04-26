import ApiService from "@/services/api.service";

export default class SecurityService extends ApiService {
	
	static JWT_KEY = 'jwt';
	static DELTA_TIME = 10;
	static DWH_PERMISSIONS_KEY = '_dwh_';
	
	constructor(baseUrl, basePath) {
		super(baseUrl, basePath);
		// console.log('SecurityService Created');
		
		this.addHooks();
	}
	
	async login(username, password) {
		const response = await this.post('/login',{
			username: username,
			password: password
		}, true);
	
		if(response.token) {
			this.getServices().storage().set(SecurityService.JWT_KEY, response.token);
		}
	
		return true;
	}
	
	isAuthenticated() {
		let authenticated = false;
		const exp = this.getExpirationTime();
	
		if(exp !== null){
			const nowTime = Math.floor(new Date().getTime() / 1000);
			const tokenExpTime = exp - SecurityService.DELTA_TIME;
	
			authenticated = tokenExpTime >= nowTime;
		}
		// console.log('isAuthenticated', authenticated);
		return authenticated;
	}
	
	logout() {
		// console.log('LOGOUT');
		this.getServices().storage().remove(SecurityService.JWT_KEY);
		this.dispatchEvent(new Event('logout'));
		
		return true;
	}
	
	getExpirationTime() {
		return this.getTokenData('exp');
	}
	getUserFullName() {
		return this.getTokenData('ufn');
	}
	getSubject() {
		return this.getTokenData('sub');
	}
	getPermissions() {
		return this.getTokenData('prm');
	}
	
	hasModule(module) {
		const prm = this.getPermissions();
		
		return module in prm;
	}
	
	hasPermission(module, permission) {
		const prm = this.getPermissions();
		if(!!permission && !!module) {
			return prm[module].includes(permission);
		}

		return false;
	}
	
	dwhHasPermission(permission) {
		return this.hasPermission(SecurityService.DWH_PERMISSIONS_KEY, permission);
	}
	
	getTokenData(key) {
		const token = this.getToken();
		if(token !== null) {
			const data = this.parseTokenData(token);
			console.log('**********security ****************')
			console.log(data)
			return data[key];
		}
		return null;
	}
	
	parseTokenData (accessToken) {
		let payload = ''
		let tokenData = {}
	
		try {
			payload = accessToken.split('.')[1]
			tokenData = JSON.parse(atob(payload))
		} catch (error) {
			//Nothing to do - Fail silently
		}
	
		return tokenData
	}
	
	getToken(){
		return this.getServices().storage().get(SecurityService.JWT_KEY);
	}
	
	addHooks(){
		this.addResponseInterceptors(
			(response) => { return response; }, 
			(error) => { if( error.response.status === 401 && ([98, 99].indexOf(error.response.data.error) >= 0) ) this.logout(); return Promise.reject(error); }
		);
		
		this.getServices().storage().addEventListener('storage', (e) => {
			console.log("HOOK-STORAGE", e);
			if( e.key === SecurityService.JWT_KEY && !e.newValue ){
				this.logout();
			}
		});
	}

	async changePassword(user, pass) {
		const response = await this.post("/changepassword",{
			username: user,
			password: pass
		}, true);
		return response;
	}

	async getAllUsers() {
		const response = await this.get("/users");
		return response;
	}

}