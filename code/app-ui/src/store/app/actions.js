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
      message: message + ' ' + ((error && error.message)? error.message : ''),
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

export default {
  showToast,
  showError,
  showSuccess,
  getUsers,
}
