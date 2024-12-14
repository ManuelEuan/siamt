<template>
  <div class="wrapper">
    <v-dialog transition="dialog-top-transition" max-width="900" v-model="show.view">
      <v-card>
        <v-card-title class="text-uppercase primary--text text-h6 py-2"> Historial de mantenimientos </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="py-0 my-0">
          <v-list class="pa-0 ma-0">
            <v-container class="pa-0 ma-0">
              <v-row dense>
                <template v-if="this.show.view" >
                  <v-col cols="12" class="pa-0 mt-2">
                    <div class="wrapper">
                      <v-data-table class="elevation-1" loading-text="Cargando información"
                          :headers="headers"
                          :items="datos"
                          :page-count="historialTotalPages"
                          :server-items-length="historialTotalItems"
                          :options.sync="optionsHistorial"
                          :loading="loadingTable">
                      </v-data-table>
                    </div>
                </v-col>
                </template>
              </v-row>
            </v-container>
          </v-list>
        </v-card-text>
        <v-divider></v-divider>

        <v-card-actions class="py-2">
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="show.view = false"> Cerrar </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import services from "@/services";
import { mapActions } from "vuex";

export default {
  name: "PreventivosDatatableDialogs",
  data() {
    return {
      unidades: [],
      show: {
        view: false,
        delete: false,
        change: false,
      },

      datos:[],
      headers: [
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
            sortable: false,
        },
        {
            text: "Odometro",
            value: "iciclo",
            align: "center",
            class: "font-weight-bold",
            sortable: false,
        },
        {
            text: "Costo",
            value: "fcosto_total",
            align: "center",
            class: "font-weight-bold",
            sortable: false,
        },
        {
            text: "Estatus",
            value: "estatus",
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
      loadingTable: true,
      historialTotalPages: 1,
      historialTotalItems: 1,
      optionsHistorial: {
        planes: [],
        page: 1,
        itemsPerPage: 10,
        sortBy: ['vnombre'],
        sortDesc: [false],
        multiSort: true,
        mustSort: false,
      },
    };
  },
  methods: {
    ...mapActions('app', ['showError', 'showSuccess']),
    async viewPreventivo(accion = 'view') {
      try {
        if(accion == 'view') {
          let historial = await services.mantounidades().getMantenimientos({tipo:'preventivo', unidadId:3});
          this.datos    = historial.items;
          this.show.delete = false;
          this.show.view = true;
          this.loadingTable = false;
        }
      }
      catch (error) {
        const message = 'Error al cargar la información.';
        this.showError({ message, error });
      }
    },
  },
  async mounted() {
    this.unidades   = await services.mantounidades().getUnidades();
  },
};
</script>