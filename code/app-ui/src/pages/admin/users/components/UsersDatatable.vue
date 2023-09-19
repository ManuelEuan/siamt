<template>
<v-data-table
    :page="page"
    :page-count="numberOfPages"
    :headers = "headers"
    :items = "users"
    class="elevation-1"
    :options.sync = "options"
    :server-items-length = totalItems
    :loading = "loadingTable"
    :sort-by.sync="sortBy"
    :sort-desc.sync="sortDesc"
    loading-text ="Cargando información"
    multi-sort
>
  <template v-slot:[`item.actions`]="{ item }">

    <v-tooltip bottom>
      <template v-slot:activator="{ on, attrs }"
      >
        <v-icon
            small
            class="mr-2"
            v-bind="attrs"
            v-on="on"
            @click = "viewUser(item)"
        >
          mdi-eye
        </v-icon>
      </template>
      <span>Ver ficha de usuario</span>
    </v-tooltip>
    <v-tooltip bottom >
      <template v-slot:activator="{ on, attrs }">
        <v-icon
            small
            class="mr-2"
            v-bind="attrs"
            @click = "editUser(item)"
            v-on="on"
        >
          mdi-account-edit
        </v-icon>
      </template>
      <span>Editar usuario</span>
    </v-tooltip>
    <v-tooltip bottom>
      <template v-slot:activator="{ on, attrs }">
        <v-icon
            small
            class="mr-2"
            v-bind="attrs"
            v-on="on"
        >
          mdi-trash-can
        </v-icon>
      </template>
      <span>Borrar usuario</span>
    </v-tooltip>
    <v-tooltip bottom>
      <template v-slot:activator="{ on, attrs }">
        <v-icon
            small
            v-bind="attrs"
            class="mr-2"
            v-on="on"
        >
          mdi-pencil-lock
        </v-icon>
      </template>
      <span>Cambiar contraseña</span>
    </v-tooltip>
    <v-tooltip bottom>
      <template v-slot:activator="{ on, attrs }">
        <v-icon
            small
            v-bind="attrs"
            v-on="on"
        >
          mdi-lock-reset
        </v-icon>
      </template>
      <span>Restablecer contraseña</span>
    </v-tooltip>
  </template>
</v-data-table>
</template>

<script>
import services from "@/services";

export default {
  name: "UsersDatatable",
  computed : {
  },
  created() {

  },
  watch : {
    options : {
      handler () {
        this.loadUsersTable();
      },
      deep : true
    },
  },
  data () {
    return {
      users : [],
      filters : {},
      page : 1,
      totalItems : 0,
      options : {},
      sortBy: 'nombre_completo',
      loadingTable : true,
      sortDesc: false,
      numberOfPages : 0,
      itemsPerPage : 10,
      headers : [
        {
          text : "Usuario" ,
          value : "usuario",
          align : "center",
          class : "font-weight-bold"
        },
        {
          text : "Nombre" ,
          value : "nombre_completo",
          align : "center",
          class : "font-weight-bold"
        },
        {
          text : "correo" ,
          value : "correo",
          align : "center",
          class : "font-weight-bold"
        },
        {
          text : "Activo" ,
          value : "activo",
          align : "center",
          class : "font-weight-bold"
        },
        {
          text: "Acciones",
          value: "actions",
          sortable: false,
          width: '196px'
        }
      ]
    }
  },
  methods : {
  async loadUsersTable() {
     const {page, itemsPerPage, sortBy, sortDesc} = this.options;
     this.filters.currentPage = page;
     this.filters.itemsPerPage = itemsPerPage;
     const result = await services.admin().getUsers(this.filters);
     console.log("-> data", result);
     this.users = result.data;
    this.numberOfPages = result.pages;
    this.totalItems = result.total;
    if (sortBy.length === 1 && sortDesc.length === 1) {
      this.users = result.data.sort((a, b) => {
        const sortA = a[sortBy[0]]
        const sortB = b[sortBy[0]]

        if (sortDesc[0]) {
          if (sortA < sortB) return 1
          if (sortA > sortB) return -1
          return 0
        } else {
          if (sortA < sortB) return -1
          if (sortA > sortB) return 1
          return 0
        }
      })
    }
    this.loadingTable = false;
   },

    viewUser(user) {
    console.log(user);
    },
    editUser(user){
    this.$router.push('/users/'+user.id+'/edit')

    }

  }
}
</script>

<style scoped>

</style>