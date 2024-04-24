export default {
	required: v => !!v || 'Requerido.',
	min5char: v => !v || v.length >= 5 || 'Mínimo 5 caracteres.',
	min8char: v => !v || v.length >= 8 || 'Mínimo 8 caracteres.',
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
	ifNotEmptyInt: v => v === '' || v === null || v === undefined || /^\d+$/.test(v) || 'El campo solo puede contener números',
	ifNotEmptyFloat: v => v === '' || v === null || v === undefined || /^\d+(\.\d+)?$/.test(v) || 'El campo solo puede contener números',
	ifNotEmptyEmail: v => v === '' || v === null || v === undefined || /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v) || 'Correo electrónico inválido',
	json: v => {
		let status = true;
		try { JSON.parse(v); } catch (e) { status = false; }
		return !v || status || 'JSON valido requerido.';
	},
	email: v => {
		const regex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/g;
		return regex.test(v) || 'Email valido requerido.';
	},
	user: v => {
		const regex = /^[-.\w]+$/g;
		return regex.test(v) || 'El usuario contiene caracteres no admitidos.';
	},
	curp: v => {
		const regex = /^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9]{2}$/;
		return regex.test(v) || 'CURP válida requerida.'; 
	},
	rfc: v => {
		const regex = /^[A-Z&Ñ]{3,4}[0-9]{6}[A-V1-9][0-9A-Z][0-9]$/;
		return regex.test(v) || 'RFC válido requerido.'; 
	},
	latitud: v => {
		if (!v) return true; // Permitir que el campo esté vacío
	
		const regex = /^([-+]?)([\d]{1,2}(?:\.\d+)?|90(?:\.0+)?)$/;
		return regex.test(v) || 'Formato de latitud inválido.';
	},
	longitud: v => {
		if (!v) return true; // Permitir que el campo esté vacío
	
		const regex = /^([-+]?)([\d]{1,3}(?:\.\d+)?|180(?:\.0+)?)$/;
		return regex.test(v) || 'Formato de longitud inválido.';
	},
	telefono: v => {
		// const regex = /^\d{10}$/;
		// return regex.test(v) || 'Número de teléfono válido requerido.';
		const regex = /^\d{10}$/;
		return regex.test(v.replace(/\D/g, '')) || 'Número de teléfono válido requerido.';
	},
	
};
