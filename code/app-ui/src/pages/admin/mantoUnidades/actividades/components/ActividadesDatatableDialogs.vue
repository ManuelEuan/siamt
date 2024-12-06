<template>
  <div class="wrapper">
    <v-dialog transition="dialog-top-transition" max-width="900" v-model="show.view">
      <v-card>
        <v-card-title class="text-uppercase primary--text text-h6 py-2"> ver informacion </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="py-0 my-0">
          <v-list class="pa-0 ma-0">
            <v-container class="pa-0 ma-0">
              <v-row dense>
                <template v-for="(value, key, index) in datos">
                  <v-col class="pa-0 ma-0" cols="4" :key="index">
                    <v-list-item>
                      <v-list-item-content class="py-2">
                        <v-list-item-title class="text-capitalize text-h7">
                          {{ value.titulo }}
                        </v-list-item-title>

                        <v-list-item-subtitle class="text-body-1 py-1">
                          {{ value.valor }}
                        </v-list-item-subtitle>
                      </v-list-item-content>
                    </v-list-item>
                  </v-col>
                </template>
              </v-row>

              <v-row dense>
                <template v-if="this.show.view" >
                  <v-col class="pa-0 ma-0" cols="12" >
                    <v-list-item>
                      <v-list-item-content class="py-2">
                        <v-list-item-title class="text-capitalize text-h7">
                         Descripcion
                        </v-list-item-title>

                        <v-list-item-subtitle class="text-lowercase text-body-1 py-1">
                          <v-textarea v-model="this.actividad.txtdescripcion" rows="3" disabled hide-details="auto" clearable dense outlined />
                        </v-list-item-subtitle>
                      </v-list-item-content>
                    </v-list-item>
                  </v-col>

                  <v-col class="pa-0 ma-0" cols="12" >
                    <v-list-item>
                      <v-list-item-content class="py-2">
                        <v-list-item-title class="text-capitalize text-h7">
                         Notas tecnicas
                        </v-list-item-title>

                        <v-list-item-subtitle class="text-lowercase text-body-1 py-1">
                          <v-textarea v-model="this.actividad.txtnotas_tecnicas" rows="3" disabled hide-details="auto" clearable dense outlined />
                        </v-list-item-subtitle>
                      </v-list-item-content>
                    </v-list-item>
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

    <v-dialog transition="dialog-top-transition" max-width="600" v-model="show.delete">
      <v-card v-if="this.show.delete">
        <v-card-title class="text-uppercase primary--text text-h6 py-2">
          {{ actividad.bactivo ? "desactivar" : "activar" }} actividad
        </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="text-body-1 py-2">
          ¿Est&aacute;s seguro de que deseas eliminar esta actividad?
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions class="py-2">
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="show.delete = false"> Cerrar </v-btn>
          <v-btn color="primary" text @click="deleteActividad">
            Aceptar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import services from "@/services";
import { mapActions } from "vuex";

export default {
  name: "ActividadesDatatableDialogs",
  data() {
    return {
      datos:[],
      show: {
        view: false,
        delete: false,
        change: false,
      },
      
    };
  },
  methods: {
    ...mapActions('app', ['showError', 'showSuccess']),
    async viewActividad() {
      try {
        this.datos = [
          { titulo:'Dirigido A:', valor: this.actividad.vdirigido_a == 'vehiculo' ? 'Vehículos' : 'Equipos de carga' },
          { titulo: 'Modelo', valor: 'Pendiente'  },
          { titulo: 'Tipo de cojunto', valor: this.actividad.conjunto  },
          { titulo: 'Complejidad', valor: this.actividad.complejidad  },
          { titulo: 'Clave', valor: this.actividad.vclave  },
          { titulo: 'Kilometraje para realizar', valor: this.actividad.ikms  },
          { titulo: 'Meses para realizar', valor: this.actividad.imeses  },
          { titulo: 'Tolerancia en Kms', valor: this.actividad.itolerancia_kms + ' Kms'  },
          { titulo: 'Tolerancia en meses', valor: this.actividad.itolerancia_meses  },
          { titulo: 'Costo de mano de obra', valor: this.actividad.mano_obra  },
          { titulo: 'Costos de refacciones', valor: this.actividad.refacciones  },
          { titulo: 'Otros costos', valor: this.actividad.otro  },
          { titulo: 'Costo total', valor: this.actividad.fcosto_total  },
        ],

        this.show.view = true;
      }
      catch (error) {
        const message = 'Error al cargar la información.';
        this.showError({ message, error });
      }
    },
    async deleteActividad() {
      try {
        const { message } = await services.mantounidades().deleteActividad(this.actividad.iid);
        this.$parent.loadActividadesTable();
        this.showSuccess(message);

      } catch (error) {
        const message = 'Error al activar/desactivar actividad.';
        this.showError({ message, error });
      }

      this.show.delete = false;
    },
  },
  watch: {
    ["show.change"](newValue) {
      if (newValue) return;
      this.$refs.form.reset();
    },
  },
};
</script>