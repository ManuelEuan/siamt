<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <v-card flat>
                    <v-toolbar>
                        <v-toolbar-title>{{ dinamycName }}s</v-toolbar-title>
                        <v-spacer></v-spacer>
                        <v-tooltip top>
                            <template v-slot:activator="{ on, attrs }">
                                <v-btn color="primary" class="me-1" @click="actionsHandler({}, 'new')" v-bind="attrs"
                                    v-on="on">
                                    <v-icon> mdi-plus </v-icon>
                                </v-btn>
                            </template>
                            <span>Agregar registro</span>
                        </v-tooltip>
                        <v-divider vertical class="mx-2"></v-divider>
                        <v-badge overlap :content="activeFilters" :value="activeFilters">
                            <v-dialog v-model="dialog" width="600">
                                <template v-slot:activator="{ on, attrs }">
                                    <v-btn fab color="secondary" v-bind="attrs" v-on="on" small>
                                        <v-icon>mdi-filter</v-icon>
                                    </v-btn>
                                </template>

                                <v-card>
                                    <v-card-title
                                        class="text-uppercase primary--text text-h6 py-2">Filtros</v-card-title>
                                    <v-divider></v-divider>
                                    <v-card-text>
                                        <v-row dense>
                                            <v-col cols="12" md="6">
                                                <v-autocomplete v-model="filters.typeRegister" label="Tipo de registro"
                                                    :items="['Proceso', 'Etapa', 'Subetapa', 'Flujo']" dense outlined
                                                    :rules="[rules.required]" />
                                                <!-- <v-text-field v-model="filters.name" label="Nombre" hide-details="auto" clearable
                                        dense outlined></v-text-field> -->
                                            </v-col>
                                            <v-col cols="12" md="6">
                                                <v-text-field v-model="filters.name" label="Nombre" hide-details="auto"
                                                    clearable dense outlined></v-text-field>
                                            </v-col>
                                            <v-col cols="12" md="6">
                                                <v-select v-model="filters.active" label="Activo" :items="items.active"
                                                    item-text="text" item-value="value" hide-details clearable outlined
                                                    dense>
                                                    <template v-slot:prepend-inner>
                                                        <div class="d-flex align-center" style="height: 25px;">
                                                            <v-icon v-if="filters.active === 't'" size="medium"
                                                                color="green">
                                                                mdi-check
                                                            </v-icon>
                                                            <v-icon v-else-if="filters.active === 'f'" size="medium"
                                                                color="red">
                                                                mdi-close
                                                            </v-icon>
                                                            <v-icon v-else size="medium">
                                                                mdi-minus
                                                            </v-icon>
                                                            <v-divider class="mx-1" vertical></v-divider>
                                                        </div>
                                                    </template>
                                                </v-select>
                                            </v-col>

                                        </v-row>
                                    </v-card-text>
                                    <v-divider></v-divider>
                                    <v-card-actions class="justify-end py-2">
                                        <v-spacer></v-spacer>
                                        <v-btn color="warning" text @click="cleanFilters">
                                            Limpiar
                                        </v-btn>
                                        <v-btn color="error" text @click="closeFilters">
                                            Cerrar
                                        </v-btn>
                                        <v-btn :disabled="!filters.typeRegister" color="primary" text
                                            @click="applyFilters">
                                            Aplicar
                                        </v-btn>
                                    </v-card-actions>
                                </v-card>
                            </v-dialog>
                        </v-badge>
                    </v-toolbar>
                    <!-- DIALOG ACTUALIZAR TELÉFONO ACTUAL -->
                    <generic-dialog :dialogVisible="dialogDinamycRegister"
                        :dialogTitle="newRegister ? `Nuevo registro (${dinamycName})` : `Editar registro (${dinamycName})`"
                        :maxWidth="800" :disabledButtonConfirm="validForm"
                        @update:dialogVisible="dialogDinamycRegister = $event" @confirm="saveRegisterDinamyc()">
                        <template v-slot:default>
                            Seleccione las opciones necesarias según su tipo de registros {{ dinamycName }}
                            <generic-form-validation :formFields="formFields"
                                @form-valid="handleGenericFormValidationConfirm"
                                :formFieldsWithValues="sendFieldsWithValues" :dinamycRemoveFields="dinamycRemoveFields"
                                :dinamycHiddenFields="dinamycHiddenFields"
                                :dinamycDisabledFields="dinamycDisabledFields"
                                @new-value="handleGenericFormValidationNewValues"></generic-form-validation>
                        </template>
                    </generic-dialog>
                </v-card>
            </v-col>
            <v-col cols="12" class="pa-0 mt-2">
                <div class="wrapper">
                    <!-- <profiles-datatable-dialogs ref="dialogs" /> -->

                    <v-data-table class="elevation-1" loading-text="Cargando información" :headers="headersDatatable"
                        :items="dinamycRegisterInProcess" :page-count="dinamycRegisterInProcessTotalPages"
                        :server-items-length="dinamycRegisterInProcessTotalItems" :options.sync="options"
                        :loading="loadingTable">
                        <template v-slot:item.bactivo="{ item }">
                            <v-icon v-show="item.bactivo" size="medium" color="green"> mdi-check </v-icon>
                            <v-icon v-show="!item.bactivo" size="medium" color="red">mdi-close</v-icon>
                        </template>

                        <template v-slot:item.acciones="{ item }">

                            <v-tooltip v-if="peopleModulePermissions.includes('vepe') && dinamycName == 'Proceso'"
                                bottom>
                                <template v-slot:activator="{ on, attrs }">
                                    <v-btn v-bind="attrs" v-on="on" icon small @click="actionsHandler(item, 'flow')">
                                        <v-icon small> mdi-sitemap-outline </v-icon>
                                    </v-btn>
                                </template>
                                <span>Ver Flujo General</span>
                            </v-tooltip>
                            <v-tooltip v-if="peopleModulePermissions.includes('vepe') && dinamycName == 'Proceso'"
                                bottom>
                                <template v-slot:activator="{ on, attrs }">
                                    <v-btn v-bind="attrs" v-on="on" icon small @click="actionsHandler(item, 'process')">
                                        <v-icon small> mdi-stack-overflow </v-icon>
                                    </v-btn>
                                </template>
                                <span>Ver Etapas y Subetapas</span>
                            </v-tooltip>

                            <v-tooltip v-if="peopleModulePermissions.includes('vepe')" bottom>
                                <template v-slot:activator="{ on, attrs }">
                                    <v-btn v-bind="attrs" v-on="on" icon small @click="actionsHandler(item, 'view')">
                                        <v-icon small> mdi-eye </v-icon>
                                    </v-btn>
                                </template>
                                <span>Ver registro</span>
                            </v-tooltip>

                            <v-tooltip v-if="peopleModulePermissions.includes('edpe')" bottom>
                                <template v-slot:activator="{ on, attrs }">
                                    <v-btn v-bind="attrs" v-on="on" icon small @click="actionsHandler(item, 'edit')">
                                        <v-icon small> mdi-square-edit-outline </v-icon>
                                    </v-btn>
                                </template>
                                <span>Editar registro ({{ dinamycName }})</span>
                            </v-tooltip>
                        </template>
                    </v-data-table>



                    <!-- DIALOG GENERIC VIEW REGISTER -->
                    <generic-dialog :dialogVisible="dialogViewRegister" dialogTitle="Ver registro"
                        @update:dialogVisible="dialogViewRegister = $event" @confirm="this.dialogViewRegister = false">
                        <template v-slot:default>
                            <!-- Regsitro sele -->
                            <v-list class="pa-0 ma-0">
                                <v-container class="pa-0 ma-0">
                                    <v-row dense>
                                        <template v-for="(value, key, index) in register">
                                            <v-col v-if="headersRegister[key]" class="pa-0 ma-0" cols="6" :key="index">
                                                <v-list-item>
                                                    <v-list-item-content class="py-2">
                                                        <v-list-item-title class="text-h7">
                                                            {{ headersRegister[key] }}
                                                        </v-list-item-title>
                                                        <v-list-item-subtitle class="text-body-1">
                                                            {{ typeof value === 'boolean' ? '' : value }}
                                                            <v-icon v-show="value === true" size="medium" color="green">
                                                                mdi-check </v-icon>
                                                            <v-icon v-show="value === false" size="medium"
                                                                color="red">mdi-close</v-icon>
                                                        </v-list-item-subtitle>
                                                    </v-list-item-content>
                                                </v-list-item>
                                            </v-col>
                                        </template>
                                    </v-row>
                                </v-container>
                            </v-list>
                        </template>
                    </generic-dialog>

                    <!-- DIALOG VIEW PROCESS -->
                    <generic-dialog :dialogVisible="dialogViewProcess" dialogTitle="Visualizar Etapas y Subetapas"
                        @update:dialogVisible="dialogViewProcess = $event" @confirm="dialogViewProcess = false">
                        <template v-slot:default>
                            <v-row dense>
                                <v-treeview v-if="treeProcess.length" :items="treeProcess" activatable color="primary"
                                    transition open-all open-on-click>
                                    <template v-slot:prepend="{ item }">
                                        <v-icon v-if="item.icon" color="primary">{{ item.icon }}</v-icon>
                                    </template>
                                </v-treeview>
                                <div v-else>
                                    {{ processMessage }}
                                </div>
                            </v-row>
                        </template>
                    </generic-dialog>

                    <!-- DIALOG VIEW FLOW -->
                    <generic-dialog :dialogVisible="dialogViewFlow" dialogTitle="Visualizar flujo"
                        @update:dialogVisible="dialogViewFlow = $event" @confirm="dialogViewFlow = false">
                        <template v-slot:default>
                            <v-row dense>
                                <v-treeview v-if="treeFlow" :items="treeFlow" activatable color="primary" transition
                                    open-all open-on-click>
                                    <template v-slot:prepend="{ item }">
                                        <v-icon v-if="item.icon" color="primary">{{ item.icon }}</v-icon>
                                    </template>
                                </v-treeview>
                                <div>
                                    {{ flowMessage }}
                                </div>

                            </v-row>
                        </template>
                    </generic-dialog>
                </div>
            </v-col>
        </v-row>
    </v-container>
