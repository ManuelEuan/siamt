<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <v-card flat>
                    <v-toolbar>
                        <v-toolbar-title>{{ createMode ? "Nuevo" : "Editar" }} Mantenimiento Correctivo</v-toolbar-title>
                    </v-toolbar>
                </v-card>
            </v-col>
            <v-col cols="12" class="pa-0 mt-2">
                <v-card flat>
                    <v-card-text>
                        <v-form v-model="valid">
                            <v-row>
                                <v-col cols="6" md="3">
                                    <v-autocomplete label="Unidades" :items="unidades" :rules="[rules.required]" hide-details="auto" clearable dense outlined 
                                        v-model="correctivo.unidadId" item-text="numeroEconomico" item-value="id" @change="infoUnidad" ></v-autocomplete>
                                </v-col>

                                <v-col cols="6" md="3">
                                    <v-text-field v-model="correctivo.placa" label="Placa" disabled hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="6" md="3">
                                    <v-text-field v-model="correctivo.numero" label="Número Económico" disabled hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="6" md="3">
                                    <v-text-field v-model="correctivo.marca" label="Marca" disabled hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="6" md="3">
                                    <v-text-field v-model="correctivo.modelo" label="Modelo" disabled hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="6" md="3">
                                    <v-text-field type="number" v-model="correctivo.anio" label="Año" disabled hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="6" md="3">
                                    <v-text-field v-model="correctivo.serie" label="Serie" disabled  hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="6" md="3">
                                    <v-text-field v-model="correctivo.odometro" label="Odómetro" disabled hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="6" md="3">
                                    <v-menu v-model="correctivo.fechaSalidaMenu" :close-on-content-click="false" :nudge-right="40"  transition="scale-transition" offset-y  min-width="290px" >
                                        <template v-slot:activator="{ on, attrs }">
                                            <v-text-field v-model="correctivo.fecha_ingreso" label="Fecha Ingreso*" readonly v-bind="attrs" v-on="on" outlined dense></v-text-field>
                                        </template>

                                        <v-date-picker v-model="correctivo.fecha_ingreso" no-title scrollable >
                                            <v-spacer></v-spacer>
                                            <v-btn text color="primary" @click="correctivo.fechaSalidaMenu = false"> Cancelar </v-btn>
                                            <v-btn text color="primary" @click="correctivo.fechaSalidaMenu = false"> Aceptar </v-btn>
                                        </v-date-picker>
                                    </v-menu>
                                </v-col>

                                <v-col cols="6" md="3">
                                    <v-menu v-model="correctivo.fechaIngresoMenu" :close-on-content-click="false" :nudge-right="40"  transition="scale-transition" offset-y  min-width="290px" >
                                        <template v-slot:activator="{ on, attrs }">
                                            <v-text-field v-model="correctivo.fecha_salida" label="Fecha Salida" readonly v-bind="attrs" v-on="on" outlined dense></v-text-field>
                                        </template>

                                        <v-date-picker v-model="correctivo.fecha_salida" no-title scrollable :rules="[rules.required]">
                                            <v-spacer></v-spacer>
                                            <v-btn text color="primary" @click="correctivo.fechaIngresoMenu = false"> Cancelar </v-btn>
                                            <v-btn text color="primary" @click="correctivo.fechaIngresoMenu = false"> Aceptar </v-btn>
                                        </v-date-picker>
                                    </v-menu>
                                </v-col>

                                <v-col cols="6" md="3">
                                    <v-text-field v-model="correctivo.lugar" label="Lugar del servicio*" :rules="[rules.required]" hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="6" md="3">
                                    <v-text-field type="number" v-model="correctivo.costo_total" label="Costo del servicio*" :rules="[rules.required, rules.positiveIntNumber]" hide-details="auto" clearable dense outlined />
                                </v-col>
                                
                                <v-col cols="4" style="margin-top: -2%;">
                                    <v-text-field v-model="correctivo.descripcion" label="Descripcion" hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="4" style="margin-top: -2%;">
                                    <v-autocomplete label="Estatus" :items="estatus.items" :rules="[rules.required]" hide-details="auto" clearable dense outlined 
                                        v-model="correctivo.estatusId" item-text="txtdescripcion" item-value="iid" ></v-autocomplete>
                                </v-col>
                                
                                <v-col cols="4" style="margin-top: -2%;">
                                    <v-text-field label="Archivo de factura" hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="12" style="margin-top: -1%;">
                                    <v-textarea v-model="correctivo.comentarios" rows="3" label="Acciones Realizadas" hide-details="auto" clearable dense outlined />
                                </v-col>
                            </v-row>
                        </v-form>
                    </v-card-text>
                    <v-card-actions>
                        <v-spacer />
                        <v-btn color="error" text @click="exitWindow()"> Cerrar </v-btn>
                        <v-btn color="primary" text :disabled="!valid" @click="save()"> Guardar </v-btn>
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

