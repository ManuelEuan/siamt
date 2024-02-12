<template>
<v-card flat>
  <v-toolbar>
    <v-toolbar-title>Usuarios</v-toolbar-title>
    <v-spacer></v-spacer>
    <v-tooltip v-if="permissions.includes('crus')" top>
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
      :content="activeFilters"
      :value="activeFilters"
    >
      <v-dialog
        v-model="dialog"
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
          <v-card-title class="text-uppercase primary--text text-h6 py-2">Filtros</v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-row dense>
              <v-col
                cols="6"
                md="6"
              >
                <v-select
                  v-model="filters.active"
                  label="Activo"
                  :items="items.active"
                  item-text="text"
                  item-value="value"
                  hide-details
                  clearable
                  outlined
                  dense
                >
                  <template v-slot:prepend-inner>
                    <div class="d-flex align-center" style="height: 25px;">
                      <v-icon 
                        v-if="filters.active==='t'" 
                        size="medium" 
                        color="green"
                      > 
                        mdi-check 
                      </v-icon>
                      <v-icon 
                        v-else-if="filters.active==='f'" 
                        size="medium" 
                        color="red"
                      >
                        mdi-close
                      </v-icon>
                      <v-icon 
                        v-else 
                        size="medium"
                      >
                        mdi-minus
                      </v-icon>
                      <v-divider 
                        class="mx-1" 
                        vertical
                      ></v-divider>
                    </div>
                  </template>
                </v-select>
              </v-col>
              <v-col
                cols="6"
                md="6"
              >
                <v-select
                  v-model="filters.roles"
                  label="Perfiles"
                  :items="items.roles"
                  item-text="nombre"
                  item-value="id"
                  clearable
                  dense
                  hide-details
                  multiple
                  outlined
                  small-chips
                ></v-select>
              </v-col>
              <v-col
                cols="12"
                md="6"
              >
                <v-text-field
                  v-model="filters.username"
                  label="Usuario"
                  hide-details="auto"
                  clearable
                  dense
                  outlined
                ></v-text-field>
              </v-col>
              <v-col
                cols="12"
                md="6"
              >
                <v-text-field
                  v-model="filters.name"
                  label="Nombre"
                  hide-details="auto"
                  clearable
                  dense
                  outlined
                ></v-text-field>
              </v-col>
            </v-row>
          </v-card-text>
          <v-divider></v-divider>
          <v-card-actions class="justify-end py-2">
            <v-spacer></v-spacer>
            <v-btn
              color="warning"
              text
              @click="cleanFilters"
            >
              Limpiar
            </v-btn>
            <v-btn
              color="error"
              text
              @click="closeFilters"
            >
              Cerrar
            </v-btn>
            <v-btn
              color="primary"
              text
              @click="applyFilters"
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
import services from '@/services';
import { mapActions, mapState } from 'vuex';

export default {
  name: "UsersFilters",
  data() {
    return {
      dialog: false,
      permissions: [],
      filters: {
        active: '',
        name: '',
        username: '',
        roles: [],
      },
      items: {
        active: [
          { text: 'activo', value: 't' },
          { text: 'inactivo', value: 'f'},
        ],
        roles: [],
      },
    };
  },
  computed: {
    ...mapState('app', ['usersFilters']),
    activeFilters() {
      return Object
        .values(this.usersFilters)
        .filter(v => v && (typeof(v) === 'string' ? v.trim() : v.length))
        .length;
    }
  },
  methods: {
    ...mapActions('app', ['getUsers', 'showError']),
    cleanFilters() {
      this.filters = { active: '', name: '', username: '', roles: [] };
    },
    async applyFilters() {
      const filters = this.filters;
      await this.getUsers({ filters });
      this.dialog = false;
    },
    closeFilters() {
      this.filters = { ...this.usersFilters };
      this.dialog = false;
    },
    newUser() {
      this.$router.push("/users/new");
    },
  },
  async mounted() {
    try {
      const response = await services.admin().getRoles();
      this.items.roles = response.map(({ id, nombre}) => ({ id, nombre }));
    } catch (error) {
      const message = 'Error al cargar opciones de filtrado.';
      this.showError({ message, error });
    }

    const { usr } = await services.security().getPermissions();
    if (usr) this.permissions = usr;
  },
};
</script>
