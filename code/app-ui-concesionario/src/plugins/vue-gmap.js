import Vue from "vue";
import GmapVue from 'gmap-vue';

import config from '@/configs'

Vue.use(GmapVue, {
  load: {
    key: config.maps.key,
    // libraries: 'places'
  },
  installComponents: true,
});