import services from '@/services'

const showToast = ({ state, commit }, message) => {
  if (state.toast.show) commit('hideToast')

  setTimeout(() => {
    commit('showToast', {
      color: 'black',
      message,
      timeout: 3000
    })
  })
}

const showError = ({ state, commit }, { message = 'Failed!', error }) => {
  if (state.toast.show) commit('hideToast')

  setTimeout(() => {
    commit('showToast', {
      color: 'error',
      message: message + ' ' + ((error && error.message) ? error.message : ''),
      timeout: 10000
    })
  })
}

const showSuccess = ({ state, commit }, message) => {
  if (state.toast.show) commit('hideToast')

  setTimeout(() => {
    commit('showToast', {
      color: 'success',
      message,
      timeout: 3000
    })
  })
}

const getUsers = async ({ state, commit }, { data, filters }) => {
  if (data) commit('setUsersData', data)
  if (filters) commit('setUsersFilters', filters)

  const { users, totalPages, totalItems } = await services.admin().getUsers({
    ...state.usersData,
    filters: state.usersFilters
  })

  commit('setUsers', users)
  commit('setUsersTotalPages', totalPages)
  commit('setUsersTotalItems', totalItems)
}

const getProfiles = async ({ state, commit }, { data, filters }) => {
  if (data) commit('setProfilesData', data)
  if (filters) commit('setProfilesFilters', filters)

  const { profiles, totalPages, totalItems } = await services.admin().getProfiles({
    ...state.profilesData,
    filters: state.profilesFilters
  })

  commit('setProfiles', profiles)
  commit('setProfilesTotalPages', totalPages)
  commit('setProfilesTotalItems', totalItems)
}

const getInspectors = async ({ state, commit }, { data, filters }) => {
  if (data) commit('setInspectorsData', data)
  if (filters) commit('setInspectorsFilters', filters)
  const { inspectors, totalPages, totalItems } = await services.inspections().getInspectors({
    ...state.inspectorsData,
    filters: state.inspectorsFilters
  })

  commit('setInspectors', inspectors)
  commit('setInspectorsTotalPages', totalPages)
  commit('setInspectorsTotalItems', totalItems)
}

const getCompanies = async ({ state, commit }, { data, filters }) => {
  if (data) commit('setCompaniesData', data)
  if (filters) commit('setCompaniesFilters', filters)
  const { companies, totalPages, totalItems } = await services.admin().getCompanies({
    ...state.companiesData,
    filters: state.companiesFilters
  })

  commit('setCompanies', companies)
  commit('setCompaniesTotalPages', totalPages)
  commit('setCompaniesTotalItems', totalItems)
}

const getDinamycRegisterInProcess = async ({ state, commit }, { data, filters }) => {
  if (data) commit('setDinamycRegisterInProcessData', data)
  if (filters) commit('setDinamycRegisterInProcessFilters', filters)

  const { dinamycRegisterInProcess, totalPages, totalItems } = await services.admin().getDinamycRegisterInProcess({
    ...state.dinamycRegisterInProcessData,
    filters: state.dinamycRegisterInProcessFilters
  })
  commit('setDinamycRegisterInProcess', dinamycRegisterInProcess)
  commit('setDinamycRegisterInProcessTotalPages', totalPages)
  commit('setDinamycRegisterInProcessTotalItems', totalItems)
}

const getTickets = async ({ state, commit }, { data, filters }) => {
  
  if (data) commit('setTicketsData', data)
  if (filters) commit('setTicketsFilters', filters)
  const { tickets, totalPages, totalItems } = await services.inspections().getTickets({
...state.ticketsData,
filters: state.ticketsFilters
})
console.log('tickets actions************************************')
console.log(tickets)

  commit('setTickets', tickets)
  commit('setTicketsTotalPages', totalPages)
  commit('setTicketsTotalItems', totalItems)
}

