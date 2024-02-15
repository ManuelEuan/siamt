<template>
  <div class="wrapper">
    <profiles-datatable-dialogs ref="dialogs" />

    <v-data-table
      class="elevation-1"
      loading-text="Cargando información"
      :headers="headers"
      :items="profiles"
      :page-count="profilesTotalPages"
      :server-items-length="profilesTotalItems"
      :options.sync="options"
      :loading="loadingTable"
    >
      <template v-slot:item.activo="{ item }">
        <v-icon v-show="item.activo" size="medium" color="green"> mdi-check </v-icon>
        <v-icon v-show="!item.activo" size="medium" color="red">mdi-close</v-icon>
      </template>

      <template v-slot:item.acciones="{ item }">
        <v-tooltip v-if="permissions.includes('vepe')" bottom>
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
          <span>Ver perfil</span>
        </v-tooltip>

        <v-tooltip v-if="permissions.includes('edpe')" bottom>
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
          <span>Editar perfil</span>
        </v-tooltip>

        <v-tooltip v-if="permissions.includes('bope')" bottom>
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
          <span>{{ item.activo ? "Desactivar" : "Activar" }} verfil</span>
        </v-tooltip>

      </template>
    </v-data-table>
  </div>
</template>

<script>
import ProfilesDatatableDialogs from "@/pages/admin/profiles/components/ProfilesDatatableDialogs";
import services from "@/services";
import { mapActions, mapState } from "vuex";

export default {
  name: "ProfilesDatatable",
  components: {
    ProfilesDatatableDialogs,
  },
  data() {
    return {
      permissions: [],
      options: {
        profiles: [],
        page: 1,
        itemsPerPage: 10,
        sortBy: ['nombre'],//nombre
        sortDesc: [false],
        multiSort: true,
        mustSort: false,
      },
      loadingTable: true,
      headers: [
        {
          text: "Nombre",
          value: "nombre",
          align: "center",
          class: "font-weight-bold",
        },
       
        {
          text: "Descripción",
          value: "descripcion",
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
    ...mapState('app', ['profiles', 'profilesTotalPages', 'profilesTotalItems']),
  },
  methods: {
    ...mapActions('app', ['getProfiles']),
    async loadProfilesTable() {
      const { page, itemsPerPage, sortBy, sortDesc } = this.options;
      const data = { page, itemsPerPage, sortBy, sortDesc }; 
      this.getProfiles({ data });
      this.loadingTable = false;
    },
    actionsHandler(profile, action) {
      this.$refs.dialogs.profile = profile;

      switch (action) {
        case 'edit': this.$router.push(`/profiles/${profile.id}/edit`); break;
        case 'view': this.$refs.dialogs.viewProfile(); break;
        default: this.$refs.dialogs.show[action] = true;
      }
    },
  },
  watch: {
    options: {
      handler() {
        this.loadProfilesTable();
      },
      deep: true,
    },
  },
  async mounted() {
    const { per } = await services.security().getPermissions();
    if (per) this.permissions = per;
  }
};
</script>
