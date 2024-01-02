<template>
<v-card flat>
  <v-toolbar>
    <v-toolbar-title>Usuarios</v-toolbar-title>
    <v-spacer></v-spacer>
    <v-tooltip top>
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          color="primary"
          class="me-1"
          @click="newUser"
          v-bind="attrs"
          v-on="on"
        >
          <v-icon> mdi-account-plus </v-icon>
        </v-btn>
      </template>
      <span>Nuevo usuario</span>
    </v-tooltip>
    <v-divider
      vertical
      class="mx-2"
    ></v-divider>
    <v-badge
      overlap
      :content="numberOfActiveFilters"
      :value="numberOfActiveFilters"
    >
      <v-dialog
        v-model="filterDialog"
        width="600"
      >
        <template v-slot:activator="{ on, attrs }">
          <v-btn
            fab
            color="secondary"
            v-bind="attrs"
            v-on="on"
            small
          >
            <v-icon>mdi-filter</v-icon>
          </v-btn>
        </template>

        <v-card>
          <v-card-title class="text-uppercase primary--text text-h6 py-2"> Filtros </v-card-title>
          <v-divider />
          <v-card-text>
            <v-row dense>
              <v-col
                cols="6"
                md="6"
                xl="6"
              >
                <v-checkbox v-model="filter.active" @click="filter.inactive = false">
                  <template v-slot:label> Activo </template>
                </v-checkbox>
              </v-col>
              <v-col
                cols="6"
                md="6"
                xl="6"
              >
                <v-checkbox v-model="filter.inactive" @click="filter.active = false">
                  <template v-slot:label> Inactivo </template>
                </v-checkbox>
              </v-col>
              <v-col
                cols="12"
                md="6"
                xl="4"
              >
              <v-text-field
                v-model="filter.username"
                label="Usuario"
                hide-details="auto"
                clearable
                dense
                outlined
              />
              </v-col>
              <v-col
                cols="12"
                md="6"
                xl="4"
              >
              <v-text-field
                v-model="filter.name"
                label="Nombre"
                hide-details="auto"
                clearable
                dense
                outlined
              />
              </v-col>
            </v-row>
          </v-card-text>
          <v-divider />
          <v-card-actions class="justify-end py-2">
            <v-spacer></v-spacer>
            <v-btn
              color="warning"
              text
              @click="cleanFilters"
            >
              Borrar filtros
            </v-btn>
            <v-btn
              color="error"
              text
              @click="filterDialog = false"
            >
              Cerrar
            </v-btn>
            <v-btn
              color="primary"
              text
              @click="applyFilters()"
            >
              Aplicar
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-badge>
  </v-toolbar>
</v-card>
</template>

<script>
export default {
  name: "UsersFilters",
  data() {
    return {
      filterDialog: false,
      filter: {
        active: false,
        inactive: false,
        name: '',
        username: '',
      },
    };
  },
  computed: {
    numberOfActiveFilters() {
      return Object.values(this.filter)
        .filter(f => f===true || (typeof(f)==='string' && f.trim() !== ''))
        .length;
    },
    users() {
      return this.$store.state.app.usuarios;
    }
  },
  methods: {
    cleanFilters() {
      this.filter = {
        active: false,
        inactive: false,
        name: '',
        user: '',
        email: ''
      };

      this.$store.commit('app/setUsuariosFiltrados', []);
      this.filterDialog = false;
    },
    applyFilters() {
      let usr = this.users;
      if (this.filter.active) usr = usr.filter(u => u.activo);
      if (this.filter.inactive) usr = usr.filter(u => !u.activo);
      if (this.filter.username) usr = usr.filter(u => u.usuario.toLowerCase().includes(this.filter.username.toLowerCase()));
      if (this.filter.name) usr = usr.filter(u => u.nombre_completo.toLowerCase().includes(this.filter.name.toLowerCase()));

      if(!usr.length) {
        const msg = 'No hay usuarios que cumplan con los criterios de filtrado.';
        this.$store.dispatch('app/showError', { message: msg });
      }

      this.$store.commit('app/setUsuariosFiltrados', usr);
      this.filterDialog = false;
    },
    newUser() {
      this.$router.push("/users/new");
    },
  },
  watch: {
    users() {
      this.applyFilters();
    }
  }
};
</script>

<style scoped></style>