const getActividades = async ({ state, commit }, { data, filters }) => {
  if (data) commit('setActividadesData', data);
  if (filters) commit('setActividadesFilters', filters);

  try {
    const response = await services.mantounidades().getActividades({
      ...state.actividadesData,
      filters: state.actividadesFilters,
    });

    const actividades = response.items || []; // Datos de actividades
    const totalPages = response.totalPages || 1; // Total de páginas
    const totalItems = response.totalItems || actividades.length; // Total de elementos

    // Mutaciones para Vuex
    commit('setActividades', actividades);
    commit('setActividadesTotalPages', totalPages);
    commit('setActividadesTotalItems', totalItems);

  } catch (error) {
    console.error('Error fetching actividades:', error);
  }
};

const getPlanes = async ({ state, commit }, { data, filters }) => {
  if (data) commit('setPlanesData', data);
  if(filters) console.log("")

  try {
    const response = await services.mantounidades().getPlanes({
      ...state.planesData,
    });

    // Verifica la respuesta
    console.log("Respuesta completa del servicio:", response);

    const planes = response.items || []; // Datos de planes
    const totalPages = response.totalPages || 1; // Total de páginas
    const totalItems = response.totalItems || planes.length; // Total de elementos

    // Mutaciones para Vuex
    commit('setPlanes', planes);
    commit('setPlanesTotalPages', totalPages);
    commit('setPlanesTotalItems', totalItems);

  } catch (error) {
    console.error('Error fetching planes:', error);
  }
};

const getMantenimientos = async ({ state, commit }, { data, filters }) => {
  if (data) commit('setCorrectivosData', data);
  if (filters) commit('setCorrectivosFilters', filters);

  try {
    const response = await services.mantounidades().getMantenimientos({
      ...state.correctivosData,
      filters: state.correctivosFilters,
    });

    // Usa la simulación como respuesta
    const correctivos = response.items || [];
    const totalPages = response.totalPages || 1;
    const totalItems = response.totalItems || correctivos.length;

    // Mutaciones para Vuex
    commit('setCorrectivos', correctivos);
    commit('setCorrectivosTotalPages', totalPages);
    commit('setCorrectivosTotalItems', totalItems);

  } catch (error) {
    console.error('Error fetching correctivos:', error);
  }
};

const getPreventivos = async ({commit }, { data, filters }) => {
  if (data) commit('setCorrectivosData', data);
  if (filters) console.log("Aplicando filtros:", filters);

  try {
    const simulatedResponse = {
      items: [
        {
          id: 2,
          marca: "Marca Y",
          modelo: "Modelo 456",
          serie: "SERIE67890",
          placa: "XYZ-5678",
          año: 2018,
          ultimo: "2024-11-20",
          km_actual: 2000,
          sig_plan: "Prueba de plan de mantenimiento",
          acciones: "Ajuste y cambio de componentes principales",
          siguiente: '100 Km'
        },
        {
          id: 3,
          marca: "Marca Z",
          modelo: "Modelo 789",
          serie: "SERIE11223",
          placa: "LMN-9101",
          año: 2022,
          ultimo: "2024-11-30",
          km_actual: 800,
          sig_plan: "Prueba de plan de mantenimiento",
          acciones: "Limpieza de componentes y ajustes menores",
          siguiente: '100 Km',
        },
      ],
      totalPages: 1,
      totalItems: 2,
    };

    console.log("Simulación de respuesta:", simulatedResponse);

    // Usa la simulación como respuesta
    const preventivos = simulatedResponse.items || [];
    const totalPages = simulatedResponse.totalPages || 1;
    const totalItems = simulatedResponse.totalItems || preventivos.length;

    // Mutaciones para Vuex
    commit('setPreventivos', preventivos);
    commit('setPreventivosTotalPages', totalPages);
    commit('setPreventivosTotalItems', totalItems);

  } catch (error) {
    console.error('Error fetching preventivos:', error);
  }
};

export default {
  showToast,
  showError,
  showSuccess,
  getUsers,
  getProfiles,
  getInspectors,
  getCompanies,
  getDinamycRegisterInProcess,
  getTickets,
  getActividades,
  getPlanes,
  getMantenimientos,
  getPreventivos
}
