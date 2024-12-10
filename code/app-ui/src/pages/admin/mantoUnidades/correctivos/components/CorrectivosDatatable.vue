<template>
  <div class="wrapper">
    
    <correctivos-datatable-dialogs ref="dialogs" />
    <v-data-table
      class="elevation-1"
      loading-text="Cargando información"
      :headers="headers"
      :items="correctivos"
      :page-count="correctivosTotalPages"
      :server-items-length="correctivosTotalItems"
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
          <span>Ver Correctivo</span>
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
          <span>Editar Correctivo</span>
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
          <span>Eliminar Correctivo</span>
        </v-tooltip>

      </template>
    </v-data-table>
  </div>
</template>

<script>
import CorrectivosDatatableDialogs from "@/pages/admin/mantoUnidades/correctivos/components/CorrectivosDatatableDialogs";
import { mapActions, mapState } from "vuex";

export default {
  name: "CorrectivosDatatable",
  components: {
    CorrectivosDatatableDialogs,
  },
  data() {
    return {
      options: {
        correctivos: [],
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
          value: "iid",
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
          text: "Serie",
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
          text: "Fecha Ingreso",
          value: "dtfecha_ingreso",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Fecha Egreso",
          value: "dtfecha_salida",
          align: "center",
          class: "font-weight-bold",
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
          class: "font-weight-bold",
          sortable: false,
          width: "196px",
        },
      ],
    };
  },
  computed: {
    ...mapState('app', ['correctivos', 'correctivosTotalPages', 'correctivosTotalItems']),
  },
  methods: {
    ...mapActions('app', ['getCorrectivos']),
    async loadCorrectivosTable() {
      const { page, itemsPerPage, sortBy, sortDesc } = this.options;
      const data = { page, itemsPerPage, sortBy, sortDesc }; 
      this.getCorrectivos({ data });
      this.loadingTable = false;
    },
    actionsHandler(correctivo, action) {
      this.$refs.dialogs.correctivo = correctivo;

      switch (action) {
        case 'edit': this.$router.push(`/mantenimiento/correctivos/${correctivo.iid}/edit`); break;
        case 'view': this.$refs.dialogs.viewCorrectivo('view'); break;
        case 'delete': this.$refs.dialogs.viewCorrectivo('delete'); break;
        default: this.$refs.dialogs.show[action] = true;
      }
    },
  },
  watch: {
    options: {
      handler() {
        this.loadCorrectivosTable();
      },
      deep: true,
    },
  },
};
</script>
