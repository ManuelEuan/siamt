<template>
  <div>
    <v-data-table
      :page="page"
      :page-count="numberOfPages"
      :headers="headers"
      :items="users"
      class="elevation-1"
      :options.sync="options"
      :server-items-length="totalItems"
      :loading="loadingTable"
      :sort-by.sync="sortBy"
      :sort-desc.sync="sortDesc"
      loading-text="Cargando información"
      multi-sort
    >
      <template v-slot:[`item.actions`]="{ item }">
        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-icon small class="mr-2" v-bind="attrs" v-on="on" @click="viewUser(item)">
              mdi-eye
            </v-icon>
          </template>
          <span>Ver ficha de usuario</span>
        </v-tooltip>
        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-icon small class="mr-2" v-bind="attrs" v-on="on" @click="editUser(item)">
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
              @click="showDeleteDialog(item)"
            >
              mdi-trash-can
            </v-icon>
          </template>
          <span>Borrar usuario</span>
        </v-tooltip>
        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-icon small v-bind="attrs" class="mr-2" v-on="on"> mdi-pencil-lock </v-icon>
          </template>
          <span>Cambiar contraseña</span>
        </v-tooltip>
        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-icon small v-bind="attrs" v-on="on"> mdi-lock-reset </v-icon>
          </template>
          <span>Restablecer contraseña</span>
        </v-tooltip>
      </template>
    </v-data-table>

    <v-dialog transition="dialog-top-transition" max-width="600" v-model="deleteDialog">
      <v-card>
        <v-card-title class="text-h4">Confirmar Borrado</v-card-title>
        <v-card-text class="text-body-1">
          ¿Estás seguro de que deseas borrar este usuario?
        </v-card-text>
        <v-card-actions class="justify-end">
          <v-btn class="text-button" @click="deleteDialog = false">Cancelar</v-btn>
          <v-btn color="primary" class="text-button" @click="deleteUser">Borrar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import services from "@/services";

export default {
  name: "UsersDatatable",
  computed: {},
  created() {},
  watch: {
    options: {
      handler() {
        this.loadUsersTable();
      },
      deep: true,
    },
  },
  data() {
    return {
      users: [],
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
          value: "actions",
          sortable: false,
          width: "196px",
        },
      ],
      deleteDialog: false,
      deleteTarget: {
        id: null,
        nickname: null,
      },
    };
  },
  methods: {
    async loadUsersTable() {
      const { page, itemsPerPage, sortBy, sortDesc } = this.options;
      this.filters.currentPage = page;
      this.filters.itemsPerPage = itemsPerPage;

      const result = await services.admin().getUsers(this.filters);
      this.users = result.data;
      this.numberOfPages = result.pages;
      this.totalItems = result.total;
      if (sortBy.length === 1 && sortDesc.length === 1) {
        this.users = result.data.sort((a, b) => {
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
      this.loadingTable = false;
    },

    viewUser(user) {
      console.log(user);
    },
    editUser(user) {
      this.$router.push("/users/" + user.id + "/edit");
    },
    showDeleteDialog(user) {
      this.deleteTarget.id = user.id;
      this.deleteTarget.nickname = user.usuario;
      this.deleteDialog = true;
    },
    async deleteUser() {
      await services.admin().deleteUser(this.deleteTarget.id);
      this.loadUsersTable();
      this.deleteDialog = false;
    },
  },
};
</script>

<style scoped></style>
