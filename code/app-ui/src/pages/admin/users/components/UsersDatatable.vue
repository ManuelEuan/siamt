<template>
  <div class="wrapper">
    <users-datatable-dialogs ref="dialogs" />

    <v-data-table
      class="elevation-1"
      loading-text="Cargando información"
      :page="page"
      :page-count="numberOfPages"
      :headers="headers"
      :items="items"
      :options.sync="options"
      :server-items-length="totalItems"
      :loading="loadingTable"
      :sort-by.sync="sortBy"
      :sort-desc.sync="sortDesc"
      multi-sort
    >
      <template v-slot:item.activo="{ item }">
        <v-icon v-show="item.activo" size="medium" color="green"> mdi-check </v-icon>
        <v-icon v-show="!item.activo" size="medium" color="red">mdi-close</v-icon>
      </template>

      <template v-slot:item.acciones="{ item }">
        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn v-bind="attrs" v-on="on" icon small @click="actionsHandler(item, 'view')">
              <v-icon small> mdi-eye </v-icon>
            </v-btn>
          </template>
          <span>Ver ficha de usuario</span>
        </v-tooltip>

        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn v-bind="attrs" v-on="on" icon small @click="actionsHandler(item, 'edit')">
              <v-icon small> mdi-account-edit </v-icon>
            </v-btn>
          </template>
          <span>Editar usuario</span>
        </v-tooltip>

        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn v-bind="attrs" v-on="on" icon small @click="actionsHandler(item, 'delete')">
              <v-icon small v-show="item.activo"> mdi-delete </v-icon>
              <v-icon small v-show="!item.activo"> mdi-delete-off </v-icon>
            </v-btn>
          </template>
          <span>{{ item.activo ? "Desactivar" : "Activar" }} usuario</span>
        </v-tooltip>

        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn v-bind="attrs" v-on="on" icon small @click="actionsHandler(item, 'change')">
              <v-icon small> mdi-pencil-lock </v-icon>
            </v-btn>
          </template>
          <span>Cambiar contrase&ntilde;a</span>
        </v-tooltip>

        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn v-bind="attrs" v-on="on" icon small @click="actionsHandler(item, 'reset')">
              <v-icon small> mdi-lock-reset </v-icon>
            </v-btn>
          </template>
          <span>Restablecer contrase&ntilde;a</span>
        </v-tooltip>
      </template>
    </v-data-table>
  </div>
</template>

<script>
import UsersDatatableDialogs from "@/pages/admin/users/components/UsersDatatableDialogs";
import services from "@/services";

export default {
  name: "UsersDatatable",
  components: {
    UsersDatatableDialogs,
  },
  data() {
    return {
      // users: [],
      filters: {},
      page: 1,
      totalItems: 0,
      options: {},
      sortBy: "nombre_completo",
      loadingTable: true,
      sortDesc: false,
      numberOfPages: 0,
      itemsPerPage: 10,
      headers: [
        {
          text: "Usuario",
          value: "usuario",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Nombre",
          value: "nombre_completo",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "correo",
          value: "correo",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Activo",
          value: "activo",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Acciones",
          value: "acciones",
          align: "center",
          sortable: false,
          width: "196px",
        },
      ],
    };
  },
  computed: {
    items() {
      const fltrUsers = this.$store.state.app.usuariosFiltrados;
      return fltrUsers.length ? fltrUsers : this.$store.state.app.usuarios;
    }
  },
  methods: {
    async loadUsersTable() {
      const { page, itemsPerPage, sortBy, sortDesc } = this.options;

      this.filters.currentPage = page;
      this.filters.itemsPerPage = itemsPerPage;

      const res = await services.admin().getUsers(this.filters);
      const users = res.data.map(u => ({
        ...u,
        nombre_completo: `${u.nombre} ${u.apepat} ${u.apemat ?? ""}`.trim(),
      }));

      this.numberOfPages = res.pages;
      this.totalItems = res.total;

      if (sortBy.length === 1 && sortDesc.length === 1) {
        users.sort((a, b) => {
          const sortA = a[sortBy[0]];
          const sortB = b[sortBy[0]];

          if (sortDesc[0]) {
            if (sortA < sortB) return 1;
            if (sortA > sortB) return -1;
            return 0;
          } else {
            if (sortA < sortB) return -1;
            if (sortA > sortB) return 1;
            return 0;
          }
        });
      }

      this.$store.commit('app/setUsuarios', users);
      this.loadingTable = false;
    },
    actionsHandler(user, action) {
      this.$refs.dialogs.user = user;

      if (action === "edit") this.$router.push(`/users/${user.id}/edit`);
      else if (action === "view") this.$refs.dialogs.viewUser();
      else this.$refs.dialogs.show[action] = true;
    },
  },
  watch: {
    options: {
      handler() {
        this.loadUsersTable();
      },
      deep: true,
    },
  },
};
</script>
