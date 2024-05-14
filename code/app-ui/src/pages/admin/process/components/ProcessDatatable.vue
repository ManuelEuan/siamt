<template>
  <div class="wrapper">
    <!-- <profiles-datatable-dialogs ref="dialogs" /> -->

    <v-data-table
      class="elevation-1"
      loading-text="Cargando información"
      :headers="headers"
      :items="dinamycRegisterInProcess"
      :page-count="dinamycRegisterInProcessTotalPages"
      :server-items-length="dinamycRegisterInProcessTotalItems"
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
              <v-icon small> mdi-square-edit-outline </v-icon>
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
              <v-icon small v-show="item.activo"> mdi-close </v-icon>
              <v-icon small v-show="!item.activo"> mdi-check </v-icon>
            </v-btn>
          </template>
          <span>{{ item.activo ? "Desactivar" : "Activar" }} verfil</span>
        </v-tooltip>

      </template>
    </v-data-table>
    {{ dinamycRegisterInProcess }}--
  </div>
</template>

<script>
// import DinamycRegisterInProcessDatatableDialogs from "@/pages/admin/profiles/components/DinamycRegisterInProcessDatatableDialogs";
// import services from "@/services";
import { mapActions, mapState } from "vuex";

export default {
  name: "ProcessDatatable",
  components: {
    // DinamycRegisterInProcessDatatableDialogs,
  },
  data() {
    return {
      permissions: [],
      options: {
        dinamycRegisterInProcess: [],
        page: 1,
        itemsPerPage: 10,
        sortBy: ['txtnombre'],//nombre
        sortDesc: [false],
        multiSort: true,
        mustSort: false,
      },
      loadingTable: true,
      headers: [
        {
          text: "Nombre",
          value: "txtnombre",
          align: "center",
          class: "font-weight-bold",
        },
       
        {
          text: "Descripción",
          value: "txtdescripcion",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Activo",
          value: "bactivo",
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
    ...mapState('app', ['dinamycRegisterInProcess', 'dinamycRegisterInProcessTotalPages', 'dinamycRegisterInProcessTotalItems']),
  },
  methods: {
    ...mapActions('app', ['getDinamycRegisterInProcess']),
    async loadDinamycRegisterInProcessTable() {

      const { page, itemsPerPage, sortBy, sortDesc } = this.options;
      const data = { page, itemsPerPage, sortBy, sortDesc }; 
      this.getDinamycRegisterInProcess({ data });
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
      async handler() {
        let hola = await this.loadDinamycRegisterInProcessTable();
        console.log('--------------------------hola')
        console.log(hola)
      },
      deep: true,
    },
  },
  async mounted() {
    // const { per } = await services.security().getPermissions();
    // if (per) this.permissions = per;
  }
};
</script>
