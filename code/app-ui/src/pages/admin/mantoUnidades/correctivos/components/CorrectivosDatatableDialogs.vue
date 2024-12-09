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
                         Comentarios
                        </v-list-item-title>

                        <v-list-item-subtitle class="text-lowercase text-body-1 py-1">
                          <v-textarea v-model="this.correctivo.comentarios" rows="3" disabled hide-details="auto" clearable dense outlined />
                        </v-list-item-subtitle>
                      </v-list-item-content>
                    </v-list-item>
                  </v-col>

                  <v-col class="pa-0 ma-0" cols="12" >
                    <v-list-item>
                      <v-list-item-content class="py-2">
                        <v-list-item-title class="text-capitalize text-h7">
                         Acciones Realizadas
                        </v-list-item-title>

                        <v-list-item-subtitle class="text-lowercase text-body-1 py-1">
                          <v-textarea v-model="this.correctivo.acciones" rows="3" disabled hide-details="auto" clearable dense outlined />
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
          {{ correctivo.bactivo ? "desactivar" : "activar" }} correctivo
        </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="text-body-1 py-2">
          ¿Est&aacute;s seguro de que deseas eliminar esta correctivo?
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions class="py-2">
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="show.delete = false"> Cerrar </v-btn>
          <v-btn color="primary" text @click="deleteCorrectivo">
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
  name: "CorrectivosDatatableDialogs",
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
    async viewCorrectivo() {
      try {
        this.datos = [
        { titulo: 'Marca', valor: 'Marca X' },
  { titulo: 'Modelo', valor: 'Modelo 123' },
  { titulo: 'Serie', valor: 'SERIE12345' },
  { titulo: 'Placa', valor: 'ABC-1234' },
  { titulo: 'Año', valor: 2020 },
  { titulo: 'Fecha de Ingreso', valor: '2024-11-25' },
  { titulo: 'Fecha Estimada', valor: '2024-12-05' },
  { titulo: 'Fecha de Egreso', valor: '2024-12-10' },
  { titulo: 'Costo de Mantenimiento', valor: '$1500' },
 
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
        const { message } = await services.mantounidades().deleteCorrectivo(this.correctivo.id);
        this.$parent.loadCorrectivosTable();
        this.showSuccess(message);

      } catch (error) {
        const message = 'Error al activar/desactivar el mantenimiento correctivo.';
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