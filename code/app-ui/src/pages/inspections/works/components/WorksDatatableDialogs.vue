<template>
  <div class="wrapper">
    <v-dialog transition="dialog-top-transition" max-width="600" v-model="show.view">
      <v-card>
        <v-card-title class="text-uppercase primary--text text-h6 py-2"> ver inspector </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="py-0 my-0">
          <v-list class="pa-0 ma-0">
            <v-container class="pa-0 ma-0">
              <v-row dense>
                <template v-for="(value, key, index) in inspector">
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
          {{ inspector.activo ? "desactivar" : "activar" }} inspector
        </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="text-lowercase text-body-1 py-2">
          ¿est&aacute;s seguro de que deseas {{ inspector.activo ? "desactivar" : "activar" }} este
          inspector?
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions class="py-2">
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="show.delete = false"> Cerrar </v-btn>
          <v-btn color="primary" text @click="deleteInspector">
            {{ inspector.activo ? "Desactivar" : "Activar" }}
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
  name: "InspectorsDatatableDialogs",
  data() {
    return {
      chips: ["iidpersona", "iidetapa", "iidturno", "iidinspector_categoria", "total_inspectores"],
      headers: {
        iidinspector: "no. inspector",
        txtinspector_etapa: "Etapa",
        txttarjeton: "Tarjetón",
        txtinspector_turno: "Turno",
        txtnombre: "Nombre",
        txtapepat: "Apellido paterno",
        txtapemat: "Apellido materno",
        txtrfc: "RFC",
        txtcurp: "CURP",
        txtine: "INE",
        txtcomentarios: "Comentarios",
        txtinspector_categoria: "Categoría",
        dvigencia: "Vigencia tarjetón",
        dfecha_alta: "Fecha de alta",
        dfecha_baja: "Fecha de baja",
        fecha_creacion: "Fecha creacion",
        fecha_modificacion: "Fecha modificación",
      },
      show: {
        view: false,
        delete: false,
        change: false,
      },
      permissions: [],
      inspector: {},
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
    async viewInspector() {
      try {
        console.log(this.inspector)
        this.show.view = true;
      }
      catch (error) {
        const message = 'Error al cargar la información.';
        this.showError({ message, error });
      }
    },
    async deleteInspector() {
      try {
        const { message } = await services.inspections().deleteInspector(this.inspector.iidinspector);
        this.$parent.loadInspectorsTable();
        this.showSuccess(message);
      } catch (error) {
        const message = 'Error al activar/desactivar inspector.';
        this.showError({ message, error });
      }

      this.show.delete = false;
    },
  }
};
</script>
  