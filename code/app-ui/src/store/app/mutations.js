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
* DinamycRegisterInProcess Filters and Pagination
*/
  setDinamycRegisterInProcess: (state, dinamycRegisterInProcess) => {
    console.log('dinamycRegisterInProcssssssssssssssssssssssssess')
    console.log(dinamycRegisterInProcess)
    state.dinamycRegisterInProcess = dinamycRegisterInProcess
  },
  setDinamycRegisterInProcessData: (state, data) => {
    console.log('mutation1************************************************')
    console.log(data)
    state.dinamycRegisterInProcessData = { ...data };
  },
  setDinamycRegisterInProcessFilters: (state, filters) => {
    console.log('mutation2************************************************')
    console.log(filters)
    state.dinamycRegisterInProcessFilters = { ...filters };
  },
  setDinamycRegisterInProcessTotalPages: (state, totalPages) => {
    console.log('mutation3***********************************************')
    console.log(totalPages)

    state.dinamycRegisterInProcessTotalPages = totalPages
  },
  setDinamycRegisterInProcessTotalItems: (state, totalItems) => {
    console.log('mutation4************************************************')
    console.log(totalItems)

    state.dinamycRegisterInProcessTotalItems = totalItems
  },
}
