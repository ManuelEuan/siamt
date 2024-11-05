<template>
  <div class="d-flex flex-column flex-grow-1">
    <v-alert
      v-if="hasError && !applyingFilter"
      prominent
      outlined
      dense
      type="warning"
    >
      <v-row align="center">
        <v-col class="grow">
          <div class="text-h6">
            {{payload.name}}
          </div>
          Algo salio mal, no pudimos cargar la información. Intenta nuevamente.
        </v-col>
        <v-col class="shrink">
          <v-tooltip
            left
          >
            <template v-slot:activator="{ on, attrs }">
              <v-btn
                v-bind="attrs"
                v-on="on"
                fab
                small
                @click.stop="search()"
              >
                <v-icon
                >mdi-sync</v-icon>
              </v-btn>
            </template>
            <span>Sincronizar datos</span>
          </v-tooltip>
        </v-col>
      </v-row>
    </v-alert>

    <v-card v-else-if="!hasError">
      <v-card-title>
        <span class="text--secondary font-weight-medium">{{payload.name}}</span>
        <v-spacer></v-spacer>
        <v-btn
          v-if="hasPermissionOrDeny(payload.permiso_descargar)"
          color="green"
          :loading="isExporting"
          :disabled="applyingFilter || isExporting"
          outlined
          @click.prevent="exportComponent()"
        >
          <v-icon left>mdi-microsoft-excel</v-icon>
          Exportar Registros
        </v-btn>
      </v-card-title>
      <v-divider></v-divider>
      <v-card-title class="d-flex align-center flex-wrap flex-md-nowrap pa-auto">
        <v-text-field
          v-model.trim="filter.search"
          solo
          clearable
          hide-details
          :placeholder="config.queryPlaceholder || queryPlaceholder"
          label="Buscar"
          prepend-inner-icon="mdi-magnify"
          :disabled="applyingFilter"
          @keyup.enter="search()"
          class="me-2"
        ></v-text-field>
        <v-tooltip bottom class="">
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              :loading="applyingFilter"
              fab
              small
              color="primary"
              :disabled="applyingFilter"
              @click="search()"
            >
              <v-icon v-bind="attrs" v-on="on">mdi-magnify</v-icon>
            </v-btn>
          </template>
          <span>Buscar</span>
        </v-tooltip>
      </v-card-title>

      <v-skeleton-loader
        v-if="isFirstLoad && applyingFilter"
        :loading="applyingFilter"
        type="table"
      />
      <v-card-text
        v-show="!isFirstLoad"
      >
        <v-data-table
          :headers="config.headers"
          :items="items"
          :options.sync="options"
          :items-per-page="itemsPerPage"
          :footer-props="footerProps"
          :server-items-length="totalItems"
          :loading="applyingFilter"
          :disabled="applyingFilter"
          loading-text="Buscando... Por favor espere."
          no-data-text="Sin datos"
          no-results-text="No se encontraron resultados"
          item-key="id"
        >
        </v-data-table>
      </v-card-text>

    </v-card>
  </div>
</template>

<script>
import services from '@/services';

export default {
  props: {
    payload: {
      type: Object,
      default: () => ({}),
      required: false
    },
    parentFilter: {
      type: Object,
      default: () => ({}),
      required: false
    },
    queryPlaceholder: {
      type: String,
      default: 'Empieza a escribir para buscar',
      required: false
    },
  },
  data() {
    return {
      globalFilter: {},
      filter: { search: '' },
      isFirstLoad: true,
      hasError: false,
      applyingFilter: false,
      data: {},
      items: [],
      options: {},
      itemsPerPage: 10,
      totalItems: null,
      footerProps: {
        'items-per-page-options': [10, 15, 20],
        'items-per-page-text': 'Registros por página'
      },
      config: {},
      isExporting: false,
    }
  },
  watch: {
    options: {
      handler() {
        this.search();
      },
      deep: true
    }
  },
  methods: {
    hasPermission(permission) {
      return services.security().hasPermission(this.$route.meta.code, permission);
    },
    hasPermissionOrDeny(permission) {
      if (!permission) return false;

      return this.hasPermission(permission);
    },
    async exportComponent() {
      try {
        this.isExporting = true;

        const filter = this.filter;
        const globalFilter = this.parentFilter;
        const data = { ...globalFilter, ...filter };
        const { componentId } = this.payload;

        const blob = await services.census().exportComponent(componentId, data);

        const fileName = `dashboard-table-${Date.now()}.xlsx`;

        const link = document.createElement('a');
        link.href = window.URL.createObjectURL(blob);
        link.download = fileName;
        link.click();

        this.$swal.fire({
          icon: 'success',
          text: 'Registros exportados exitosamente.'
        });
      } catch (error) {
        this.$swal.fire({
          icon: 'error',
          text: 'Algo salio mal, no pudimos completar esta acción. Intenta nuevamente.'
        });
        console.log(error.code, error.message);
      } finally {
        this.isExporting = false;
      }
    },
    async search() {
      try {
        this.applyingFilter = true;

        const filter = this.filter;
        const globalFilter = this.parentFilter;
        const { page, itemsPerPage } = this.options;
        const data = { ...globalFilter, ...filter, page, itemsPerPage };
        const { componentId } = this.payload;
        const {  items = [], pagination } = await services.census().searchComponentData(componentId, data);


        this.items = items;
        this.totalItems = pagination.totalItems;
        this.isFirstLoad = false;
        this.hasError = false;
      } catch (error) {
        console.log(error);
        this.$rswal.toastError('Lo sentimos, tenemos problemas al intentar cargar la información.');
        this.hasError = true;
      } finally {
        this.applyingFilter = false;
      }
    },
  },
  mounted() {
    this.applyingFilter = true;
    this.data = JSON.parse(this.payload.data.t);
    this.items = this.data.items;
    this.pagination = this.data.pagination;
    this.config = JSON.parse(this.payload.config);
    this.applyingFilter = false
  },
  async created() { }
}
</script>

<style lang="scss">

.v-data-table__wrapper table > tbody > tr:nth-child(even) {
  background-color: #F5F5F5;
}

.border-bottom {
  border-bottom: 1px solid #E0E0E0 !important;
}
</style>