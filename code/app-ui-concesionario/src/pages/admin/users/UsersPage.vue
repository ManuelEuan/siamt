<template>
  <v-container fluid>
    <v-row justify="center">
      <v-col cols="12" class="pa-0">
        <users-filters />
      </v-col>
      <v-col
          cols="12"
          class="pa-0 mt-2"
      >
        <users-datatable />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import UsersFilters from "@/pages/admin/users/components/UsersFilters.vue";
import UsersDatatable from "@/pages/admin/users/components/UsersDatatable.vue";
export default{
  name : 'UsersPage',
  components : {
    UsersFilters,
    UsersDatatable
  },
  data () {
    return {

    }
  }
}
</script>

<style lang="scss" scoped>

</style>
