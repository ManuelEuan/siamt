<template>
  <div class="wrapper">
    <!-- inspectors datatable -->
    <companies-datatable-dialogs ref="dialogs" />
    <!-- <h1>{{ companies }}</h1> -->

    <v-data-table
      class="elevation-1"
      loading-text="Cargando información"
      :headers="headers"
      :items="companies"
      :options.sync="options"
      :loading="loadingTable"
    >
      <template v-slot:item.activo="{ item }">
        <v-icon v-show="item.activo" size="medium" color="green">mdi-check</v-icon>
        <v-icon v-show="!item.activo" size="medium" color="red">mdi-close</v-icon>
      </template>

      <template v-slot:item.acciones="{ item }">
        <v-tooltip v-if="permissions.includes('veie')" bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              v-bind="attrs"
              v-on="on"
              icon
              small
              @click="actionsHandler(item, 'view')"
            >
              <v-icon small>mdi-eye</v-icon>
            </v-btn>
          </template>
          <span>Ver empresa</span>
        </v-tooltip>

        <v-tooltip v-if="permissions.includes('edie')" bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              v-bind="attrs"
              v-on="on"
              icon
              small
              @click="actionsHandler(item, 'edit')"
            >
              <v-icon small>mdi-square-edit-outline</v-icon>
            </v-btn>
          </template>
          <span>Editar Empresa</span>
        </v-tooltip>
      </template>
    </v-data-table>
  </div>
</template>

<script>
import CompaniesDatatableDialogs from "@/pages/admin/companies/components/CompaniesDatatableDialogs";
import services from "@/services";
import { mapActions, mapState } from "vuex";

export default {
  name: "CompaniesDatatable",
  components: {
    CompaniesDatatableDialogs,
  },
  data() {
    return {
      permissions: [],
      options: {
        page: 1,
        itemsPerPage: 10,
        sortBy: ['txtnombre_completo'],
        sortDesc: [false],
        multiSort: true,
        mustSort: false,
      },
      loadingTable: true,
      headers: [
        {
          text: "Nombre",
          value: "txtnombre_completo",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Nomenclatura",
          value: "vnomenclatura",
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
    ...mapState('app', ['companies']),
  },
  methods: {
    ...mapActions('app', ['getCompanies']),
    async loadCompaniesTable() {
      this.loadingTable = true;
      try {
        const { page, itemsPerPage, sortBy, sortDesc } = this.options;
        const data = { page, itemsPerPage, sortBy, sortDesc };
        console.log("Fetching companies with data:", data);  // Depuración
        await this.getCompanies({ data });
        console.log("Fetched companies:", this.companies);  // Depuración
      } catch (error) {
        console.error("Error al cargar los datos:", error);
      } finally {
        this.loadingTable = false;
      }
    },
    actionsHandler(company, action) {
      console.log('actionsHandler:', company, action);
      this.$refs.dialogs.company = company;

      switch (action) {
        case 'edit':
          this.$router.push(`/transports/companies/${company.iidempresa}/edit`);
          break;
        case 'view':
          this.$refs.dialogs.viewCompany();
          break;
        default:
          this.$refs.dialogs.show[action] = true;
      }
    },
  },
  watch: {
    options: {
      handler() {
        this.loadCompaniesTable();
      },
      deep: true,
    },
  },
  async mounted() {
    const { iie } = await services.security().getPermissions();
    if (iie) this.permissions = iie;
    this.loadCompaniesTable();  // Cargar datos al montar el componente
  }
};
</script>
