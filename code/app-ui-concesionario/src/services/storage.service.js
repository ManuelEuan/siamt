import BaseService from "@/services/base.service";

export default class StorageService extends BaseService {
	constructor() {
		super();
		
		console.log("StorageService Created")
	}
	
	set(key, value){
		window.localStorage.setItem(key, JSON.stringify(value));
	}
	
	get(key){
		return JSON.parse(window.localStorage.getItem(key));
	}
	
	remove(key){
		window.localStorage.removeItem(key);
	}
	
	clear() {
		window.localStorage.clear();
	}
	
	addEventListener(event,fn) {
		window.addEventListener(event, fn);
	}
}
