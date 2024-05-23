<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <v-card flat>
                    <v-toolbar>
                        <v-toolbar-title>{{ createMode ? "Nuevo" : "Editar" }} Cargar de trabajo</v-toolbar-title>
                    </v-toolbar>
                </v-card>
            </v-col>
            <v-col cols="12" class="pa-0 mt-2">
                <v-tabs v-model="tab" centered icons-and-text>
                    <v-tabs-slider color="primary" />
                    <v-tab href="#generaltab">
                        Datos Generales
                        <v-badge class="badge_change" :color="receivedTabGeneralData.valid ? 'success' : 'warning'">
                            <v-icon> mdi-clipboard-text </v-icon>
                        </v-badge>
                    </v-tab>

                    <v-tab href="#turnostab">
                        Turnos
                        <v-badge class="badge_change" :color="receivedTabTurnData.valid ? 'success' : 'warning'">
                            <v-icon> mdi-card-account-details </v-icon>
                        </v-badge>
                    </v-tab>
                    <v-tab href="#trabajostab">
                        Trabajos
                        <v-badge class="badge_change"
                            :color="receivedTabWorkData.valid ? 'success' : 'warning'">
                            <v-icon> mdi-clipboard-text </v-icon>
                        </v-badge>
                    </v-tab>
                </v-tabs>
                <v-tabs-items v-model="tab">
                    <v-card flat>
                        <v-tab-item :key="1" value="generaltab" class="py-1">
                            <v-card-text>

                                <v-form v-model="valid">
                                    <v-row>
                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="workload.txtnombre" label="Nombre*"
                                                :rules="[rules.required]" hide-details="auto" clearable dense
                                                outlined />
                                        </v-col>

                                        <v-col cols="12" md="6">
                                            <v-select v-model="workload.iidzona" label="Zona*" :rules="[rules.required]"
                                                :items="zones" item-text="txtnombre" item-value="iidzona"
                                                hide-details="auto" small-chips clearable dense outlined />
                                        </v-col>

                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="workload.dfecha_inicio" label="Fecha inicial"
                                                :min="minDate" :max="workload.dfecha_fin || '2999-12-12'" type="date"
                                                small-chips clearable dense outlined>
                                            </v-text-field>
                                        </v-col>

                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="workload.dfecha_fin" label="Fecha final"
                                                :disabled="!workload.dfecha_inicio || workload.dfecha_inicio == '0000-00-00 00:00:00'"
                                                :min="workload.dfecha_inicio" type="date" :mask="'####/##/##'"
                                                small-chips clearable dense outlined>
                                            </v-text-field>
                                        </v-col>

                                        <v-col cols="12">
                                            <v-textarea v-model="workload.txtdescripcion" label="Descripcion"
                                                hide-details="auto" clearable dense outlined />
                                        </v-col>

                                    </v-row>
                                </v-form>
                            </v-card-text>
                        </v-tab-item>
                        <v-tab-item :key="2" value="turnostab" class="py-1">
                            <v-card-text>
                                <v-form v-model="valid">
                                    <v-row>
                                        <v-col cols="12" md="6">
                                            <v-select v-model="workload.iidturno" label="Turno*"
                                                :rules="[rules.required]" :items="shifts" item-text="txtnombre"
                                                item-value="iidturno" hide-details="auto" small-chips clearable dense
                                                outlined />
                                        </v-col>

                                        <v-col cols="12" md="6">
                                            <v-select v-model="workload.iidturno" label="Coordinador*"
                                                :rules="[rules.required]" :items="shifts" item-text="txtnombre"
                                                item-value="iidturno" hide-details="auto" small-chips clearable dense
                                                outlined />
                                        </v-col>

                                        <v-col cols="12" md="12">
                                            <v-btn depressed color="primary">
                                                Agregar turno a carga de trabajo
                                            </v-btn>
                                        </v-col>
                                        <v-col cols="12" md="12">

                                            <v-simple-table>
                                                <template v-slot:default>
                                                    <thead>
                                                        <tr>
                                                            <th class="text-left">
                                                                Turno
                                                            </th>
                                                            <th class="text-left">
                                                                Coordinador
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
                                    </v-row>
                                </v-form>
                            </v-card-text>

                        </v-tab-item>
                        <v-tab-item :key="3" value="ispectorestab" class="py-1">
                            <v-card-text>
                                <v-form v-model="valid">
                                    <v-row>
                                        <v-col cols="12" md="6">
                                            <v-select v-model="workload.iidturno" label="Turno*"
                                                :rules="[rules.required]" :items="shifts" item-text="txtnombre"
                                                item-value="iidturno" hide-details="auto" small-chips clearable dense
                                                outlined />
                                        </v-col>

                                        <v-col cols="12" md="6">
                                            <v-select v-model="workload.iidturno" label="Inspector*"
                                                :rules="[rules.required]" :items="shifts" item-text="txtnombre"
                                                item-value="iidturno" hide-details="auto" small-chips clearable dense
                                                outlined />
                                        </v-col>

                                        <v-col cols="12" md="12">
                                            <v-btn depressed color="primary">
                                                Agregar inspector a carga de trabajo
                                            </v-btn>
                                        </v-col>
                                        <v-col cols="12" md="12">

                                            <v-simple-table>
                                                <template v-slot:default>
                                                    <thead>
                                                        <tr>
                                                            <th class="text-left">
                                                                Turno
                                                            </th>
                                                            <th class="text-left">
                                                                Coordinador
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
                                    </v-row>
                                </v-form>
                            </v-card-text>
                        </v-tab-item>
                        <v-tab-item :key="4" value="trabajostab" class="py-1">
                            <v-card-text>
                                <v-form v-model="valid">
                                    <v-row>
                                        <v-col cols="12" md="6">
                                            <v-select v-model="workload.iidturno" label="Tipo*"
                                                :rules="[rules.required]" :items="shifts" item-text="txtnombre"
                                                item-value="iidturno" hide-details="auto" small-chips clearable dense
                                                outlined />
                                        </v-col>
                                        <v-col cols="12">
                                            <v-textarea v-model="workload.txtdescripcion" label="Descripcion"
                                                hide-details="auto" clearable dense outlined />
                                        </v-col>

                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="workload.txtnombre" label="Latitud*"
                                                :rules="[rules.required]" hide-details="auto" clearable dense
                                                outlined />
                                        </v-col>

                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="workload.txtnombre" label="Longitud*"
                                                :rules="[rules.required]" hide-details="auto" clearable dense
                                                outlined />
                                        </v-col>

                                        <v-col cols="12" md="6">
                                            <v-text-field type="time" v-model="workload.thora_inicio"
                                                label="Hora de inicio*" :rules="[rules.required]" hide-details="auto"
                                                clearable dense outlined />
                                        </v-col>

                                        <v-col cols="12" md="6">
                                            <v-text-field type="time" v-model="workload.thora_fin"
                                                label="Hora de finalización*" :rules="[rules.required]"
                                                hide-details="auto" clearable dense outlined />
                                        </v-col>

                                        <v-col cols="12" md="6">
                                            <v-select v-model="workload.iidturno" label="Turno*"
                                                :rules="[rules.required]" :items="shifts" item-text="txtnombre"
                                                item-value="iidturno" hide-details="auto" small-chips clearable dense
                                                outlined />
                                        </v-col>

                                        <v-col cols="12" md="12">
                                            <v-btn depressed color="primary">
                                                Agregar carga de trabajo detalle
                                            </v-btn>
                                        </v-col>

                                        <v-col cols="12" md="12">

                                            <v-simple-table>
                                                <template v-slot:default>
                                                    <thead>
                                                        <tr>
                                                            <th class="text-left">
                                                                Turno
                                                            </th>
                                                            <th class="text-left">
                                                                Coordinador
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

                                        <v-col cols="12" md="12">
                                            <v-btn depressed color="primary">
                                                Agregar carga de trabajo detalle inspector
                                            </v-btn>
                                        </v-col>
                                        <v-col cols="12" md="6">
                                            <v-select v-model="workload.iidturno" label="Carga de trabajo detalle*"
                                                :rules="[rules.required]" :items="shifts" item-text="txtnombre"
                                                item-value="iidturno" hide-details="auto" small-chips clearable dense
                                                outlined />
                                        </v-col>


                                        <v-col cols="12" md="12">

                                            <v-simple-table>
                                                <template v-slot:default>
                                                    <thead>
                                                        <tr>
                                                            <th class="text-left">
                                                                Turno
                                                            </th>
                                                            <th class="text-left">
                                                                Coordinador
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


                                    </v-row>
                                </v-form>
                            </v-card-text>
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
            // HANDLERS
            receivedTabGeneralData: {
                newOrEdit: false,
                data: {},
                valid: false,
            },
            receivedTabTurnData: {
                newOrEdit: false,
                data: {},
                valid: false,
            },
            receivedTabWorkData: {
                newOrEdit: false,
                data: {},
                valid: false,
            },
            click: {
                user: false,
                permission: false,
            },
            valid: false,
            tab: "generaltab",
            permissions: [],
            zones: [],
            shifts: [],
            workload: {
                iidcarga_trabajo: 0,
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
                persona: v => v.length > 0 || "Requerido.",
                categoria: v => v.length > 0 || "Requerido.",
            },
            desserts: [
                {
                    name: 'Nombre 1',
                    coordinator: 'Coor 1',
                },
                {
                    name: 'Nombre 1',
                    coordinator: 'Coor 2',
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
                // this.stages = await services.inspections().getAllStages();
                this.shifts = await services.inspections().getAllShiftsInspector();

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
        async inputsFormWorkloads() {
            try {
                let formulario = await services.inspections().getStructureFormWorkloads();
                console.log('-----formulario workloadss')
                console.log(formulario)
                // this.formFields = formulario
            } catch (error) {
                const message = 'Error al precuperar los formulario ';
                this.showError({ message, error });
            }
        },
    },
    watch: {
        'workload.dfecha_inicio': function () {
            console.log('this.workload.dfecha_inicio')
            console.log(this.workload.dfecha_inicio)
        }
    },

    async mounted() {
        await this.inputsFormWorkloads()
        // await this.applyFilters()
        let user = await services.app().getUserConfig();
        let getActivePermissionsFromUser = await services.admin().getActivePermissionsFromUser(user[0].id);
        this.peopleModulePermissions = getActivePermissionsFromUser.map(permission => permission.siglas);
        console.log('workloads permisos')
    },
};
</script>
