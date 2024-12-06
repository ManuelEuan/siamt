<template>
  <v-container fluid>
    <v-row justify="center">
      <v-col cols="12" class="pa-0">
        <v-card flat>
          <v-toolbar>
            <v-toolbar-title> Plan de mantenimiento</v-toolbar-title>
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

const PLANS_PAGE = "/mantenimiento/planes";

export default {
  name: "PlanCreatePage",
  data() {
    return {
      valid: false,
      plan: {
        modeloId: '',
        nombre: '',
        ciclo: '',
        meses: '',
        comentarios: ''
      },
      modelos: [],
      rules,
    };
  },
  computed: {
    createMode() {
      return !this.$route.params.id;
    },
  },
  methods: {
    ...mapActions("app", ["showError", "showSuccess"]),
    async save() {
      if (!this.valid) return;

      try {
          const { message } = await (
            this.createMode ?
              services.mantounidades().savePlan(this.plan) :
              services.mantounidades().updatePlan(this.plan)
          );

          this.showSuccess(message);
          this.backPage();
      } catch (error) {
          const message = 'Error al guardar el plan.';
          this.showError({ message, error });
      }
    },
    async setEditMode() {
      try {
        const { id } = this.$route.params;
        const item  = await services.mantounidades().getPlanes({ id: id });
        this.plan.id        = item.items[0].iid;
        this.plan.modeloId  = item.items[0].iidmodelo;
        this.plan.nombre    = item.items[0].vnombre;
        this.plan.ciclo     = item.items[0].iciclo;
        this.plan.meses     = item.items[0].imeses;
        this.plan.comentarios = item.items[0].txtcomentarios;
      } catch (error) {
          const message = 'Error al cargar información del plan.';
          this.showError({ message, error });
      }
    },
    backPage() {
      this.$router.push(PLANS_PAGE);
    },
  },
  async mounted() {
    this.modelos = await services.mantounidades().getModelos();
    if (!this.createMode) await this.setEditMode();
  }
};
</script>
