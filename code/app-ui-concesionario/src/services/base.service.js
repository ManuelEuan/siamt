import services from ".";

export default class BaseService extends EventTarget {
	
	#services
	
	constructor() {
		super();
		console.log("BaseService Created")

		this.#services = services;
	}
	getServices(){
		return this.#services;
	}

}