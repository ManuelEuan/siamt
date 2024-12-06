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

  // inspectores filters and pagination
  inspectors: [],
  inspectorsData: {},
  inspectorsFilters: {},
  inspectorsTotalPages: 0,
  inspectorsTotalItems: 0,

  // companies filters and pagination
  companies: [],
  companiesData: {},
  companiesFilters: {},
  companiesTotalPages: 0,
  companiesTotalItems: 0,


  // dinamycProcess filters and pagination
  dinamycRegisterInProcess: [],
  dinamycRegisterInProcessData: {},
  dinamycRegisterInProcessFilters: {},
  dinamycRegisterInProcessTotalPages: 0,
  dinamycRegisterInProcessTotalItems: 0,

  // inspectores filters and pagination
  tickets: [],
  ticketsData: {},
  ticketsFilters: {},
  ticketsTotalPages: 0,
  ticketsTotalItems: 0,

  // mantenimiento/Actividades filters and pagination
  actividades: [],
  actividadesData: {},
  actividadesFilters: {},
  actividadesTotalPages: 0,
  actividadesTotalItems: 0,

  // mantenimiento/planes filters and pagination
  planes: [],
  planesData: {},
  planesTotalPages: 0,
  planesTotalItems: 0,
}

export default {
  namespaced: true,
  state,
  actions,
  mutations
}
