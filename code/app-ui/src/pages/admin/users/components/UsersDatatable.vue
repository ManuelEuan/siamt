<template>
  <div class="wrapper">
    <users-datatable-dialogs ref="dialogs" />

    <v-data-table
      class="elevation-1"
      loading-text="Cargando información"
      :headers="headers"
      :items="users"
      :page-count="usersTotalPages"
      :server-items-length="usersTotalItems"
      :options.sync="options"
      :loading="loadingTable"
    >
      <template v-slot:item.activo="{ item }">
        <v-icon v-show="item.activo" size="medium" color="green"> mdi-check </v-icon>
        <v-icon v-show="!item.activo" size="medium" color="red">mdi-close</v-icon>
      </template>

      <template v-slot:item.acciones="{ item }">
        <v-tooltip v-if="permissions.includes('veus')" bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn 
              v-bind="attrs" 
              v-on="on" 
              icon 
              small
              @click="actionsHandler(item, 'view')"
            >
              <v-icon small> mdi-eye </v-icon>
            </v-btn>
          </template>
          <span>Ver ficha de usuario</span>
        </v-tooltip>

        <v-tooltip v-if="permissions.includes('edus')" bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              v-bind="attrs" 
              v-on="on" 
              icon 
              small
              @click="actionsHandler(item, 'edit')"
            >
              <v-icon small> mdi-account-edit </v-icon>
            </v-btn>
          </template>
          <span>Editar usuario</span>
        </v-tooltip>

        <v-tooltip v-if="permissions.includes('bous')" bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              v-bind="attrs" 
              v-on="on" 
              icon 
              small
              @click="actionsHandler(item, 'delete')"
            >
              <v-icon small v-show="item.activo"> mdi-delete </v-icon>
              <v-icon small v-show="!item.activo"> mdi-delete-off </v-icon>
            </v-btn>
          </template>
          <span>{{ item.activo ? "Desactivar" : "Activar" }} usuario</span>
        </v-tooltip>

        <v-tooltip v-if="permissions.includes('caco')" bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              v-bind="attrs" 
              v-on="on" 
              icon 
              small
              @click="actionsHandler(item, 'change')"
            >
              <v-icon small> mdi-pencil-lock </v-icon>
            </v-btn>
          </template>
          <span>Cambiar contrase&ntilde;a</span>
        </v-tooltip>

        <v-tooltip v-if="permissions.includes('reco')" bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              v-bind="attrs" 
              v-on="on" 
              icon 
              small
              @click="actionsHandler(item, 'reset')"
            >
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
import { mapActions, mapState } from "vuex";

export default {
  name: "UsersDatatable",
  components: {
    UsersDatatableDialogs,
  },
  data() {
    return {
      permissions: [],
      options: {
        users: [],
        page: 1,
        itemsPerPage: 10,
        sortBy: ['usuario'],
        sortDesc: [false],
        multiSort: true,
        mustSort: false,
      },
      loadingTable: true,
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
    ...mapState('app', ['users', 'usersTotalPages', 'usersTotalItems']),
  },
  methods: {
    ...mapActions('app', ['getUsers']),
    async loadUsersTable() {
      const { page, itemsPerPage, sortBy, sortDesc } = this.options;
      const data = { page, itemsPerPage, sortBy, sortDesc }; 
      this.getUsers({ data });
      this.loadingTable = false;
    },
    actionsHandler(user, action) {
      this.$refs.dialogs.user = user;

      switch (action) {
        case 'edit': this.$router.push(`/users/${user.id}/edit`); break;
        case 'view': this.$refs.dialogs.viewUser(); break;
        default: this.$refs.dialogs.show[action] = true;
      }
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
  async mounted() {
    const { usr } = await services.security().getPermissions();
    if (usr) this.permissions = usr;
  }
};
</script>
