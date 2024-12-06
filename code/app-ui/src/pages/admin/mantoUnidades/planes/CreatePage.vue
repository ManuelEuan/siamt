<template>
  <v-container fluid>
    <v-row justify="center">
      <v-col cols="12" class="pa-0">
        <v-card flat>
          <v-toolbar>
            <v-toolbar-title>Nuevo Plan</v-toolbar-title>
          </v-toolbar>
        </v-card>
      </v-col>

      <v-col cols="12" class="pa-0 mt-2">
        <v-card flat>
          <v-card-text>
            <v-form v-model="valid">
              <v-row>
                <v-col cols="3">
                  <v-select
                    v-model="plan.modeloId"
                    label="Modelo*"
                    :rules="[rules.required]"
                    :items="modelos"
                    item-text="nombre"
                    item-value="id"
                    hide-details="auto"
                    clearable
                    dense
                    outlined
                  />
                </v-col>
                <v-col cols="3">
                  <v-text-field v-model="plan.nombre" label="Nombre*" :rules="[rules.required]" hide-details="auto" clearable dense outlined />
                </v-col>
                <v-col cols="3">
                  <v-text-field v-model="plan.ciclo" label="Ciclo*" :rules="[rules.required,rules.positiveIntNumber]" type="number" hide-details="auto" clearable dense outlined />
                </v-col>
                <v-col cols="3">
                  <v-text-field v-model="plan.meses" label="Meses*" :rules="[rules.required,rules.positiveIntNumber]" type="number" hide-details="auto" clearable dense outlined />
                </v-col>
                <v-col cols="12">
                  <v-textarea v-model="plan.comentarios" label="Comentarios" hide-details="auto" clearable dense outlined />
                </v-col>
              </v-row>
            </v-form>
          </v-card-text>

          <v-card-actions>
            <v-spacer />
            <v-btn color="error" text @click="backPage()">Cerrar</v-btn>
            <v-btn color="primary" text :disabled="!valid" @click="save()">Guardar</v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import rules from "@/core/rules.forms";
import services from "@/services";
import { mapActions } from "vuex";

const FAILURE_MSG = "Error al guardar el plan";
const PLANS_PAGE = "/mantenimiento/planes";
const STATUS_CODE = { success: 200, failure: 403 };

export default {
  name: "PlanCreatePage",
  data() {
    return {
      valid: false,
      plan: {},
      modelos: [],
      rules,
    };
  },
  computed: {},
  methods: {
    ...mapActions("app", ["showError", "showSuccess"]),
    async save() {
      if (!this.valid) {
        return;
      }

      const plan = {
        modeloId: this.plan.modeloId,
        nombre: this.plan.nombre,
        ciclo: Number(this.plan.ciclo),
        meses: Number(this.plan.meses),
        comentarios: this.plan.comentarios,
      };

      const { message: data, statusCode } = await services.mantounidades().savePlan(plan);

      if (statusCode === STATUS_CODE.success) {
        this.showSuccess(data);
        this.backPage();
        return;
      }

      this.showError({ message: FAILURE_MSG, error: data });
    },
    backPage() {
      this.$router.push(PLANS_PAGE);
    },
  },
  async mounted() {
    this.modelos = await services.mantounidades().getModelos();
  }
};
</script>