export default {
    data() {
        return {
            valid: false,
            unidades: [],
            estatus: [],
            correctivo: {
                estatusId: "",
                unidadId: "",
                placa: "",
                numero: "",
                marca: "",
                modelo: "",
                anio: "",
                serie: "",
                odometro:"",
                fecha_ingreso: "",
                fecha_salida: "",
                lugar: "",
                costo_total: "",
                descripcion: "",
                comentarios: "",
                tipo: 'correctivo',
                fechaIngresoMenu: false,
                fechaSalidaMenu: false
            },
            rules: {
                ...rules,
            },
        };
    },
    computed: {
        createMode() {
            return !this.$route.params.id;
        },
    },
    methods: {
        ...mapActions("app", ["showError", "showSuccess"]),
        infoUnidad(id) {
            const value  = this.unidades.filter(item => item.id == id);

            if(id != null){
                this.correctivo.placa   = value[0].placa;
                this.correctivo.numero  = value[0].numeroEconomico;
                this.correctivo.marca   = value[0].nombreMarca;
                this.correctivo.modelo  = value[0].modelo;
                this.correctivo.anio    = value[0].anio;
                this.correctivo.serie   = value[0].serie;
                this.correctivo.odometro = value[0].Odometro;
            }
        },
        async setEditMode() {
            try {
                const { id } = this.$route.params;
                const value = await services.mantounidades().getMantenimientos({ id });
                
                this.correctivo.id          = value.items[0].iid;
                this.correctivo.estatusId   = value.items[0].iidestatus;
                this.correctivo.unidadId    = value.items[0].iidunidad;
                this.correctivo.fecha_ingreso = value.items[0].ingreso;
                this.correctivo.fecha_salida  = value.items[0].salida;
                this.correctivo.lugar       = value.items[0].txtlugar;
                this.correctivo.costo_total = value.items[0].costo;
                this.correctivo.descripcion  = value.items[0].txtdescripcion;
                this.correctivo.comentarios  = value.items[0].txtcomentarios;
                this.infoUnidad(this.correctivo.unidadId);

                
            } catch (error) {
                this.showError({ message: "Error al cargar la información del correctivo.", error });
            }
        },
        async save() {
            if (!this.valid) return;

            try {
                const { message } = await (
                    this.createMode
                        ? services.mantounidades().saveMantenimiento(this.correctivo)
                        : services.mantounidades().updateMantenimiento(this.correctivo)
                );

                this.showSuccess(message);
                this.exitWindow();
            } catch (error) {
                this.showError({ message: "Error al guardar el correctivo.", error });
            }
        },
        exitWindow() {
            this.$router.push("/mantenimiento/correctivos");
        },
    },
    async mounted() {
        this.estatus    = await services.mantounidades().getEstatus({tipo:'correctivo'});
        this.unidades   = await services.mantounidades().getUnidades();
        if (!this.createMode) await this.setEditMode();
    },
};
</script>
