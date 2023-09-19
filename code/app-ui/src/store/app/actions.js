import services from '../../services/index';
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


const fetchUsuarios = async ({commit, state}) => {
  const filtros = {
    paginaActual : state.paginaActual,
    porPagina : state.porPagina
  }
  const usuarios = await services.admin().getUsers(filtros);
  console.log("-> usuarios", usuarios);
  commit('setUsuarios',usuarios);
  commit('setTotalUsuarios', usuarios.totalUsuarios)
}

const cambiarPagina = ({commit, dispatch}, pagina) => {
  commit('setPaginaActual', pagina);
  dispatch('fetchUsuarios');
}

export default {
  showToast,
  showError,
  showSuccess,
  fetchUsuarios,
  cambiarPagina,
}