</template>


<script>
import services from '@/services';
import rules from "@/core/rules.forms";
import GenericDialog from '@/components/common/GenericDialog.vue';
import GenericFormValidation from "@/components/common/GenericFormValidation.vue";
import { mapActions, mapState } from "vuex";
export default {
    name: 'ProcessPage',
    components: {
        GenericDialog,
        GenericFormValidation,
    },
    data() {
        return {
            treeProcess: [],
            processMessage: '',
            treeFlow: [],
            flowMessage: '',
            dinamycName: 'Proceso',
            newRegister: false,
            dialogDinamycRegister: false,
            dialogDinamycFilters: false,
            dialog: false,
            selectedRegister: null,
            sendFieldsWithValues: {},
            validForm: false,
            process: { iidproceso: 0 },
            flow: { iidproceso: 0 },
            filters: {
                active: '',
                name: '',
                typeRegister: 'Proceso',
            },
            items: {
                active: [{ text: 'activo', value: 't' }, { text: 'inactivo', value: 'f' }],
                roles: [],
            },
            formFields: {},
            dinamycRemoveFields: [],
            dinamycHiddenFields: [],
            dinamycDisabledFields: [],
            form: {
                typeRegister: 'Proceso',
                txtnombre: '',
                binicial: 'f',
                bfinal: 'f',
                bcancelacion: 'f',
                brequiere_motivo: 'f',
                bactivo: 'f',
            },
            formularioDB: {},
            rules: { ...rules },
            peopleModulePermissions: [],
            dialogViewRegister: false,
            dialogViewProcess: false,
            dialogViewFlow: false,
            options: {
                dinamycRegisterInProcess: [],
                page: 1,
                itemsPerPage: 10,
                sortBy: ['txtnombre'],
                sortDesc: [false],
                multiSort: true,
                mustSort: false,
            },
            register: [],
            loadingTable: true,
            headersRegister: {
                iidoftype: "ID",
                txtnombre: "Nombre",
                txtmodulo: "Módulo",
                txtdescripcion: "Descripcion",
                txtsigla: "Siglas",
                bactivo: "Activo",
                dtfecha_creacion: "Fecha creacion",
                dtfecha_modificacion: "Fecha modificación",
            },
            headersDatatable: [
                { text: "Nombre", value: "txtnombre", align: "center", class: "font-weight-bold" },
                { text: "Descripción", value: "txtdescripcion", align: "center", class: "font-weight-bold" },
                { text: "Activo", value: "bactivo", align: "center", class: "font-weight-bold" },
                { text: "Acciones", value: "acciones", align: "center", sortable: false, width: "196px" },
            ],
        }
    },
    computed: {
        ...mapState('app', ['dinamycRegisterInProcessFilters', 'dinamycRegisterInProcess', 'dinamycRegisterInProcessTotalPages', 'dinamycRegisterInProcessTotalItems']),
        activeFilters() {
            return Object.values(this.dinamycRegisterInProcessFilters)
                .filter(v => v && (typeof (v) === 'string' ? v.trim() : v.length))
                .length;
        }
    },

    methods: {
        ...mapActions('app', ['getDinamycRegisterInProcess', 'showSuccess', 'showError']),
        // FILTROS
        async cleanFilters() {
            this.filters = { active: '', name: '', username: '', roles: [] };
        },
        closeFilters() {
            this.filters = { ...this.dinamycRegisterInProcessFilters };
            this.dialog = false;
        },
        // VALIDACIÓN FORMULARIO DINÁMICO
        applyRulesForDinamycForm() {
            if (this.form.typeRegister === 'Proceso') {
                this.dinamycRemoveFields = ['iidproceso', 'iidetapa', 'txtcolor', 'txtpermiso', 'binicial', 'bfinal', 'bcancelacion', 'brequiere_motivo', 'iidsubetapa', 'iidsubetapa_siguiente']
                this.dinamycHiddenFields = []
                this.dinamycDisabledFields = []
            } else if (this.form.typeRegister === 'Etapa') {
                this.dinamycRemoveFields = ['iidmodulo', 'iidetapa', 'iidsubetapa', 'iidsubetapa_siguiente']
                this.dinamycHiddenFields = []
                this.dinamycDisabledFields = []
            } else if (this.form.typeRegister === 'Subetapa') {
                this.dinamycRemoveFields = ['iidproceso', 'iidmodulo', 'iidsubetapa', 'iidsubetapa_siguiente']
                this.dinamycHiddenFields = []
                this.dinamycDisabledFields = []
            } else if (this.form.typeRegister === 'Flujo') {
                this.dinamycRemoveFields = ['iidetapa', 'iidmodulo', 'iidproceso', 'txtnombre', 'txtdescripcion', 'txtsigla', 'txtcolor', 'txtpermiso', 'binicial', 'bfinal', 'bcancelacion', 'brequiere_motivo']
                this.dinamycDisabledFields = []
                this.dinamycHiddenFields = []
                // this.sendFieldsWithValues.iidsubetapa_siguiente
                console.log('this.sendFieldsWithValues desde applyrules')
                console.log(this.sendFieldsWithValues)
                if (this.sendFieldsWithValues.iidsubetapa_siguiente) {
                    this.getAllNextSubStagesEnabled(this.sendFieldsWithValues.iidsubetapa, this.sendFieldsWithValues.iidsubetapa_siguiente)

                }

            }
            else {
                this.showError({ 'message': 'Tipo de registro no configurado' })
            }
            if (!this.newRegister) {
                this.dinamycHiddenFields = ['typeRegister']
                this.dinamycDisabledFields = ['txtsigla', 'dtfecha_creacion', 'dtfecha_modificacion']
            }else{
                this.dinamycHiddenFields = ['bactivo', 'dtfecha_creacion', 'dtfecha_modificacion']
            }
        },
        // HANDLERS
        handleGenericFormValidationConfirm(valid) {
            console.log('Retorno de generic-form-validation valid-form ')
            this.validForm = valid
        },
        async handleGenericFormValidationNewValues(key, value) {
            console.log('Retorno de generic-form-validation key-values ')
            console.log(key, value)
            if (key == 'typeRegister') {
                console.log('Cambio en typeRegister ')
                this.form.typeRegister = value
            }
            if (key == 'iidsubetapa') {
                console.log('Cambio en iidsubetapa ')
                await this.getAllNextSubStagesEnabled(value)
            }

            this.form[key] = value
            this.applyRulesForDinamycForm()
            // this.dinamycDisabledFields.push('iidsubetapa_siguiente')
            console.log('this.form')
            console.log(this.form)
        },
        actionsHandler(register, action) {
            switch (action) {
                case 'new':
                    this.newRegister = true
                    this.dialogDinamycRegister = true
                    this.sendFieldsWithValues = {}
                    this.formFields = this.dataFirstForm()
                    console.log('action new')
                    console.log(this.formFields)
                    this.applyRulesForDinamycForm()
                    this.form.iidoftype = 0
                    break;
                case 'edit':
                    this.newRegister = false
                    this.dialogDinamycRegister = true
                    console.log('action edit')
                    console.log(register)
                    // this.formFields = this.dataFirstForm()
                    this.sendFieldsWithValues = register
                    this.form = register
                    // this.sendFieldsWithValues.allForm = this.formFields
                    // this.sendFieldsWithValues.typeRegister="Proceso"
                    this.sendFieldsWithValues.typeRegister = this.filters.typeRegister
                    this.form.typeRegister = this.filters.typeRegister
                    this.applyRulesForDinamycForm()

                    console.log(this.sendFieldsWithValues)
                    break;
                case 'view':
                    this.dialogViewRegister = true;
                    this.register = register
                    console.log('view register')
                    console.log(register)
                    break;
                case 'process':
                    this.dialogViewProcess = true;
                    this.getProcessWithStagesAndSubstages(register.iidoftype)
                    // this.process.iidproceso = register.iidoftype
                    break;
                case 'flow':
                    this.dialogViewFlow = true;
                    this.getFlowByProcess(register.iidoftype)
                    // this.flow.iidproceso = register.iidoftype
                    break;
                default: this.$refs.dialogs.show[action] = true;
            }
        },
        async getFlowByProcess(iidproceso) {
            try {
                const info = await services.inspections().getFlowByProcess({ iidproceso });
                this.treeFlow = info.info2;
                this.flowMessage = info.message;
            } catch (error) {
                this.showError({ message: 'Error al recuperar el flujo', error });
            }
        },
        async getProcessWithStagesAndSubstages(iidproceso) {
            try {
                const info = await services.inspections().getProcessWithStagesAndSubstages({ iidproceso });
                this.treeProcess = this.convertToTreeStructure(info.info);
                this.processMessage = info.message;
                this.showSuccess(this.processMessage);
            } catch (error) {
                this.showError({ message: 'Error al recuperar los módulos', error });
            }
        },
        convertToTreeStructure(etapas) {
            return etapas.map(etapa => ({
                id: etapa.iidetapa,
                name: `Etapa: ${etapa.nombre_etapa}`,
                icon: 'mdi-check-circle',
                children: (etapa.subStages || []).map(subEtapa => ({
                    id: `${etapa.iidetapa}.${subEtapa.iidsubetapa}`,
                    name: `SubEtapa: ${subEtapa.txtnombre}`,
                    icon: 'mdi-check-circle'
                }))
            }));
        },
        async saveRegisterDinamyc() {
            try {
                const saveRegister = this.form.iidoftype ?
                    await services.inspections().updateRegisterInProcess(this.form) :
                    await services.inspections().newRegisterInProcess(this.form);

                this.showSuccess(saveRegister.message);
                this.formFields.typeRegister.model = this.form.typeRegister;
                this.applyRulesForDinamycForm();
                this.loadDinamycRegisterInProcessTable();
            } catch (error) {
                this.showError({ message: 'Error al guardar el registro', error });
            }
        },
        async applyFilters() {
            try {
                this.dinamycName = this.filters.typeRegister;
                this.formFields.typeRegister.model = this.filters.typeRegister;
                await this.getDinamycRegisterInProcess({ filters: this.filters });

                this.headersDatatable = this.filters.typeRegister === 'Flujo' ?
                    [
                        { text: "Etapa actual", value: "txtnombre", align: "center", class: "font-weight-bold" },
                        { text: "Etapa siguiente", value: "txtnombre_siguiente", align: "center", class: "font-weight-bold" },
                        { text: "Activo", value: "bactivo", align: "center", class: "font-weight-bold" },
                        { text: "Acciones", value: "acciones", align: "center", sortable: false, width: "196px" }
                    ] :
                    [
                        { text: "Nombre", value: "txtnombre", align: "center", class: "font-weight-bold" },
                        { text: "Descripción", value: "txtdescripcion", align: "center", class: "font-weight-bold" },
                        { text: "Activo", value: "bactivo", align: "center", class: "font-weight-bold" },
                        { text: "Acciones", value: "acciones", align: "center", sortable: false, width: "196px" }
                    ];

                this.dialog = false;
            } catch (error) {
                this.showError({ message: 'Error al aplicar filtros', error });
            }
        },
        async getAllNextSubStagesEnabled(value, valueNext = 0) {
            try {
                const info = await services.inspections().getAllNextSubStagesEnabled({ 'iidsubetapa': value });
                this.nextSubstagesEnabled = info.info;
                this.formFields.iidsubetapa_siguiente.array.info = info.info;
                if (valueNext) this.formFields.iidsubetapa_siguiente.model = valueNext;
                this.showSuccess(info.message);
            } catch (error) {
                this.showError({ message: 'Error al recuperar los módulos', error });
            }
        },
        async dataFirstForm() {
            try {
                this.formFields = await services.inspections().getStructureFirstForm();
            } catch (error) {
                this.showError({ message: 'Error al recuperar los formularios', error });
            }
        },
        async loadDinamycRegisterInProcessTable() {
            try {
                const { page, itemsPerPage, sortBy, sortDesc } = this.options;
                const data = { page, itemsPerPage, sortBy, sortDesc };
                await this.getDinamycRegisterInProcess({ data });
                this.loadingTable = false;
            } catch (error) {
                this.showError({ message: 'Error al cargar la tabla de registros', error });
            }
        },
        // Otros métodos...
    },
    watch: {
        options: {
            handler() { this.loadDinamycRegisterInProcessTable(); },
            deep: true,
        },
    },
    async mounted() {
        await this.dataFirstForm();
        await this.applyFilters();
        // this.loadUserPermissions();
        let user = await services.app().getUserConfig();
        let getActivePermissionsFromUser = await services.admin().getActivePermissionsFromUser(user[0].id);
        this.peopleModulePermissions = getActivePermissionsFromUser.map(permission => permission.siglas);
        console.log('procesos permisos')
    },
}
</script>
<style lang="scss" scoped></style>
