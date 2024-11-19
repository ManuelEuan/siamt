<template>
  <v-container fluid>
    <v-overlay
      :value="loading"
      :z-index="100005"
      :opacity="0.55"
    >
      <v-progress-circular
        class="me-2"
        :size="45"
        indeterminate
      ></v-progress-circular> Cargando, por favor, espera ...
    </v-overlay>
    <v-row align="center">
      <v-col cols="12" class="pa-0">
        <dashboard-header
          :collections = "collections"
          :documentwithfilters = "documentWithFilters"
          @changedocument = "changeDocument"
          @applyfilters = "applyFilters"
          />
      </v-col>
    </v-row>
    <v-row
      align = "center"
      v-if = "seeDocument"
    >
      <v-col
        cols="12"
        class="pa-0 pt-2"
      >
        <v-card
          flat
        >
          <v-toolbar
            class="text-center"
          >
            <v-toolbar-title class="mx-auto">
              {{document.nombre}}
            </v-toolbar-title>
          </v-toolbar>
          <!-- <v-card-title>{{document.nombre}}</v-card-title> -->
          <!-- <v-card-subtitle>Documento</v-card-subtitle> -->
          <!-- <v-divider></v-divider> -->

          <v-card-text>
            <!-- <v-container fluid> -->
              <v-row dense>
                <template
                  v-for = "item in data"
                >
                  <v-col
                    v-if="hasPermissionOrAllow(item.permiso)"
                    :cols = "item.cols?item.cols:12"
                    :md = "item.colsmd?item.colsmd:12"
                    :key ="item.id"
                  >
                    <r-data-table
                      v-if = "item.type === 'tabla'"
                      :payload="item"
                      :key="item.id"
                      :parent-filter="finalData.filters"
                    ></r-data-table>
                    <dashboard-graph
                      v-else-if = "item.type === 'grafica'"
                      :info = "item"
                      :key = "item.name"
                    ></dashboard-graph>
                    <r-data-counter
                      v-else-if = "item.type === 'contador'"
                      :payload = "item"
                      :key = "item.id"
                    ></r-data-counter>
                    <v-alert
                      v-else
                      dense
                      border = "left"
                      type = "warning"
                    >
                      Tipo de componente no válido
                    </v-alert>
                  </v-col>
                </template>
              </v-row>
            <!-- </v-container> -->
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import services from '@/services';
import DashboardHeader from './components/DashboardHeader.vue';
import DashboardGraph from './components/DashboardGraph.vue';
import RDataTable from './components/RDataTable.vue';
import RDataCounter from './components/RDataCounter.vue';

export default {
  components: {
    DashboardHeader,
    DashboardGraph,
    RDataTable,
    RDataCounter,
  },
  data() {
    return {
      loading: false,
      collections : {
        documents : [],
      },
      documentWithFilters : false,
      document : {},
      seeDocument : false,
      data : [],
      conFiltros : false,
      finalData : {
        filters : {
          newFilters: false,
          initDate : '',
          endDate : '',
          localDistrictId: null,
          federalDistrictId: null,
        },
        document : {}
      }
    }
  },
  async mounted() {
    await this.getIndexData()
  },
  beforeDestroy() {

  },
  methods: {
    async getIndexData() {
      let documents = await services.census().getDashboardIndex();
      documents.forEach(element => {
        if(this.hasPermission(element.permiso) || !element.permiso) {
          this.collections.documents.push(element);
        }
      });
    },
    hasPermission(permission) {
      return services.security().hasPermission(this.$route.meta.code, permission);
    },
    hasPermissionOrAllow(permission) {
      if (!permission) return true;

      return this.hasPermission(permission);
    },
    async changeDocument(document) {
      try {
        this.document = document;
        if(this.document == null) {
          this.seeDocument = false;
          this.documentWithFilters = false;
          return;
        }

        this.loading = true;

        this.seeDocument = false;
        this.finalData.document = this.document;
  
        // BUG, inconsistencia, puede ser que documento anterior agregó filtros.
        this.finalData.filters = {
          newFilters: false,
          initDate: '',
          endDate: '',
          localDistrictId: null,
          federalDistrictId: null,
        };
  
        
        this.data = await services.census().getDocumentInfo(this.finalData);
        this.seeDocument = true;
        if(this.document.confecha) {
          this.documentWithFilters = true;
        }
      } catch (error) {
        // 
      } finally {
        this.loading = false;
      }

    },
    async applyFilters(filters) {
      try {
        this.seeDocument = false;
        // this.finalData.filters.initDate = filters.initDate;
        // this.finalData.filters.endDate = filters.endDate;
        this.finalData.filters = { ...filters };
        this.finalData.document = this.document
        
        this.data = await services.census().getDocumentInfo(this.finalData);
  
        this.seeDocument = true;
        if(this.document.confecha) {
          this.conFiltros = true;
        }
      } catch (error) {
        // 
      }
    }
  }
}
</script>
