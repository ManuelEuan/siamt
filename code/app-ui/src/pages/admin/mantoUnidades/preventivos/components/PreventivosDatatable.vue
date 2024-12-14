<template>
  <div class="wrapper">
    
    <preventivos-datatable-dialogs ref="dialogs" />
    <v-data-table
      class="elevation-1"
      loading-text="Cargando información"
      :headers="headers"
      :items="preventivos"
      :page-count="preventivosTotalPages"
      :server-items-length="preventivosTotalItems"
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
          <span>Historial</span>
        </v-tooltip>

        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              v-bind="attrs" 
              v-on="on" 
              icon 
              small
              @click="actionsHandler(item, 'add')"
            >
              <v-icon small> mdi-plus-box-outline </v-icon>
            </v-btn>
          </template>
          <span>Ingresar Vehiculo</span>
        </v-tooltip>
      </template>
    </v-data-table>
  </div>
</template>

<script>
import PreventivosDatatableDialogs from "@/pages/admin/mantoUnidades/preventivos/components/PreventivosDatatableDialogs";
import { mapActions, mapState } from "vuex";

export default {
  name: "PreventivosDatatable",
  components: {
    PreventivosDatatableDialogs,
  },
  data() {
    return {
      options: {
        preventivos: [],
        page: 1,
        itemsPerPage: 10,
        sortBy: ['iid'],//nombre
        sortDesc: [false],
        multiSort: true,
        mustSort: false,
      },
      loadingTable: true,
      headers: [
        {
          text: "ID",
          value: "id",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Marca",
          value: "marca",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Modelo",
          value: "modelo",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Num Comercial",
          value: "serie",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Placa",
          value: "placa",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Año",
          value: "año",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Km Actual",
          value: "km_actual",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Último Mantenimiento",
          value: "ultimo",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Sig Mantenimiento",
          value: "siguiente",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Sig Plan",
          value: "sig_plan",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Acciones",
          value: "acciones",
          align: "center",
          class: "font-weight-bold",
          sortable: false,
          width: "196px",
        },
      ],
    };
  },
  computed: {
    ...mapState('app', ['preventivos', 'preventivosTotalPages', 'preventivosTotalItems']),
  },
  methods: {
    ...mapActions('app', ['getPreventivos']),
    async loadpreventivosTable() {
      const { page, itemsPerPage, sortBy, sortDesc } = this.options;
      const data = { page, itemsPerPage, sortBy, sortDesc }; 
      this.getPreventivos({ data });
      this.loadingTable = false;
    },
    actionsHandler(preventivo, action) {
      this.$refs.dialogs.preventivo = preventivo;

      switch (action) {
        case 'add': this.$router.push(`/mantenimiento/preventivos/${preventivo.id}/new`); break;
        case 'view': this.$refs.dialogs.viewPreventivo('view'); break;
        default: this.$refs.dialogs.show[action] = true;
      }
    },
  },
  watch: {
    options: {
      handler() {
        this.loadpreventivosTable();
      },
      deep: true,
    },
  },
};
</script>
