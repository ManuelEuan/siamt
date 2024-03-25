import configs from '../../configs'
import actions from './actions'
import mutations from './mutations'

const { product, time, theme, currencies } = configs

const { globalTheme, menuTheme, toolbarTheme, isToolbarDetached, isContentBoxed, isRTL } = theme
const { currency, availableCurrencies } = currencies

// state initial values
const state = {
  product,

  time,

  // currency
  currency,
  availableCurrencies,

  // themes and layout configurations
  globalTheme,
  menuTheme,
  toolbarTheme,
  isToolbarDetached,
  isContentBoxed,
  isRTL,

  // App.vue main toast
  toast: {
    show: false,
    color: 'black',
    message: '',
    timeout: 3000
  },

  // users filters and pagination
  users: [],
  usersData: {},
  usersFilters: {},
  usersTotalPages: 0,
  usersTotalItems: 0,

  // profiles filters and pagination
  profiles: [],
  profilesData: {},
  profilesFilters: {},
  profilesTotalPages: 0,
  profilesTotalItems: 0,

  // profiles filters and pagination
  inspectors: [],
  inspectorsData: {},
  inspectorsFilters: {},
  inspectorsTotalPages: 0,
  inspectorsTotalItems: 0,
}

export default {
  namespaced: true,
  state,
  actions,
  mutations
}
