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
            <v-icon small class="mr-2" v-bind="attrs" v-on="on" @click="deleteUser(item)">
              mdi-trash-can
            </v-icon>
          </template>
          <span>Borrar usuario</span>
        </v-tooltip>
        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-icon small class="mr-2" v-bind="attrs" v-on="on" @click="changeUserPass(item)">
              mdi-pencil-lock
            </v-icon>
          </template>
          <span>Cambiar contrase&ntilde;a</span>
        </v-tooltip>
        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-icon small class="mr-2" v-bind="attrs" v-on="on" @click="resetUserPass(item)">
              mdi-lock-reset
            </v-icon>
          </template>
          <span>Restablecer contrase&ntilde;a</span>
        </v-tooltip>
      </template>
    </v-data-table>

    <v-dialog transition="dialog-top-transition" max-width="600" v-model="dialogs.delete">
      <v-card>
        <v-card-title class="text-uppercase primary--text text-h6 py-2">
          borrar usuario
        </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="text-lowercase text-body-1 py-2">
          ¿est&aacute;s seguro de que deseas eliminar definitivamente este usuario?
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions class="justify-end py-2">
          <v-btn class="text-button" @click="dialogs.delete = false" outlined text>
            cancelar
          </v-btn>
          <v-btn class="text-button" color="primary" @click="deleteUser"> borrar </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog transition="dialog-top-transition" max-width="600" v-model="dialogs.view">
      <v-card>
        <v-card-title class="text-uppercase primary--text text-h6 py-2"> ver usuario </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="py-0 my-0">
          <v-list class="pa-0 ma-0">
            <v-container class="pa-0 ma-0">
              <v-row dense>
                <template v-for="(value, key, index) in user">
                  <v-col v-if="!userChips.includes(key)" class="pa-0 ma-0" cols="6" :key="index">
                    <v-list-item>
                      <v-list-item-content class="py-2">
                        <v-list-item-title class="text-capitalize text-h7">
                          {{ userHeaders[key] ?? key }}
                        </v-list-item-title>
                        <v-list-item-subtitle class="text-lowercase text-body-1">
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
        <v-card-text class="py-0 my-0">
          <v-list class="pa-0 ma-0">
            <v-container class="pa-0 ma-0">
              <v-row dense>
                <template v-for="(value, key, index) in user">
                  <v-col v-if="userChips.includes(key)" class="pa-0 ma-0" cols="12" :key="index">
                    <v-list-item>
                      <v-list-item-content class="py-2">
                        <v-list-item-title class="text-capitalize text-h7">
                          {{ userHeaders[key] ?? key }}
                        </v-list-item-title>
                        <v-list-item-subtitle class="text-lowercase text-body-1">
                          <v-chip v-for="(v, i) in value" :key="i" v-text="v"></v-chip>
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
        <v-card-actions class="justify-end py-2">
          <v-btn color="primary" class="text-button" @click="dialogs.view = false"> cerrar </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog transition="dialog-top-transition" max-width="600" v-model="dialogs.change">
      <v-card>
        <v-card-title class="text-uppercase primary--text text-h6 py-2">
          cambiar contrase&ntilde;a
        </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="text-lowercase text-body-1 py-2">
          <v-list class="pa-0 ma-0">
            <v-container class="pa-0 ma-0">
              <v-row dense>
                <v-col class="pa-0 ma-0 pb-2" cols="12">
                  <v-text-field
                    v-model="user.clave"
                    label="Contraseña*"
                    hide-details="auto"
                    clearable
                    dense
                    outlined
                    required
                  />
                </v-col>
                <v-col class="pa-0 ma-0" cols="12">
                  <v-text-field
                    v-model="clave"
                    label="Confirmar contraseña*"
                    :error-messages="errorMessages.pass"
                    hide-details="auto"
                    clearable
                    dense
                    outlined
                    required
                  />
                </v-col>
              </v-row>
            </v-container>
          </v-list>
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions class="justify-end py-2">
          <v-btn class="text-button" @click="closeChangePass" outlined text> cancelar </v-btn>
          <v-btn :disabled="!isValid" class="text-button" color="primary" @click="changeUserPass">
            cambiar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog transition="dialog-top-transition" max-width="600" v-model="dialogs.reset">
      <v-card>
        <v-card-title class="text-uppercase primary--text text-h6 py-2">
          restablecer contrase&ntilde;a
        </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="text-lowercase text-body-1 py-2">
          ¿esta seguro que desea restablecer la contrase&ntilde;a?
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions class="justify-end py-2">
          <v-btn class="text-button" @click="dialogs.reset = false" outlined text> cancelar </v-btn>
          <v-btn class="text-button" color="primary" @click="resetUserPass"> restablecer </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import services from "@/services";

export default {
  name: "UsersDatatable",
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
      clave: null,
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
      dialogs: {
        delete: false,
        view: false,
        change: false,
        reset: false,
      },
    };
  },
  computed: {
    isSamePass() {
      return this.user.clave === this.clave;
    },
    isValid() {
      return !!this.clave && !!this.user.clave && this.isSamePass;
    },
    errorMessages() {
      return {
        pass: this.isSamePass ? "" : "Las contraseñas no coinciden.",
      };
    },
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

      this.dialogs.view = true;
    },
    editUser(user) {
      this.$router.push("/users/" + user.id + "/edit");
    },
    async deleteUser(user) {
      if (!user.id) {
        await services.admin().deleteUser(this.user.id);
        this.loadUsersTable();
        this.dialogs.delete = false;
        return;
      }

      this.user = user;
      this.dialogs.delete = true;
    },
    async changeUserPass(user) {
      if (!user.id) {
        if (!this.isValid) return;
        const { id, clave } = this.user;
        await services.admin().changeUserPass({ id, clave });
        this.closeChangePass();
        return;
      }

      this.user = user;
      this.dialogs.change = true;
    },
    async resetUserPass(user) {
      if (!user.id) {
        const { id } = this.user;
        await services.admin().resetUserPass({ id });
        this.dialogs.reset = false;
        return;
      }

      this.user = user;
      this.dialogs.reset = true;
    },
    closeChangePass() {
      this.dialogs.change = false;
      this.clave = null;
      this.user.clave = null;
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
