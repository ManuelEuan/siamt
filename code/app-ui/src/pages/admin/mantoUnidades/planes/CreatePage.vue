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
                    dense
                    outlined
                    v-model="plan.modeloId"
                    label="Modelo*"
                    item-text="nombre"
                    item-value="id"
                    hide-details="auto"
                    :rules="[rules.required]"
                    :items="modelos"
                    @input="selectModelo($event)"
                  />
                </v-col>
                <v-col cols="3">
                  <v-text-field v-model="plan.nombre" label="Nombre*" :rules="[rules.required]" hide-details="auto" clearable dense outlined />
                </v-col>
                <v-col cols="3">
                  <v-text-field v-model="plan.ciclo" label="Ciclo*" :rules="[rules.required, rules.positiveIntNumber]" type="number" hide-details="auto" clearable dense outlined />
                </v-col>
                <v-col cols="3">
                  <v-text-field v-model="plan.meses" label="Meses*" :rules="[rules.required, rules.positiveIntNumber]" type="number" hide-details="auto" clearable dense outlined />
                </v-col>
                <v-col cols="12">
                  <v-textarea v-model="plan.comentarios" label="Comentarios" hide-details="auto" clearable dense outlined />
                </v-col>
              </v-row>

              <v-row>
                <v-col cols="12">
                  <v-select
                    dense
                    outlined
                    ref="vSelectActividades"
                    label="Actividades"
                    item-text="txtdescripcion"
                    item-value="iid"
                    :items="actividades"
                    @input="selectActividad($event)"
                  ></v-select>
                  <v-data-table class="elevation-1" :headers="tblActividades.headers" :items="tblActividades.items" :loading="tblActividades.loading">
                    <template v-slot:item.acciones="{ item }">
                      <v-tooltip bottom>
                        <template v-slot:activator="{ on, attrs }">
                          <v-btn icon small v-bind="attrs" v-on="on" @click="removeActividad(item.iid)">
                            <v-icon small> mdi-delete </v-icon>
                          </v-btn>
                        </template>
                        <span>Eliminar</span>
                      </v-tooltip>
                    </template>
                  </v-data-table>
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

const FAILURE_CODE = 403;
const PLANS_PAGE = "/mantenimiento/planes";

export default {
  name: "PlanesForm",
  data() {
    return {
      valid: false,
      loading: false,
      modelos: [],
      actividades: [],
      plan: {
        id: 0,
        modeloId: 0,
        nombre: "",
        ciclo: "",
        meses: "",
        comentarios: "",
      },
      tblActividades: {
        headers: [
          {
            text: "Clave",
            value: "vclave",
            align: "center",
            class: "font-weight-bold",
          },
          {
            text: "Descripción",
            value: "txtdescripcion",
            align: "center",
            class: "font-weight-bold",
          },
          {
            text: "Dirigido",
            value: "vdirigido_a",
            align: "center",
            class: "font-weight-bold",
          },
          {
            text: "Complejidad",
            value: "complejidad",
            align: "center",
            class: "font-weight-bold",
          },
          {
            text: "Tipo de conjunto",
            value: "conjunto",
            align: "center",
            class: "font-weight-bold",
          },
          {
            text: "Acciones",
            value: "acciones",
            align: "center",
            sortable: false,
            width: "100px",
          },
        ],
        options: {
          page: 1,
          sortBy: ["vclave"],
        },
        loading: false,
        items: [],
      },
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
    async setEditMode() {
      const { datos, detalles } = await services.mantounidades().getPlanActividades(this.$route.params.id);

      if (!datos.length) {
        this.showError({ message: "Error al cargar información del plan" });
        this.backPage();
        return;
      }

      const [plan] = datos;
      this.plan.id = plan.iid;
      this.plan.modeloId = plan.iidmodelo;
      this.plan.nombre = plan.vnombre;
      this.plan.ciclo = plan.iciclo;
      this.plan.meses = plan.imeses;
      this.plan.comentarios = plan.txtcomentarios;

      this.tblActividades.items = detalles.map(detalle => ({
        iid: detalle.iid,
        vclave: detalle.clave_actividad,
        txtdescripcion: detalle.descripcion_actividad,
        vdirigido_a: detalle.vdirigido_a,
      }));
    },
    async selectModelo(idModelo) {
      this.actividades = [];
      this.tblActividades.items = [];

      if (idModelo) {
        const params = { modelo_id: idModelo };
        const { items } = await services.mantounidades().getActividades(params);
        this.actividades = items;
      }
    },
    selectActividad(idActividad) {
      if (idActividad) {
        this.$refs["vSelectActividades"].reset();
        this.swapActividad(idActividad, this.actividades, this.tblActividades.items);
      }
    },
    removeActividad(idActividad) {
      this.swapActividad(idActividad, this.tblActividades.items, this.actividades);
    },
    swapActividad(idActividad, source, dest) {
      const index = source.findIndex((actividad) => actividad.iid === idActividad);
      const [actividad] = source.splice(index, 1);
      dest.push(actividad);
    },
    async save() {
      if (!this.valid) return;

      if (!this.tblActividades.items.length) {
        this.showError({ message: "Debe seleccionar al menos una actividad" });
        return;
      }

      await this.savePlan();
    },
    async savePlan() {
      const plan = {
        id: this.plan.id,
        modeloId: this.plan.modeloId,
        nombre: this.plan.nombre,
        ciclo: Number(this.plan.ciclo),
        meses: Number(this.plan.meses),
        comentarios: this.plan.comentarios,
      };

      const response = await (this.createMode ? services.mantounidades().savePlan(plan) : services.mantounidades().updatePlan(plan));
      const {
        data: { id, message },
        statusCode,
      } = response;

      if (statusCode === FAILURE_CODE) {
        this.showError({ message: "Error al guardar el plan" });
        return;
      }

      await this.saveActividades(this.createMode ? id : plan.id);

      this.showSuccess(message);
      this.backPage();
    },
    async saveActividades(idPlan) {
      for (const { iid } of this.tblActividades.items) {
        const actividad = { planMantenimientoId: idPlan, actividadId: iid };
        await services.mantounidades().savePlanActividad(actividad);
      }
    },
    backPage() {
      this.$router.push(PLANS_PAGE);
    },
  },
  async mounted() {
    this.modelos = await services.mantounidades().getModelos();
    if (!this.createMode) await this.setEditMode();
  },
};
</script>
