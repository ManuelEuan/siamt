<template>
  <div class="wrapper">
    
    <actividades-datatable-dialogs ref="dialogs" />
    <v-data-table
      class="elevation-1"
      loading-text="Cargando información"
      :headers="headers"
      :items="actividades"
      :page-count="actividadesTotalPages"
      :server-items-length="actividadesTotalItems"
      :options.sync="options"
      :loading="loadingTable"
    >
      <template v-slot:item.activo="{ item }">
        <v-icon v-show="item.activo" size="medium" color="green"> mdi-check </v-icon>
        <v-icon v-show="!item.activo" size="medium" color="red">mdi-close</v-icon>
      </template>

      <template v-slot:item.acciones="{ item }">
        <v-tooltip bottom>
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
          <span>Ver Actividad</span>
        </v-tooltip>

        <v-tooltip bottom>
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
          <span>Editar Actividad</span>
        </v-tooltip>

        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              v-bind="attrs" 
              v-on="on" 
              icon 
              small
              @click="actionsHandler(item, 'delete')"
            >
              <v-icon small v-show="item.bactivo"> mdi-delete </v-icon>
            </v-btn>
          </template>
          <span>Eliminar actividad</span>
        </v-tooltip>
        

      </template>
    </v-data-table>
  </div>
</template>

<script>
import ActividadesDatatableDialogs from "@/pages/admin/mantoUnidades/actividades/components/ActividadesDatatableDialogs";
import { mapActions, mapState } from "vuex";

export default {
  name: "ActividadesDatatable",
  components: {
    ActividadesDatatableDialogs,
  },
  data() {
    return {
      options: {
        actividades: [],
        page: 1,
        itemsPerPage: 10,
        sortBy: ['vclave'],//nombre
        sortDesc: [false],
        multiSort: true,
        mustSort: false,
      },
      loadingTable: true,
      headers: [
        {
          text: "Clave",
          value: "vclave",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Tolerancia Kms",
          value: "itolerancia_kms",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Tolerancia Meses",
          value: "itolerancia_meses",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Complejidad",
          value: "complejidad",
          align: "center",
          class: "font-weight-bold",
          sortable: false,
        },
        {
          text: "Costo",
          value: "fcosto_total",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Descripcion",
          value: "txtdescripcion",
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
    ...mapState('app', ['actividades', 'actividadesTotalPages', 'actividadesTotalItems']),
  },
  methods: {
    ...mapActions('app', ['getActividades']),
    async loadActividadesTable() {
      const { page, itemsPerPage, sortBy, sortDesc } = this.options;
      const data = { page, itemsPerPage, sortBy, sortDesc }; 
      this.getActividades({ data });
      this.loadingTable = false;
    },
    actionsHandler(actividad, action) {
      this.$refs.dialogs.actividad = actividad;

      switch (action) {
        case 'edit': this.$router.push(`/mantenimiento/actividades/${actividad.iid}/edit`); break;
        case 'view': this.$refs.dialogs.viewActividad(); break;
        default: this.$refs.dialogs.show[action] = true;
      }
    },
  },
  watch: {
    options: {
      handler() {
        this.loadActividadesTable();
      },
      deep: true,
    },
  },
};
</script>
