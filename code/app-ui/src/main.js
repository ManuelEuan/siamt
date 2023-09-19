import Vue from 'vue';
import App from './App.vue';

// VUEX - https://vuex.vuejs.org/
import store from './store';

// VUE-ROUTER - https://router.vuejs.org/
import router from './router';

// Para máscaras de inputs
import VueTheMask from 'vue-the-mask'
// Para saber el tipo de dispositivo en que se accede
import device from 'vue-device-detector'



import { vMaska } from "maska"
Vue.directive('maska', vMaska);

// PLUGINS
import vuetify from './plugins/vuetify';
import i18n from './plugins/vue-i18n';
import './plugins/vue-shortkey';
import './plugins/vue-head';
import './plugins/vue-gtag';
import './plugins/apexcharts';
import './plugins/echarts';
import './plugins/animate';
import './plugins/clipboard';
import './plugins/moment';
import './plugins/vee-validate';
import './plugins/vue-sweetalert2';
import './plugins/r-common';
import './plugins/vue-gmap';
import './plugins/vue-highcharts';
import  VueToastr from 'vue-toastr';
import VModal from "vue-js-modal";

// FILTERS
import './filters/capitalize';
import './filters/lowercase';
import './filters/uppercase';
import './filters/formatCurrency';
import './filters/formatDate';

// STYLES
// Main Theme SCSS
import './assets/scss/theme.scss';

// Animation library - https://animate.style/
import 'animate.css/animate.min.css';
// import 'animate.css';

// Set this to false to prevent the production tip on Vue startup.
Vue.config.productionTip = false;

Vue.use(VueToastr);
Vue.use(VModal);
Vue.use(VueTheMask);
Vue.use(device);

/*
|---------------------------------------------------------------------
| Main Vue Instance
|---------------------------------------------------------------------
|
| Render the vue application on the <div id="app"></div> in index.html
|
| https://vuejs.org/v2/guide/instance.html
|
*/
export default new Vue({
  i18n,
  vuetify,
  router,
  store,
  render: (h) => h(App)
}).$mount('#app');
