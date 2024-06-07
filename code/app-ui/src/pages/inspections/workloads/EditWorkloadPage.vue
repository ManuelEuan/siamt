<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <v-card flat>
                    <v-toolbar>
                        <v-toolbar-title>{{ createMode ? "Nueva" : "Editar" }} Carga de trabajo</v-toolbar-title>
                    </v-toolbar>
                </v-card>
            </v-col>
            {{ tab }}
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
                        <v-badge class="badge_change" :color="receivedTabTurnsData.valid ? 'success' : 'warning'">
                            <v-icon> mdi-card-account-details </v-icon>
                        </v-badge>
                    </v-tab>
                    <v-tab href="#inspectorestab">
                        Inspectores
                        <v-badge class="badge_change" :color="receivedTabInspectorsData.valid ? 'success' : 'warning'">
                            <v-icon> mdi-clipboard-text </v-icon>
                        </v-badge>
                    </v-tab>
                    <v-tab href="#trabajostab">
                        Trabajos
                        <v-badge class="badge_change" :color="receivedTabWorksData.valid ? 'success' : 'warning'">
                            <v-icon> mdi-clipboard-text </v-icon>
                        </v-badge>
                    </v-tab>
                    <v-tab href="#programadatab">
                        Programadas
                        <v-badge class="badge_change" :color="receivedTabWorksData.valid ? 'success' : 'warning'">
                            <v-icon> mdi-clipboard-text </v-icon>
                        </v-badge>
                    </v-tab>
                </v-tabs>
                <v-tabs-items v-model="tab">
                    <v-card flat>
                        <v-tab-item :key="1" value="generaltab" class="py-1">
                            <v-card-text>
                                <!-- :dinamycRemoveFields="dinamycRemoveFields"
                                :dinamycHiddenFields="dinamycHiddenFields" 
                                :dinamycDisabledFields="dinamycDisabledFields" -->
                                <generic-form-validation :formFields="formFieldsGeneralTab"
                                    :formFieldsWithValues="sendFieldsGeneralTab"
                                    :dinamycDisabledFields="dinamycDisabledGeneralTab"
                                    @form-valid="handleValidationGeneralTab" @new-value="handleValuesGeneralTab">
                                </generic-form-validation>
                            </v-card-text>
                        </v-tab-item>
                        <v-tab-item :key="2" value="turnostab" class="py-1">
                            <v-card-text>
                                <generic-form-validation :formFields="formFieldsTurnsTab"
                                    :formFieldsWithValues="sendFieldsTurnsTab" @form-valid="handleValidationTurnsTab"
                                    @new-value="handleValuesTurnsTab">
                                </generic-form-validation>
                                <v-row>
                                    <v-col cols="12" md="6">
                                        <v-btn depressed color="primary">
                                            Agregar turno a carga de trabajo
                                        </v-btn>
                                    </v-col>
                                    <v-col cols="12" md="6">
                                        <!-- TABLA DE TELÉFONOS -->
                                        <v-data-table :headers="headers_tbl_carga_trabajo_turno" :items="tbl_carga_trabajo_turno">
                                           
                                            <template v-slot:item.actions="{ item }">
                                                <div v-if="peopleModulePermissions.includes('edtp')" style="min-width: 85px;">
                                                    <v-tooltip bottom >
                                                        <template v-slot:activator="{ on, attrs }">
                                                            <v-btn v-bind="attrs" v-on="on" icon small
                                                                @click="actionsHandlerOfTable(item, 'deletePhone')">
                                                                <v-icon small color="red">mdi-close</v-icon>
                                                            </v-btn>
                                                        </template>
                                                        <span>Eliminar</span>
                                                    </v-tooltip>
                                                </div>
                                                <div v-else>
                                                    Sin permisos
                                                </div>
                                            </template>
                                        </v-data-table>
                                    </v-col>
                                </v-row>
                            
                            </v-card-text>
                        </v-tab-item>
                        <v-tab-item :key="3" value="inspectorestab" class="py-1">
                            <v-card-text>
                                <generic-form-validation :formFields="formFieldsInspectorsTab"
                                    :formFieldsWithValues="sendFieldsInspectorsTab"
                                    @form-valid="handleValidationInspectorsTab" @new-value="handleValuesInspectorsTab">
                                </generic-form-validation> 
                            </v-card-text>
                        </v-tab-item>
                        <v-tab-item :key="4" value="trabajostab" class="py-1">
                            <v-card-text>
                                <generic-form-validation :formFields="formFieldsWorksTab"
                                    :formFieldsWithValues="sendFieldsWorksTab" @form-valid="handleValidationWorksTab"
                                    @new-value="handleValuesWorksTab">
                                </generic-form-validation> </v-card-text>
                        </v-tab-item>
                        <v-tab-item :key="4" value="programadatab" class="py-1">
                            <v-card-text>
                                <!-- <generic-form-validation :formFields="formFieldsWorksTab"
                                    :formFieldsWithValues="sendFieldsWorksTab" @form-valid="handleValidationWorksTab"
                                    @new-value="handleValuesWorksTab">
                                </generic-form-validation> -->
                             </v-card-text>
                        </v-tab-item>
                        
                        <v-card-actions>
                            <v-spacer />
                            <v-btn color="error" text @click="exitWindow()"> Cerrar </v-btn>
                            <v-btn color="primary" text @click="saveWorkload()" :disabled="!receivedTabGeneralData.valid ||
                                !receivedTabTurnsData.valid ||
                                !receivedTabInspectorsData.valid ||
                                !receivedTabWorksData.valid"> Guardar </v-btn>
                        </v-card-actions>
                    </v-card>
                </v-tabs-items>
            </v-col>
        </v-row>
    </v-container>
