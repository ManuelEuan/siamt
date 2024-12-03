<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <v-card flat>
                    <v-toolbar>
                        <v-toolbar-title>{{ createMode ? "Nueva" : "Editar" }} Actividad</v-toolbar-title>
                    </v-toolbar>
                </v-card>
            </v-col>
            <v-col cols="12" class="pa-0 mt-2">
                
                <v-tabs-items v-model="tab">
                    <v-card flat>
                        <v-tab-item :key="1" value="generaltab" class="py-1">
                            <v-card-text>
                                <v-form v-model="valid">
                                    <v-row>
                                        <v-col cols="3">
                                            <v-select
                                                v-model="actividad.dirigido_a"
                                                label="Dirigido"
                                                :rules="[rules.required]"
                                                :items="dirigido"
                                                item-text="descripcion"
                                                item-value="valor"
                                                hide-details="auto"
                                                small-chips
                                                clearable
                                                dense
                                                outlined
                                            />
                                        </v-col>

                                        <v-col cols="3">
                                            <v-select
                                                v-model="actividad.modeloId"
                                                label="Modelo"
                                                :rules="[rules.required]"
                                                :items="modelos"
                                                item-text="nombre"
                                                item-value="id"
                                                hide-details="auto"
                                                small-chips
                                                clearable
                                                dense
                                                outlined
                                            />
                                        </v-col>

                                        <v-col cols="3">
                                            <v-select
                                                v-model="actividad.tipoConjuntoId"
                                                label="Tipos de conjuntos"
                                                :rules="[rules.required]"
                                                :items="tiposConjuntos.items"
                                                item-text="txtdescripcion"
                                                item-value="iid"
                                                hide-details="auto"
                                                small-chips
                                                clearable
                                                dense
                                                outlined
                                            />
                                        </v-col>

                                        <v-col cols="3">
                                            <v-select
                                                v-model="actividad.complejidadId"
                                                label="Complejidad"
                                                :rules="[rules.seleecion]"
                                                :items="complejidades.items"
                                                item-text="txtdescripcion"
                                                item-value="iid"
                                                hide-details="auto"
                                                small-chips
                                                clearable
                                                dense
                                                outlined
                                            />
                                        </v-col>

                                        <v-col cols="6" md="3">
                                            <v-text-field v-model="actividad.clave" label="Clave*" :rules="[rules.required]" hide-details="auto" clearable dense outlined />
                                        </v-col>

                                        <v-col cols="6" md="3">
                                            <v-text-field v-model="actividad.descripcion" label="Descripcion*" :rules="[rules.required]" hide-details="auto" clearable dense outlined />
                                        </v-col>

                                        <v-col cols="6" md="3">
                                            <v-text-field type="number" v-model="actividad.kms" label="Kilometraje a realizar el mantenimiento *" :rules="[rules.required,rules.positiveIntNumber]" hide-details="auto" clearable dense outlined />
                                        </v-col>

                                        <v-col cols="6" md="3">
                                            <v-text-field type="number" v-model="actividad.meses" label="Meses a realizar el mantenimiento" :rules="[rules.positiveIntNumber]" hide-details="auto" clearable dense outlined />
                                        </v-col>

                                        <v-col cols="6" md="3">
                                            <v-text-field type="number" v-model="actividad.tolerancia_kms" label="Tolerancia en Kms*" :rules="[rules.required,rules.positiveIntNumber]" hide-details="auto" clearable dense outlined />
                                        </v-col>

                                        <v-col cols="6" md="3">
                                            <v-text-field type="number" v-model="actividad.tolerancia_meses" label="Tolerancia en meses" :rules="[rules.positiveIntNumber]" hide-details="auto" clearable dense outlined />
                                        </v-col>

                                        <v-col cols="6" md="3">
                                            <v-text-field type="number" v-model="actividad.costo_mano_obra" label="Costo de mano de obra*" :rules="[rules.required, rules.positiveIntNumber]" hide-details="auto" clearable dense outlined />
                                        </v-col>

                                        <v-col cols="6" md="3">
                                            <v-text-field type="number" v-model="actividad.costo_refacciones" label="Costo de refacciones" :rules="[rules.positiveIntNumber]" hide-details="auto" clearable dense outlined />
                                        </v-col>

                                        <v-col cols="6" md="3">
                                            <v-text-field type="number" min-value v-model="actividad.costo_otro" label="Otros costos" :rules="[rules.positiveIntNumber]" hide-details="auto" clearable dense outlined />
                                        </v-col>
                                        
                                        <v-col cols="6" md="3">
                                            <v-text-field type="number" v-model="actividad.costo_total" disabled="disabled" label="Total de costos"  :rules="[rules.positiveIntNumber]" hide-details="auto" clearable dense outlined />
                                        </v-col>

                                        <v-col cols="12">
                                            <v-textarea v-model="actividad.notas_tecnicas" label="Notas tecnicas" hide-details="auto" clearable dense outlined />
                                        </v-col>
                                    </v-row>
                                </v-form>
                            </v-card-text>
                        </v-tab-item>
                        
                        <v-card-actions>
                            <v-spacer />
                            <v-btn color="error" text @click="exitWindow()"> Cerrar </v-btn>
                            <v-btn color="primary" text :disabled="!valid" @click="save()"> Guardar </v-btn>
                        </v-card-actions>
                    </v-card>
                </v-tabs-items>
            </v-col>
        </v-row>
    </v-container>
