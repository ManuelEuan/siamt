export default class ApiError extends Error {
	constructor (error) {
		super();
		this.error = error.response ? error.response.data.error : false;
		this.message = error.response ? error.response.data.message : false;
		this.details = error.response ? error.response.data.details : false;
	}
}