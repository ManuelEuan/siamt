<template>
  <div class="wrapper">
    <v-dialog transition="dialog-top-transition" max-width="600" v-model="show.view">
      <v-card>
        <v-card-title class="text-uppercase primary--text text-h6 py-2"> ver boleta </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="py-0 my-0">
          <v-list class="pa-0 ma-0">
            <v-container class="pa-0 ma-0">
              <v-row dense>
                <template v-for="(value, key, index) in ticket">
                  <v-col v-if="!chips.includes(key) && value !== null" class="pa-0 ma-0" cols="6" :key="index">
                    <v-list-item>
                      <v-list-item-content class="py-2">
                        <v-list-item-title class="text-capitalize text-h7">
                          {{ headers[key] ?? key }}
                          <!-- {{ value !== null }} -->
                        </v-list-item-title>
                        <v-list-item-subtitle class="text-lowercase text-body-1">
                          {{ typeof value === 'boolean' ? '' : value }}
                          <v-icon v-show="value === true" size="medium" color="green"> mdi-check </v-icon>
                          <v-icon v-show="value === false" size="medium" color="red">mdi-close</v-icon>
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
        <v-divider></v-divider>
        <v-card-actions class="py-2">
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="show.view = false"> Cerrar </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog transition="dialog-top-transition" max-width="600" v-model="show.delete">
      <v-card>
        <v-card-title class="text-uppercase primary--text text-h6 py-2">
          {{ ticket.activo ? "desactivar" : "activar" }} ticket
        </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="text-lowercase text-body-1 py-2">
          ¿est&aacute;s seguro de que deseas {{ ticket.activo ? "desactivar" : "activar" }} este
          ticket?
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions class="py-2">
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="show.delete = false"> Cerrar </v-btn>
          <v-btn color="primary" text @click="deleteTicket">
            {{ ticket.activo ? "Desactivar" : "Activar" }}
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>
  
<script>
import rules from "@/core/rules.forms";
import services from "@/services";
import { mapActions } from "vuex";

export default {
  name: "TicketsDatatableDialogs",
  data() {
    return {
      chips: ["total_tickets"],
      headers: {
        iidboleta: "no. Boleta",
        dtfecha_hora_infraccion: "Fecha/Hora infracción",
        txtlugar_infraccion: "Lugar infracción",
        txtdireccion: "Dirección",
        imonto_total: "Monto Total",
        nombre_infractor: "Infractor",
        nombre_empleado: "Empleado",
        nombre_rol: "Infractor rol",
        txtlicencia: "Licencia",
        txtunidad: "Unidad",
        tarjeta_circulacion_id: "Tarjeta de circulación",
        txtreporte_especial_id: "Reporte especial",
        txtinspeccion_fisica: "Inspección Física",
        bretencion_vehiculo: "Retención de vehículo",
        bretencion_documento: "Retención de documentos",
        txtobservaciones: "Onservaciones",
        bapercibimiento: "Apercibimiento",
        dfecha_limite_comparecencia: "Fecha Límite Comparecencia",
        dfecha_limite_resolucion: "Fecha Límite resolución",
        dfecha_limite_notificacion: "Fecha Límite notificación",
        bno_ha_lugar: "Visto bueno lugar",
        bsuspension: "Suspensión",
        isuspension_dias: "Días de suspensión",
        dsuspension_fecha: "Fecha de suspensión",
        dtfecha_creacion: "Fecha creacion",
        dtfecha_modificacion: "Fecha modificación",
      },
      show: {
        view: false,
        delete: false,
        change: false,
      },
      permissions: [],
      ticket: {},
      form: {
        valid: false,
      },
    };
  },
  computed: {
    valid() {
      return this.form.valid;
    },
    rules() {
      return {
        ...rules,
      };
    }
  },
  methods: {
    ...mapActions('app', ['showError', 'showSuccess']),
    async viewTicket() {
      try {
        console.log(this.ticket)
        this.show.view = true;
      }
      catch (error) {
        const message = 'Error al cargar la información.';
        this.showError({ message, error });
      }
    },
    async deleteTicket() {
      try {
        const { message } = await services.inspections().deleteTicket(this.ticket.iidticket);
        this.$parent.loadTicketsTable();
        this.showSuccess(message);
      } catch (error) {
        const message = 'Error al activar/desactivar ticket.';
        this.showError({ message, error });
      }

      this.show.delete = false;
    },
  }
};
</script>
  