</template>



<script>
// import rules from "@/core/rules.forms";
import services from "@/services";
import GenericFormValidation from "@/components/common/GenericFormValidation.vue";

import { mapActions } from "vuex";

export default {
    components: {
        GenericFormValidation,
    },
    data() {
        return {
            headers_tbl_carga_trabajo_turno:  [
                // { text: 'ID', value: 'id' },
                { text: 'Nombree', value: 'name' },
                { text: 'Coordinadoor', value: 'coordinator' },
                { text: 'Acciones', value: 'actions' }
            ],
            tbl_carga_trabajo_turno: [
                {
                    name: 'Nombre 1',
                    coordinator: 'Coor 1',
                },
                {
                    name: 'Nombre 1',
                    coordinator: 'Coor 2',
                }


            ],
            // validGeneralTab: false,
            formFieldsGeneralTab: {},
            sendFieldsGeneralTab: {},
            dinamycDisabledGeneralTab: ['dfecha_final'],
            // validTurnsTab: false,
            formFieldsTurnsTab: {},
            sendFieldsTurnsTab: {},
            // validInspectorsTab: false,
            formFieldsInspectorsTab: {},
            sendFieldsInspectorsTab: {},
            // validWorksTab: false,
            formFieldsWorksTab: {},
            sendFieldsWorksTab: {},
            // HANDLERS
            receivedTabGeneralData: {
                newOrEdit: false,
                data: {},
                valid: false,
            },
            receivedTabTurnsData: {
                newOrEdit: false,
                data: {},
                valid: false,
            },
            receivedTabInspectorsData: {
                newOrEdit: false,
                data: {},
                valid: false,
            },
            receivedTabWorksData: {
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

            iidcarga_trabajo: 0,
            sendFormGeneralTab: {
                txtnombre: "",
                iidzona: 0,
                dfecha_inicial: '',
                dfecha_final: '',
                txtdescripcion: "",
                activo: null,
                fecha_creacion: null,
                fecha_modificacion: null
            },
            sendFormTurnTab: {
                iidturno: 0,
                iidinspector: 0,
                activo: null,
                fecha_creacion: null,
                fecha_modificacion: null
            },
            sendFormInspectorTab: {
                iidturno: 0,
                iidinspector: 0,
                activo: null,
                fecha_creacion: null,
                fecha_modificacion: null
            },
            sendFormWorkTab: {
                iidcarga_trabajo_tipo: 0,
                txtdescripcion: '',
                txtlatitud: '',
                txtlongitud: '',
                dtfecha_hora_inicio: "",
                dtfecha_hora_fin: "",
                activo: null,
                fecha_creacion: null,
                fecha_modificacion: null
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
        handleValidationGeneralTab(valid) {
            console.log('Retorno de generic-form-validation valid-form ')
            this.receivedTabGeneralData.valid = valid
            console.log(valid)
        },
        handleValuesGeneralTab(key, value) {
            console.log('Retorno de generic-form-validation key-values ')
            console.log(key, value)
            if(key == 'dfecha_inicial'){
                if(value){
                    this.dinamycDisabledGeneralTab = this.dinamycDisabledGeneralTab.filter(item => item !== 'dfecha_final');
                    this.formFieldsGeneralTab.dfecha_final.min = value
                }else{
                    this.dinamycDisabledGeneralTab = ['dfecha_final']
                }
            }
            this.sendFormGeneralTab[key] = value
            console.log('this.sendFormGeneralTab')
            console.log(this.sendFormGeneralTab)
            // this.sendFormGeneralTab = 
        },

        handleValidationTurnsTab(valid) {
            console.log('Retorno de generic-turn-validation valid-form ')
            this.receivedTabTurnsData.valid = valid
            console.log(valid)
        },
        handleValuesTurnsTab(key, value) {
            console.log('Retorno de generic-turn-validation key-values ')
            console.log(key, value)
        },

        handleValidationInspectorsTab(valid) {
            console.log('Retorno de generic-inspector-validation valid-form ')
            this.receivedTabInspectorsData.valid = valid
            console.log(valid)
        },
        handleValuesInspectorsTab(key, value) {
            console.log('Retorno de generic-inspector-validation key-values ')
            console.log(key, value)
        },

        handleValidationWorksTab(valid) {
            console.log('Retorno de generic-work-validation valid-form ')
            this.receivedTabWorksData.valid = valid
            console.log(valid)
        },
        handleValuesWorksTab(key, value) {
            console.log('Retorno de generic-work-validation key-values ')
            console.log(key, value)
        },
        // APLICACIÓN DE REGLAS EXTRA EN FORMULARIO GENÉRICO (LÓGICA DE FORMULARIO)
        applyRulesForDinamycForm() {
            // TAB GENERAL---------------
            // AL CAMBIAR FECHA DE INICIO LA FECHA FINAL SE REESTABLECE Y SE BLOQUEAN LOS CAMPOS ANTERIORES A LA DE INICIO


            // if (this.form.typeRegister === 'Proceso') {
            //     this.dinamycRemoveFields = ['iidproceso', 'iidetapa', 'txtcolor', 'txtpermiso', 'binicial', 'bfinal', 'bcancelacion', 'brequiere_motivo', 'iidsubetapa', 'iidsubetapa_siguiente']
            //     this.dinamycHiddenFields = []
            //     this.dinamycDisabledFields = []
            // } else if (this.form.typeRegister === 'Etapa') {
            //     this.dinamycRemoveFields = ['iidmodulo', 'iidetapa', 'iidsubetapa', 'iidsubetapa_siguiente']
            //     this.dinamycHiddenFields = []
            //     this.dinamycDisabledFields = []
            // } else if (this.form.typeRegister === 'Subetapa') {
            //     this.dinamycRemoveFields = ['iidproceso', 'iidmodulo', 'iidsubetapa', 'iidsubetapa_siguiente']
            //     this.dinamycHiddenFields = []
            //     this.dinamycDisabledFields = []
            // } else if (this.form.typeRegister === 'Flujo') {
            //     this.dinamycRemoveFields = ['iidetapa', 'iidmodulo', 'iidproceso', 'txtnombre', 'txtdescripcion', 'txtsigla', 'txtcolor', 'txtpermiso', 'binicial', 'bfinal', 'bcancelacion', 'brequiere_motivo']
            //     this.dinamycDisabledFields = []
            //     this.dinamycHiddenFields = []
            //     // this.sendFieldsWithValues.iidsubetapa_siguiente
            //     console.log('this.sendFieldsWithValues desde applyrules')
            //     console.log(this.sendFieldsWithValues)
            //     if (this.sendFieldsWithValues.iidsubetapa_siguiente) {
            //         this.getAllNextSubStagesEnabled(this.sendFieldsWithValues.iidsubetapa, this.sendFieldsWithValues.iidsubetapa_siguiente)

            //     }

            // }
            // else {
            //     this.showError({ 'message': 'Tipo de registro no configurado' })
            // }
            // if (!this.newRegister) {
            //     this.dinamycHiddenFields = ['typeRegister']
            //     this.dinamycDisabledFields = ['txtsigla', 'dtfecha_creacion', 'dtfecha_modificacion']
            // } else {
            //     this.dinamycHiddenFields = ['bactivo', 'dtfecha_creacion', 'dtfecha_modificacion']
            // }
        },

        async loadSelectableData() {
            try {
                const { id } = this.$route.params;
                console.log(id);
                // this.shifts = await services.inspections().getAllShiftsInspector();

            } catch (error) {
                const message = 'Error al cargar opciones para nuevo inspector.';
                this.showError({ message, error });
            }
        },
        async setEditMode() {
            try {
                const { id } = this.$route.params;
                console.log(id);
                // this.inspector = { ...await services.inspections().getInspectorInfo({ id }) };
            } catch (error) {
                const message = 'Error al cargar información de inspector.';
                this.showError({ message, error });
            }
        },
        async saveWorkLoad() {
            console.log('this.createMode ' + this.createMode);
            console.log(this.form);
            try {
                const { message } = await (
                    this.createMode ?
                        services.inspections().createInspector(this.inspector) :
                        services.inspections().updateInspector(this.inspector)
                );
                this.showSuccess(message);
                // this.exitWindow();
            } catch (error) {
                const message = 'Error al guardar carga de trabajo.';
                this.showError({ message, error });
            }
        },
        exitWindow() {
            this.$router.push("/inspections/inspectors");
        },
        async inputsFormWorkloads() {
            try {
                let formularios = await services.inspections().getStructureFormWorkloads();
                console.log('-----formulario workloadss')
                console.log(formularios.inputsInspectorsForm)
                this.formFieldsGeneralTab = formularios.inputsGeneralForm
                this.formFieldsTurnsTab = formularios.inputsTurnsForm
                this.formFieldsInspectorsTab = formularios.inputsInspectorsForm
                this.formFieldsWorksTab = formularios.inputsWorksForm

                
                // this.formFields = formulario
            } catch (error) {
                const message = 'Error al precuperar los formulario ';
                this.showError({ message, error });
            }
        },
    },
    watch: {
    },

    async mounted() {
        await this.inputsFormWorkloads()
        // await this.applyFilters()
        let user = await services.app().getUserConfig();
        let getActivePermissionsFromUser = await services.admin().getActivePermissionsFromUser(user[0].id);
        this.peopleModulePermissions = getActivePermissionsFromUser.map(permission => permission.siglas);
        console.log('workloads permisos')
        if (!this.createMode) {
            await this.setEditMode();
        }
    },
};
</script>
