export default {
	required: v => !!v || 'Requerido.',
	max3chars: v => !v || (v && v.length <= 3) || 'Máximo 3 caracteres.',
	max13chars: v => !v || (v && v.length <= 13) || 'Máximo 13 caracteres.',
	max18chars: v => !v || (v && v.length <= 18) || 'Máximo 18 caracteres.',
	max20chars: v => !v || (v && v.length <= 20) || 'Máximo 20 caracteres.',
	max25chars: v => !v || (v && v.length <= 25) || 'Máximo 25 caracteres.',
	max50chars: v => !v || (v && v.length <= 50) || 'Máximo 50 caracteres.',
	max100chars: v => !v || (v && v.length <= 100) || 'Máximo 100 caracteres.',
	max250chars: v => !v || (v && v.length <= 250) || 'Máximo 250 caracteres.',
	max300chars: v => !v || (v && v.length <= 300) || 'Máximo 300 caracteres.',
	intNumber: v => !v || /^\d*$/.test(v) || 'Número requerido.',
	positiveIntNumber: v => !v || /^\d*$/.test(v) || 'Número igual o mayor a cero requerido.',
	json: v => {
		let status = true;
		try { JSON.parse(v); } catch(e){ status = false; }
		return !v || status || 'JSON valido requerido.';
	},
	email: v => {
		const regex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/g;
		return regex.test(v) || 'Email valido requerido.';
	},
	user: v => {
		const regex = /^[-.\w]+$/g;
		return regex.test(v) || 'Solo se permiten: . _ - y números y letras sin acentos ni espacios.';
	},
};
