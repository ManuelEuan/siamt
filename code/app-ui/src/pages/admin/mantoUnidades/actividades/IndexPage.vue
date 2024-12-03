<template>
  <v-container fluid>
      <v-row justify="center">
          <v-col cols="12" class="pa-0">
              <actividades-filters />
          </v-col>
          <v-col cols="12" class="pa-0 mt-2">
              <actividades-datatable />
          </v-col>
      </v-row>
  </v-container>
  </template>
  
<script>  

import ActividadesFilters from "@/pages/admin/mantoUnidades/actividades/components/ActividadesFilters.vue";
import ActividadesDatatable from "@/pages/admin/mantoUnidades/actividades/components/ActividadesDatatable.vue";

export default {
  name: 'ActividadesPage',
  components: {
    ActividadesFilters,
    ActividadesDatatable
  },
  data() {
    return {
      
    }
  }
}
</script>


<style lang="scss" scoped>

</style>