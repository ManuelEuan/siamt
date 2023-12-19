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
            <v-icon
              small
              class="mr-2"
              v-bind="attrs"
              v-on="on"
              @click="viewUser(item)"
            >
              mdi-eye
            </v-icon>
          </template>
          <span>Ver ficha de usuario</span>
        </v-tooltip>
        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-icon
              small
              class="mr-2"
              v-bind="attrs"
              v-on="on"
              @click="editUser(item)"
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
              @click="showDialog('delete', item)"
            >
              mdi-trash-can
            </v-icon>
          </template>
          <span>Borrar usuario</span>
        </v-tooltip>
        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-icon small v-bind="attrs" class="mr-2" v-on="on">
              mdi-pencil-lock
            </v-icon>
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

    <v-dialog
      transition="dialog-top-transition"
      max-width="600"
      v-model="dialog.flag"
    >
      <v-card v-if="dialog.type === 'delete'">
        <v-card-title class="text-h5"> Confirmar Borrado </v-card-title>
        <v-card-text class="text-body-1">
          ¿Estás seguro de que deseas eliminar definitivamente este usuario?
        </v-card-text>
        <v-card-actions class="justify-end">
          <v-btn class="text-button" @click="dialog.flag = false">
            Cancelar
          </v-btn>
          <v-btn color="primary" class="text-button" @click="deleteUser">
            Borrar
          </v-btn>
        </v-card-actions>
      </v-card>

      <v-card v-else>
        <v-card-title class="text-uppercase primary--text">
          Ver Usuario
        </v-card-title>
        <v-divider></v-divider>
        <v-card-text>
          <v-list>
            <v-container class="pa-0 ma-0">
              <v-row dense>
                <template v-for="(value, key, index) in user">
                  <v-col v-if="!userChips.includes(key)" cols="6" :key="index">
                    <v-list-item>
                      <v-list-item-content>
                        <v-list-item-title class="text-capitalize">
                          {{ userHeaders[key] ?? key }}
                        </v-list-item-title>
                        <v-list-item-subtitle class="text-lowercase">
                          {{ value }}
                        </v-list-item-subtitle>
                      </v-list-item-content>
                    </v-list-item>
                  </v-col>
                </template>
              </v-row>
            </v-container>
          </v-list>
        </v-card-text>
        <v-divider></v-divider>
        <v-card-text>
          <v-list>
            <v-container class="pa-0 ma-0">
              <v-row dense>
                <template v-for="(value, key, index) in user">
                  <v-col v-if="userChips.includes(key)" cols="12" :key="index">
                    <v-list-item>
                      <v-list-item-content>
                        <v-list-item-title class="text-capitalize">
                          {{ userHeaders[key] ?? key }}
                        </v-list-item-title>
                        <v-list-item-subtitle>
                          <v-chip
                            v-for="(v, i) in value"
                            :key="i"
                            v-text="v"
                          ></v-chip>
                        </v-list-item-subtitle>
                      </v-list-item-content>
                    </v-list-item>
                  </v-col>
                </template>
              </v-row>
            </v-container>
          </v-list>
        </v-card-text>
        <v-card-actions class="justify-end">
          <v-btn
            color="primary"
            class="text-button"
            @click="dialog.flag = false"
          >
            Cerrar
          </v-btn>
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
      user: {},
      userHeaders: {
        apepat: "apellido paterno",
        apemat: "apellido materno",
        fecha_creacion: "fecha de creacion",
        fecha_modificacion: "fecha de modificación",
      },
      userChips: ["dominios", "modulos", "roles", "permisos"],
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
      dialog: {
        type: "",
        flag: false,
      },
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

      const res = await services.admin().getUsers(this.filters);
      this.users = res.data;
      this.numberOfPages = res.pages;
      this.totalItems = res.total;

      if (sortBy.length === 1 && sortDesc.length === 1) {
        this.users = res.data.sort((a, b) => {
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

    async viewUser(user) {
      const params = { id: user.id };
      const { usuario } = await services.admin().getEditUserInfo(params);
      let { dominios, modulos, roles, permisos, ...data } = usuario;

      for (const key in data) {
        if (!data[key]) delete data[key];
      }

      const domains = await services.admin().getDomains();
      const modules = await services.admin().getModules();
      const profiles = await services.admin().getAllRoles();
      const permissions = await services.admin().getAllPermissions();

      const getNamesById = (objs, ids) => {
        return objs.filter((o) => ids.includes(o.id)).map((o) => o.nombre);
      };

      dominios = getNamesById(domains, dominios);
      modulos = getNamesById(modules, modulos);
      roles = getNamesById(profiles, roles);
      permisos = getNamesById(permissions, permisos);

      this.user = { ...data };
      if (dominios.length > 0) this.user.dominios = dominios;
      if (modulos.length > 0) this.user.modulos = modulos;
      if (roles.length > 0) this.user.roles = roles;
      if (permisos.length > 0) this.user.permisos = permisos;

      this.showDialog("view");
    },
    editUser(user) {
      this.$router.push("/users/" + user.id + "/edit");
    },
    showDialog(type, user = {}) {
      this.dialog.type = type;
      this.deleteTarget.id = user.id;
      this.deleteTarget.nickname = user.usuario;
      this.dialog.flag = true;
    },
    async deleteUser() {
      await services.admin().deleteUser(this.deleteTarget.id);
      this.loadUsersTable();
      this.dialog.flag = false;
    },
  },
};
</script>