</template>

  
  
<script>
import rules from "@/core/rules.forms";
import services from "@/services";
import { mapActions } from "vuex";

export default {
    data() {
        return {
            valid: false,
            tab: "generaltab",
            tiposConjuntos: [],
            complejidades: [],
            modelos:[],
            dirigido: [],
            actividad: {
                id: 0,
                tipoConjuntoId:0, 
                complejidadId:0, 
                modeloId:0, 
                clave: "",
                dirigido_a:"",
                descripcion:"",
                kms:"",
                meses:"",
                tolerancia_kms:"",
                tolerancia_meses:"",
                costo_mano_obra:"",
                costo_refacciones:"",
                costo_otro:"",
                costo_total:0,
                notas_tecnicas:"",
            },
            rules: {
                ...rules
            },
        };
    },
    computed: {
        createMode() {
            return !this.$route.params.id;
        },
    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),
        async setEditMode() {
            try {
                const { id } = this.$route.params;
                const actividad = await services.mantounidades().getActividades({ id: id });

                this.actividad.id  = actividad.items[0].iid;
                this.actividad.tipoConjuntoId   = actividad.items[0].iidtipo_conjunto;
                this.actividad.complejidadId    = actividad.items[0].iidcomplejidad;
                this.actividad.modeloId         = actividad.items[0].iidmodelo;
                this.actividad.clave            = actividad.items[0].vclave;
                this.actividad.dirigido_a       = actividad.items[0].vdirigido_a;
                this.actividad.descripcion      = actividad.items[0].txtdescripcion;
                this.actividad.kms              = actividad.items[0].ikms;
                this.actividad.meses            = actividad.items[0].imeses;
                this.actividad.tolerancia_kms   = actividad.items[0].itolerancia_kms;
                this.actividad.tolerancia_meses = actividad.items[0].itolerancia_meses;
                this.actividad.costo_mano_obra  = actividad.items[0].fcosto_mano_obra;
                this.actividad.costo_refacciones= actividad.items[0].fcosto_refacciones;
                this.actividad.costo_otro       = actividad.items[0].fcosto_otro;
                this.actividad.costo_total      = actividad.items[0].fcosto_total;
                this.actividad.notas_tecnicas   = actividad.items[0].txtnotas_tecnicas;
            } catch (error) {
                const message = 'Error al cargar información de la actividad.';
                this.showError({ message, error });
            }
        },
        async save() {
            if (!this.valid) return;

            try {
                const { message } = await (
                    this.createMode ?
                        services.mantounidades().saveActividad(this.actividad) :
                        services.mantounidades().updateActividad(this.actividad)
                );

                this.showSuccess(message);
                this.exitWindow();
            } catch (error) {
                const message = 'Error al guardar la actividad.';
                this.showError({ message, error });
            }

        },
        exitWindow() {
            this.$router.push("/mantenimiento/actividades");
        },
    },
    watch: {
        actividad: {
            handler(newVal) {
                let manoObra    = newVal.costo_mano_obra == "" ? 0 : parseFloat(newVal.costo_mano_obra);
                let refaccion   = newVal.costo_refacciones == "" ? 0 : parseFloat(newVal.costo_refacciones);
                let otros       = newVal.costo_otro == "" ? 0 : parseFloat(newVal.costo_otro)
                this.actividad.costo_total = manoObra + refaccion + otros;
            },
            deep: true
        }
    },
    async mounted() {
        this.tiposConjuntos = await services.mantounidades().getTipoConjunto();
        this.complejidades  = await services.mantounidades().getComplejidad();
        this.modelos        = [{ id: 1, nombre : 'Chevrolet' },{id:2, nombre : 'Nissan'},{id:3, nombre : 'Toyota'},{id:4, nombre : 'Mazda'}];
        this.dirigido       = [{ valor: 'vehiculo', descripcion : 'Vehículos' },{valor:'equipo_de_carga', descripcion : 'Equipos de carga'}];

        if (!this.createMode) await this.setEditMode();
    },
};
</script>
