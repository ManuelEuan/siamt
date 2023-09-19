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
import EventService from './event.service';
import AdminService from './admin.service';
import PersonService from './person.service';
import StructureService from './structure.service';
import CensusService from './census.service';
import StatsService from './stats.service';
import AssignmentsService from './assignments.service';
import DwhService from './dwh.service';
import StorageService from './storage.service';
import DashboarsService from './dashboard.service';
import CampaignsService from './campaigns.service';
import DialogueService from './dialogue.service';
import CallcenterService from  './callcenter.service'
import TrackerService from "@/services/tracker.service";
import ComitesService from "@/services/comites.service";
import FinderService from  './finder.service';
const getInstance = (classType, arg1) => { return classType._instance? classType._instance : (classType._instance = new classType(arg1)); }

export default {
	security: () => getInstance(SecurityService, config.services.authUrl),
	app: () => getInstance(AppService, config.services.appUrl),
	event: () => getInstance(EventService, config.services.eventUrl),
	callcenter: () => getInstance(CallcenterService,config.services.callcenterUrl),
	admin: () => getInstance(AdminService, config.services.adminUrl),
	census: () => getInstance(CensusService, config.services.censusUrl),
	person: () => getInstance(PersonService, config.services.personsUrl),
	structure: () => getInstance(StructureService, config.services.structureUrl),
	dwh: () => getInstance(DwhService, config.services.dwhUrl),
	stats: () => getInstance(StatsService, config.services.statsUrl),
	assignments: () => getInstance(AssignmentsService, config.services.assignmentsUrl),
	storage: () => getInstance(StorageService),
	dashboard : () => getInstance(DashboarsService, config.services.dashboardUrl),
	campaigns : () => getInstance(CampaignsService, config.services.campaignsUrl),
	dialogue : () => getInstance(DialogueService, config.services.dialogueUrl),
	tracker : () => getInstance(TrackerService, config.services.trackerUrl),
	comites : () => getInstance(ComitesService, config.services.comitesUrl),
	finder : () => getInstance(FinderService, config.services.finderUrl),
};