import Vuetify from '../../plugins/vuetify'

export default {
  /**
   * Main Toast
   */
  showToast: (state, toast) => {
    const { color, timeout, message } = toast

    state.toast = {
      message,
      color,
      timeout,
      show: true
    }
  },
  hideToast: (state) => {
    state.toast.show = false
  },
  resetToast: (state) => {
    state.toast = {
      show: false,
      color: 'black',
      message: '',
      timeout: 3000
    }
  },

  /**
   * Theme and Layout
   */
  setGlobalTheme: (state, theme) => {
    Vuetify.framework.theme.dark = theme === 'dark'
    state.globalTheme = theme
  },
  setRTL: (state, isRTL) => {
    Vuetify.framework.rtl = isRTL
    state.isRTL = isRTL
  },
  setContentBoxed: (state, isBoxed) => {
    state.isContentBoxed = isBoxed
  },
  setMenuTheme: (state, theme) => {
    state.menuTheme = theme
  },
  setToolbarTheme: (state, theme) => {
    state.toolbarTheme = theme
  },
  setTimeZone: (state, zone) => {
    state.time.zone = zone
  },
  setTimeFormat: (state, format) => {
    state.time.format = format
  },
  setCurrency: (state, currency) => {
    state.currency = currency
  },
  setToolbarDetached: (state, isDetached) => {
    state.isToolbarDetached = isDetached
  },

  /**
   * Users Filters and Pagination
   */
  setUsers: (state, users) => {
    state.users = users
  },
  setUsersData: (state, data) => {
    state.usersData = { ...data };
  },
  setUsersFilters: (state, filters) => {
    state.usersFilters = { ...filters };
  },
  setUsersTotalPages: (state, totalPages) => {
    state.usersTotalPages = totalPages
  },
  setUsersTotalItems: (state, totalItems) => {
    state.usersTotalItems = totalItems
  },

  /**
   * Profiles Filters and Pagination
   */
  setProfiles: (state, profiles) => {
    state.profiles = profiles
  },
  setProfilesData: (state, data) => {
    state.profilesData = { ...data };
  },
  setProfilesFilters: (state, filters) => {
    state.profilesFilters = { ...filters };
  },
  setProfilesTotalPages: (state, totalPages) => {
    state.profilesTotalPages = totalPages
  },
  setProfilesTotalItems: (state, totalItems) => {
    state.profilesTotalItems = totalItems
  },


  /**
  * Inspectors Filters and Pagination
  */
  setInspectors: (state, inspectors) => {
    console.log('inspectors******************')
    console.log(inspectors)
    state.inspectors = inspectors
  },
  setInspectorsData: (state, data) => {
    state.inspectorsData = { ...data };
  },
  setInspectorsFilters: (state, filters) => {
    console.log('mutation')
    console.log(filters)
    state.inspectorsFilters = { ...filters };
  },
  setInspectorsTotalPages: (state, totalPages) => {
    state.inspectorsTotalPages = totalPages
  },
  setInspectorsTotalItems: (state, totalItems) => {
    state.inspectorsTotalItems = totalItems
  },



    /**
  * Inspectors Filters and Pagination
  */
  setCompanies: (state, companies) => {
    console.log('companies******************')
    console.log(companies)
    state.companies = companies
  },
  setCompaniesData: (state, data) => {
    state.companiesData = { ...data };
  },
  setCompaniesFilters: (state, filters) => {
    console.log('mutation')
    console.log(filters)
    state.companiesFilters = { ...filters };
  },
  setCompaniesTotalPages: (state, totalPages) => {
    state.companiesTotalPages = totalPages
  },
  setCompaniesTotalItems: (state, totalItems) => {
    state.companiesTotalItems = totalItems
  },



  /**
  * DinamycRegisterInProcess Filters and Pagination
  */
  setDinamycRegisterInProcess: (state, dinamycRegisterInProcess) => {
    state.dinamycRegisterInProcess = dinamycRegisterInProcess
  },
  setDinamycRegisterInProcessData: (state, data) => {
    state.dinamycRegisterInProcessData = { ...data };
  },
  setDinamycRegisterInProcessFilters: (state, filters) => {
    state.dinamycRegisterInProcessFilters = { ...filters };
  },
  setDinamycRegisterInProcessTotalPages: (state, totalPages) => {
    state.dinamycRegisterInProcessTotalPages = totalPages
  },
  setDinamycRegisterInProcessTotalItems: (state, totalItems) => {
    state.dinamycRegisterInProcessTotalItems = totalItems
  },


  /**
  * Tickets Filters and Pagination
  */
    setTickets: (state, tickets) => {
      console.log('tickets******************')
      console.log(tickets)
      state.tickets = tickets
    },
    setTicketsData: (state, data) => {
      state.ticketsData = { ...data };
    },
    setTicketsFilters: (state, filters) => {
      console.log('mutation')
      console.log(filters)
      state.ticketsFilters = { ...filters };
    },
    setTicketsTotalPages: (state, totalPages) => {
      state.ticketsTotalPages = totalPages
    },
    setTicketsTotalItems: (state, totalItems) => {
      state.ticketsTotalItems = totalItems
    },

    /**
    * mantenimiento/Actividades Filters and Pagination
    */
    setActividades: (state, actividades) => {
      state.actividades = actividades
    },
    setActividadesData: (state, data) => {
      state.actividadesData = { ...data };
    },
    setActividadesFilters: (state, filters) => {
      state.actividadesFilters = { ...filters };
    },
    setActividadesTotalPages: (state, totalPages) => {
      state.actividadesTotalPages = totalPages
    },
    setActividadesTotalItems: (state, totalItems) => {
      state.actividadesTotalItems = totalItems
    },
}
