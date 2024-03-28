<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <v-card flat>
                    <v-toolbar>
                        <v-toolbar-title>{{ createMode ? "Nueva" : "Editar" }} Trabajo</v-toolbar-title>
                    </v-toolbar>
                </v-card>
            </v-col>
            <v-col cols="12" class="pa-0 mt-2">
                <v-tabs v-model="tab" centered icons-and-text>
                    <v-tabs-slider color="primary" />
                    <v-tab href="#generaltab">
                        Datos Generales
                        <v-icon> mdi-clipboard-text </v-icon>
                    </v-tab>
                    <!-- <v-tab href="#turnostab">
                        Turnos
                        <v-icon> mdi-card-account-details </v-icon>
                    </v-tab>
                    <v-tab href="#ispectorestab">
                        Ispectores
                        <v-icon> mdi-card-account-details </v-icon>
                    </v-tab>
                    <v-tab href="#trabajostab">
                        Trabajos
                        <v-icon> mdi-card-account-details </v-icon>
                    </v-tab> -->
                </v-tabs>
                <v-tabs-items v-model="tab">
                    <v-card flat>
                        <v-tab-item :key="1" value="generaltab" class="py-1">
                            <v-card-text>
                                <v-form v-model="valid">
                                    <v-row>
                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="work.txtnombre" label="Nombre*"
                                                :rules="[rules.required]" hide-details="auto" clearable dense
                                                outlined />
                                        </v-col>

                                        <v-col cols="12" md="6">
                                            <v-select v-model="work.iidzona" label="Zona*" :rules="[rules.required]"
                                                :items="zones" item-text="txtnombre" item-value="iidzona"
                                                hide-details="auto" small-chips clearable dense outlined />
                                        </v-col>

                                        <v-col cols="12" md="4">
                                            <v-select v-model="work.iidturno" label="Turno*" :rules="[rules.required]"
                                                :items="shifts" item-text="txtnombre" item-value="iidturno"
                                                hide-details="auto" small-chips clearable dense outlined />
                                        </v-col>

                                        <v-col cols="12" md="4">
                                            <v-text-field v-model="work.dfecha_inicio" label="Fecha y hora inicial"
                                                :min="getCurrentDateTime()" :max="work.dfecha_fin || '2999-12-12'"
                                                type="datetime-local" small-chips clearable dense outlined>
                                            </v-text-field>
                                        </v-col>

                                        <v-col cols="12" md="4">
                                            <v-text-field v-model="work.dfecha_fin" label="Fecha y hora final"
                                                :disabled="!work.dfecha_inicio" :min="work.dfecha_inicio"
                                                type="datetime-local" small-chips clearable dense outlined>
                                            </v-text-field>
                                        </v-col>

                                        <v-col cols="12" md="12" class="">
                                            <v-btn depressed color="primary">
                                                Agregar turno
                                            </v-btn>
                                        </v-col>

                                        <!-- <template> -->
                                        <v-col cols="12" md="12" class="">

                                            <v-simple-table>
                                                <template v-slot:default>
                                                    <thead>
                                                        <tr>
                                                            <th class="text-left">
                                                                Inspectores
                                                            </th>
                                                            <th class="text-left">
                                                                Turno
                                                            </th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr v-for="item in desserts" :key="item.name">
                                                            <td>{{ item.name }}</td>
                                                            <td>{{ item.coordinator }}</td>
                                                        </tr>
                                                    </tbody>
                                                </template>
                                            </v-simple-table>
                                            <!-- </template> -->
                                        </v-col>

                                        <v-col cols="12">
                                            <v-textarea v-model="work.txtdescripcion" label="Descripcion"
                                                hide-details="auto" clearable dense
                                                outlined />
                                        </v-col>

                                    </v-row>
                                </v-form>
                            </v-card-text>
                        </v-tab-item>
                        <v-tab-item :key="2" value="turnostab" class="py-1">

                        </v-tab-item>
                        <v-tab-item :key="3" value="ispectorestab" class="py-1">

                        </v-tab-item>
                        <v-tab-item :key="4" value="trabajostab" class="py-1">

                        </v-tab-item>
                        <v-card-actions>
                            <v-spacer />
                            <v-btn color="error" text @click="exitWindow()"> Cerrar </v-btn>
                            <v-btn color="primary" text :disabled="!valid" @click="saveInspector()"> Guardar </v-btn>
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
    components: {
    },
    data() {
        return {
            valid: false,
            tab: "generaltab",
            permissions: [],
            zones: [],
            shifts: [],
            workTypes: [],
            work: {
                iidcarga_trabajo_detalle: 0,
                txtnombre: "",
                txtdescripcion: "",
                iidzona: 0,
                dfecha_inicio: '',
                dfecha_fin: '',
                activo: null,
                fecha_creacion: null,
                fecha_modificacion: null
            },
            rules: {
                ...rules,
            },
            desserts: [
                {
                    name: 'Turno 1',
                    coordinator: 'Inspector 1',
                },
                {
                    name: 'Turno 1',
                    coordinator: 'Inspector 2',
                }
              

            ],
        };
    },
    computed: {
        createMode() {
            return !this.$route.params.id;
        },
        minDate() {
            const today = new Date();
            const year = today.getFullYear();
            const month = (today.getMonth() + 1).toString().padStart(2, '0');
            const day = today.getDate().toString().padStart(2, '0');
            return `${year}-${month}-${day}`;
        }
    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),
        async loadSelectableData() {
            try {
                const { id } = this.$route.params;
                console.log(id);
                console.log('idssuhfueihfiejfieojfiej');
                // this.categories = await services.inspections().getAllCategoriesInspector();
                // this.stages = await services.inspections().getAllStagesInspector();
                this.zones = await services.inspections().getAllZonesInspector();
                console.log('this.zones')
                console.log(this.zones)
                this.shifts = await services.inspections().getAllShiftsInspector();
                // getAllSexesPerson
                // getAllCivilStatusPerson

            } catch (error) {
                const message = 'Error al cargar opciones para nuevo inspector.';
                this.showError({ message, error });
            }
        },
        async setEditMode() {
            try {
                const { id } = this.$route.params;
                this.inspector = { ...await services.inspections().getInspectorInfo({ id }) };
                let curp = this.inspector.txtcurp;
                this.persona = { ...await services.inspections().getPersonByCurp({ curp }) };
            } catch (error) {
                const message = 'Error al cargar información de inspector.';
                this.showError({ message, error });
            }
        },
        async saveInspector() {
            if (!this.valid) return;
            // const message = 'Error al guardar inspector.';
            //     this.showError({ message });
            console.log('this.createMode ' + this.createMode);
            console.log(this.inspector);
            try {
                const { message } = await (
                    this.createMode ?
                        services.inspections().createInspector(this.inspector) :
                        services.inspections().updateInspector(this.inspector)
                );
                this.showSuccess(message);
                this.exitWindow();
            } catch (error) {
                const message = 'Error al guardar inspector.';
                this.showError({ message, error });
            }
        },
        exitWindow() {
            this.$router.push("/inspections/inspectors");
        },
        getCurrentDateTime() {
            const now = new Date();
            // Formatear la fecha y hora actual en el formato adecuado para el atributo min
            const year = now.getFullYear();
            const month = (now.getMonth() + 1).toString().padStart(2, '0'); // Asegurar que el mes tenga dos dígitos
            const day = now.getDate().toString().padStart(2, '0'); // Asegurar que el día tenga dos dígitos
            const hours = now.getHours().toString().padStart(2, '0'); // Asegurar que las horas tengan dos dígitos
            const minutes = now.getMinutes().toString().padStart(2, '0'); // Asegurar que los minutos tengan dos dígitos
            return `${year}-${month}-${day}T${hours}:${minutes}`;
        },
        getFechaHoraInicio() {

        }
    },
    watch: {

    },
    async mounted() {
        console.log(this.createMode);
        console.log('createMode');
        await this.loadSelectableData();
        if (!this.createMode) await this.setEditMode();
    },
};
</script>
