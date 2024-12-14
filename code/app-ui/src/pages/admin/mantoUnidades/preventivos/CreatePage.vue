<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <v-card flat>
                    <v-toolbar>
                        <v-toolbar-title>{{ createMode ? "Nuevo" : "Editar" }} Mantenimiento Preventivo</v-toolbar-title>
                    </v-toolbar>
                </v-card>
            </v-col>
            <v-col cols="12" class="pa-0 mt-2">
                <v-card flat>
                    <v-card-text>
                        <v-form v-model="valid">
                            <v-row>
                                <v-col cols="6" md="3">
                                    <v-text-field v-model="preventivo.placa" label="Placa" disabled hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="6" md="3">
                                    <v-text-field v-model="preventivo.numero" label="Número Económico" disabled hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="6" md="3">
                                    <v-text-field v-model="preventivo.marca" label="Marca" disabled hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="6" md="3" >
                                    <v-text-field v-model="preventivo.modelo" label="Modelo" disabled hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="6" md="3" >
                                    <v-text-field type="number" v-model="preventivo.anio" label="Año" disabled hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="6" md="3" >
                                    <v-text-field v-model="preventivo.serie" label="Serie" disabled  hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="6" md="3" >
                                    <v-text-field v-model="preventivo.empresa" label="Empresa" disabled  hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="6" md="3" >
                                    <v-text-field v-model="preventivo.odometro" label="Odómetro" disabled hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="6" md="3" >
                                    <v-menu v-model="preventivo.fechaSalidaMenu" :close-on-content-click="false" :nudge-right="40"  transition="scale-transition" offset-y  min-width="290px" >
                                        <template v-slot:activator="{ on, attrs }">
                                            <v-text-field v-model="preventivo.fecha_ingreso" label="Fecha Ingreso*" readonly v-bind="attrs" v-on="on" outlined dense></v-text-field>
                                        </template>

                                        <v-date-picker v-model="preventivo.fecha_ingreso" no-title scrollable >
                                            <v-spacer></v-spacer>
                                            <v-btn text color="primary" @click="preventivo.fechaSalidaMenu = false"> Cancelar </v-btn>
                                            <v-btn text color="primary" @click="preventivo.fechaSalidaMenu = false"> Aceptar </v-btn>
                                        </v-date-picker>
                                    </v-menu>
                                </v-col>

                                <v-col cols="6" md="3" >
                                    <v-menu v-model="preventivo.fechaIngresoMenu" :close-on-content-click="false" :nudge-right="40"  transition="scale-transition" offset-y  min-width="290px" >
                                        <template v-slot:activator="{ on, attrs }">
                                            <v-text-field v-model="preventivo.fecha_salida" label="Fecha Salida" readonly v-bind="attrs" v-on="on" outlined dense></v-text-field>
                                        </template>

                                        <v-date-picker v-model="preventivo.fecha_salida" no-title scrollable :rules="[rules.required]">
                                            <v-spacer></v-spacer>
                                            <v-btn text color="primary" @click="preventivo.fechaIngresoMenu = false"> Cancelar </v-btn>
                                            <v-btn text color="primary" @click="preventivo.fechaIngresoMenu = false"> Aceptar </v-btn>
                                        </v-date-picker>
                                    </v-menu>
                                </v-col>

                                <v-col cols="6" md="3" >
                                    <v-text-field v-model="preventivo.lugar" label="Lugar del servicio*" :rules="[rules.required]" hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="6" md="3" >
                                    <v-text-field type="number" v-model="preventivo.costo_total" label="Costo del servicio*" :rules="[rules.required, rules.positiveIntNumber]" hide-details="auto" clearable dense outlined />
                                </v-col>
                                
                                <v-col cols="4"  class="mt-n4">
                                    <v-text-field v-model="preventivo.descripcion" label="Descripcion" hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="4" class="mt-n4">
                                    <v-autocomplete label="Estatus" :items="estatus.items" :rules="[rules.required]" hide-details="auto" clearable dense outlined 
                                        v-model="preventivo.estatusId" item-text="txtdescripcion" item-value="iid" ></v-autocomplete>
                                </v-col>
                                
                                <v-col cols="4" class="mt-n4">
                                    <v-text-field label="Archivo de factura" hide-details="auto" clearable dense outlined />
                                </v-col>

                                <v-col cols="12" style="margin-top: -1%;">
                                    <v-textarea v-model="preventivo.comentarios" rows="3" label="Acciones Realizadas" hide-details="auto" clearable dense outlined />
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
            unidad: null,
            estatus: [],
            preventivo: {
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
                empresa: "",
                tipo: 'preventivo',

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
        async infoUnidad() {
            const { id } = this.$route.params;
            this.unidad  = await services.mantounidades().getUnidad(id);
            
            this.preventivo.unidadId = this.unidad[0].id;
            this.preventivo.placa   = this.unidad[0].placa;
            this.preventivo.numero  = this.unidad[0].numeroEconomico;
            this.preventivo.marca   = this.unidad[0].nombreMarca;
            this.preventivo.modelo  = this.unidad[0].modelo;
            this.preventivo.anio    = this.unidad[0].anio;
            this.preventivo.serie   = this.unidad[0].serie;
            this.preventivo.odometro = this.unidad[0].Odometro; 
            this.preventivo.empresa = this.unidad[0].nombreEmpresa;  
            /* */

        },
        async save() {
            if (!this.valid) return;

            try {
                /* const { message } = await (
                    this.createMode
                        ? services.mantounidades().saveMantenimiento(this.preventivo)
                        : services.mantounidades().updateMantenimiento(this.preventivo)
                ); */

                const { message } = await (
                    services.mantounidades().saveMantenimiento(this.preventivo)
                );
                this.showSuccess(message);
                this.exitWindow();
            } catch (error) {
                this.showError({ message: "Error al guardar el correctivo.", error });
            }
        },
        exitWindow() {
            this.$router.push("/mantenimiento/preventivos");
        },
    },
    async mounted() {
        this.estatus    = await services.mantounidades().getEstatus({tipo:'preventivo'});
        await this.infoUnidad();
    },
};
</script>
