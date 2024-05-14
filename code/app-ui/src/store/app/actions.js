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

const getDinamycRegisterInProcess = async ({ state, commit }, { data, filters }) => {
  if (data) commit('setDinamycRegisterInProcessData', data)
  if (filters) commit('setDinamycRegisterInProcessFilters', filters)

  const { dinamycRegisterInProcess, totalPages, totalItems } = await services.inspections().getDinamycRegisterInProcess({
    ...state.dinamycRegisterInProcessData,
    filters: state.dinamycRegisterInProcessFilters
  })
  commit('setDinamycRegisterInProcess', dinamycRegisterInProcess)
  commit('setDinamycRegisterInProcessTotalPages', totalPages)
  commit('setDinamycRegisterInProcessTotalItems', totalItems)
}

export default {
  showToast,
  showError,
  showSuccess,
  getUsers,
  getProfiles,
  getInspectors,
  getDinamycRegisterInProcess,
}
