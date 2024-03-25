<template>
  <div class="wrapper">
    <!-- inspectors datatable -->
    <inspectors-datatable-dialogs ref="dialogs" />
      
    <v-data-table
      class="elevation-1"
      loading-text="Cargando información"
      :headers="headers"
      :items="inspectors"
      :page-count="inspectorsTotalPages"
      :server-items-length="inspectorsTotalItems"
      :options.sync="options"
      :loading="loadingTable"
    >
      <template v-slot:item.activo="{ item }">
        <!-- {{ item.bactivo}} -->
        <v-icon v-show="item.activo" size="medium" color="green"> mdi-check </v-icon>
        <v-icon v-show="!item.activo" size="medium" color="red">mdi-close</v-icon>
      </template>

      <template v-slot:item.acciones="{ item }">
        <v-tooltip v-if="permissions.includes('veii')" bottom>
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

        <v-tooltip v-if="permissions.includes('edii')" bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              v-bind="attrs" 
              v-on="on" 
              icon 
              small
              @click="actionsHandler(item, 'edii')"
            >
              <v-icon small> mdi-square-edit-outline </v-icon>
            </v-btn>
          </template>
          <span>Editar perfil</span>
        </v-tooltip>

        <v-tooltip v-if="permissions.includes('boii')" bottom>
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
  </div>
</template>

<script>
import InspectorsDatatableDialogs from "@/pages/inspections/inspectors/components/InspectorsDatatableDialogs";
import services from "@/services";
import { mapActions, mapState } from "vuex";

export default {
  name: "InspectorsDatatable",
  components: {
    InspectorsDatatableDialogs,
  },
  data() {
    return {
      permissions: [],
      options: {
        inspectors: [],
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
          value: "txtnombre",
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
    ...mapState('app', ['inspectors', 'inspectorsTotalPages', 'inspectorsTotalItems']),
  },
  methods: {
    ...mapActions('app', ['getInspectors']),
    async loadInspectorsTable() {
      console.log('yaaa');
      console.log(this.inspectors);
      const { page, itemsPerPage, sortBy, sortDesc } = this.options;
      const data = { page, itemsPerPage, sortBy, sortDesc }; 
      // console.log('es este')
      // console.log(data)
      this.getInspectors({ data });
      this.loadingTable = false;
    },
    actionsHandler(inspector, action) {
      this.$refs.dialogs.inspector = inspector;

      switch (action) {
        case 'edit': this.$router.push(`/inspectors/${inspector.id}/edit`); break;
        case 'view': this.$refs.dialogs.viewInspector(); break;
        default: this.$refs.dialogs.show[action] = true;
      }
    },
  },
  watch: {
    options: {
      handler() {
        this.loadInspectorsTable();
      },
      deep: true,
    },
  },
  async mounted() {
    const { iin } = await services.security().getPermissions();
    if (iin) this.permissions = iin;
  }
};
</script>
