import config from '@/configs';

// const createInstance =  async (fn, url) => { const { default: Service } = await fn(); return new Service(url); } 
// 
// export default {
// 	security: async () => await createInstance(() => import('@/services/security.service'), config.services.authUrl),
// 	app: async () => await createInstance(() => import('@/services/app.service'), config.services.appUrl),
// 	storage: () => { const { default: Service } = import('@/services/storage.service'); return new Service(); }
// };

import SecurityService from './security.service';
import AppService from './app.service';
import MantoUnidadesService from './mantounidades.service';
import InspectionsService from './inspections.service';
import AdminService from './admin.service';
import PersonService from './person.service';
import StatsService from './stats.service';
import StorageService from './storage.service';
import DashboarsService from './dashboard.service';
import DialogueService from './dialogue.service';
import UsersService from "./users.service";
import SignatureService from "./signature.service";
const getInstance = (classType, arg1) => { return classType._instance? classType._instance : (classType._instance = new classType(arg1)); }

export default {
	security: () => getInstance(SecurityService, config.services.authUrl),
	app: () => getInstance(AppService, config.services.appUrl),
	users: () => getInstance(UsersService, config.services.usersUrl),
	admin: () => getInstance(AdminService, config.services.adminUrl),
	mantounidades: () => getInstance(MantoUnidadesService, config.services.mantounidadesUrl),
	inspections: () => getInstance(InspectionsService, config.services.inspectionsUrl),
	person: () => getInstance(PersonService, config.services.personsUrl),
	stats: () => getInstance(StatsService, config.services.statsUrl),
	storage: () => getInstance(StorageService),
	dashboard : () => getInstance(DashboarsService, config.services.dashboardUrl),
	dialogue : () => getInstance(DialogueService, config.services.dialogueUrl),
	signature : () => getInstance(SignatureService, config.services.signatureUrl)
};