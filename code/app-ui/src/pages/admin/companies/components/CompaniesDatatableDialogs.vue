<template>
  <div class="wrapper">
    <!-- Dialogo para ver la empresa -->
    <v-dialog transition="dialog-top-transition" max-width="600" v-model="show.view">
      <v-card>
        <v-card-title class="primary--text text-h6 py-2">VER EMPRESA</v-card-title>
        <v-divider></v-divider>
        <v-card-text class="py-0 my-0">
          <v-list class="pa-0 ma-0">
            <v-container class="pa-0 ma-0">
              <v-row dense>
                <template v-for="(value, key, index) in company">
                  <v-col 
                    v-if="!chips.includes(key) && value !== null && value !== ''" 
                    class="pa-0 ma-0" 
                    :key="index" 
                    cols="6"
                  >
                    <v-list-item>
                      <v-list-item-content class="py-2">
                        <v-list-item-title class="text-capitalize text-h7">
                          {{ headers[key] ?? key }}
                        </v-list-item-title>
                        <v-list-item-subtitle class="text-body-1">
                          {{ typeof value === 'boolean' ? '' : value || 'No disponible' }}
                          <v-icon v-show="value === true" size="medium" color="green">mdi-check</v-icon>
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
        <v-card-actions class="py-2">
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="show.view = false">Cerrar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Dialogo para activar/desactivar la empresa -->
    <v-dialog transition="dialog-top-transition" max-width="600" v-model="show.delete">
      <v-card>
        <v-card-title class="text-uppercase primary--text text-h6 py-2">
          {{ company.activo ? "Desactivar" : "Activar" }} Empresa
        </v-card-title>
        <v-divider></v-divider>
        <v-card-text class="text-lowercase text-body-1 py-2">
          ¿Estás seguro de que deseas {{ company.activo ? "desactivar" : "activar" }} esta empresa?
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions class="py-2">
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="show.delete = false">Cerrar</v-btn>
          <v-btn color="primary" text @click="deleteCompany">
            {{ company.activo ? "Desactivar" : "Activar" }}
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
  name: "CompaniesDatatableDialogs",
  data() {
    return {
      chips: ["iidpersona", "total_companies"],
      headers: {
        iidempresa: "No. Empresa",
        iidpersona: "No. Empresa",
        txtnombre_completo: "Nombre",
        fecha_creacion: "Fecha creación",
        fecha_modificacion: "Fecha modificación",
        activo: "Activo"
      },
      show: {
        view: false,
        delete: false,
        change: false,
      },
      company: {},
      form: {
        valid: false,
      },
    };
  },
  computed: {
    rules() {
      return {
        ...rules,
      };
    }
  },
  methods: {
    ...mapActions('app', ['showError', 'showSuccess']),
    async viewCompany() {
      try {
        console.log(this.company);
        if (Object.keys(this.company).length) {
          this.show.view = true;
        } else {
          this.showError({ message: 'No hay información para mostrar.' });
        }
      } catch (error) {
        this.showError({ message: 'Error al cargar la información.', error });
      }
    },
    async deleteCompany() {
      try {
        const { message } = await services.admin().deleteCompany(this.company.iidempresa);
        this.$parent.loadCompaniesTable();
        this.showSuccess(message);
      } catch (error) {
        this.showError({ message: 'Error al activar/desactivar empresa.', error });
      } finally {
        this.show.delete = false;
      }
    },
  }
};
</script>
