<template>
  <v-container fluid>
      <v-row justify="center">
          <v-col cols="12" class="pa-0">
              <preventivos-filters />
          </v-col>
          <v-col cols="12" class="pa-0 mt-2">
              <preventivos-datatable />
          </v-col>
      </v-row>
  </v-container>
  </template>
  
<script>  

import PreventivosFilters from "@/pages/admin/mantoUnidades/preventivos/components/PreventivosFilters.vue";
import PreventivosDatatable from "@/pages/admin/mantoUnidades/preventivos/components/PreventivosDatatable.vue";

export default {
  name: 'PreventivosPage',
  components: {
    PreventivosFilters,
    PreventivosDatatable
  },
  data() {
    return {
      
    }
  }
}
</script>


<style lang="scss" scoped>

</style>