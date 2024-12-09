<template>
  <v-container fluid>
      <v-row justify="center">
          <v-col cols="12" class="pa-0">
              <correctivos-filters />
          </v-col>
          <v-col cols="12" class="pa-0 mt-2">
              <correctivos-datatable />
          </v-col>
      </v-row>
  </v-container>
  </template>
  
<script>  

import CorrectivosFilters from "@/pages/admin/mantoUnidades/correctivos/components/CorrectivosFilters.vue";
import CorrectivosDatatable from "@/pages/admin/mantoUnidades/correctivos/components/CorrectivosDatatable.vue";

export default {
  name: 'CorrectivosPage',
  components: {
    CorrectivosFilters,
    CorrectivosDatatable
  },
  data() {
    return {
      
    }
  }
}
</script>


<style lang="scss" scoped>

</style>