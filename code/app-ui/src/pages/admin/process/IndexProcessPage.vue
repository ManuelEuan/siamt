<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <v-card flat>
                    <v-toolbar>
                        <v-toolbar-title>{{ typeRegister }}s</v-toolbar-title>
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
                        :dialogTitle="newRegister ? `Nuevo registro (${typeRegister})` : `Editar registro (${typeRegister})`"
                        :maxWidth="800" :disabledButtonConfirm="validForm"
                        @update:dialogVisible="dialogDinamycRegister = $event" @confirm="saveRegisterDinamyc()">
                        <template v-slot:default>
                            Seleccione las opciones necesarias según su tipo de registros -- {{typeRegister}}
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

                            <v-tooltip v-if="peopleModulePermissions.includes('vepe') && typeRegister == 'Proceso'" bottom>
                                <template v-slot:activator="{ on, attrs }">
                                    <v-btn v-bind="attrs" v-on="on" icon small @click="actionsHandler(item, 'flow')">
                                        <v-icon small> mdi-sitemap-outline </v-icon>
                                    </v-btn>
                                </template>
                                <span>Ver Etapas y Subetapas</span>
                            </v-tooltip>
                            <v-tooltip v-if="peopleModulePermissions.includes('vepe') && typeRegister == 'Proceso'" bottom>
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
                                <span>Editar registro ({{ typeRegister }})</span>
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
                                <v-treeview v-if="treeProcess.length" :items="treeProcess" activatable color="primary" transition open-all
                                    open-on-click>
                                    <template v-slot:prepend="{ item }">
                                        <v-icon v-if="item.icon" color="primary">{{ item.icon }}</v-icon>
                                    </template>
                                </v-treeview>
                                <div v-else>
                                    {{processMessage}}
                                </div>
                            </v-row>
                        </template>
                    </generic-dialog>

                    <!-- DIALOG VIEW FLOW -->
                    <generic-dialog :dialogVisible="dialogViewFlow" dialogTitle="Visualizar flujo"
                        @update:dialogVisible="dialogViewFlow = $event" @confirm="dialogViewFlow = false">
                        <template v-slot:default>
                            <v-row dense>
                                <v-treeview v-if="treeFlow" :items="treeFlow" activatable color="primary" transition open-all
                                    open-on-click>
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
            typeRegister: 'Proceso',
            newRegister: false,
            dialogDinamycRegister: false,
            dialogDinamycFilters: false,
            dialog: false,
            selectedRegister: null,
            sendFieldsWithValues: {},
            validForm: false,
            process: {
                iidproceso: 0
            },
            flow: {
                iidproceso: 0
            },
            filters: {
                active: '',
                name: '',
            },
            items: {
                active: [
                    { text: 'activo', value: 't' },
                    { text: 'inactivo', value: 'f' },
                ],
                roles: [],
            },
            typesRegister: [
                {
                    "type": 'Proceso',
                    "name": "Nuevo proceso",
                },
                {
                    "type": 'Etapa',
                    "name": "Nueva etapa",
                },
                {
                    "type": 'Subetapa',
                    "name": "Nueva subetapa",
                },
                {
                    "type": 'Flujo',
                    "name": "Nuevo flujo",
                }
            ],
            formFields: {

            },
            dinamycRemoveFields: [],  // Decide quita el campo,
            dinamycHiddenFields: [], // Decide si estará oculto el campo,
            dinamycDisabledFields: [], // Decide si estará visible el campo pero deshabilitado,
            form: {
                txtnombre: '',
                binicial: 'f',
                bfinal: 'f',
                bcancelacion: 'f',
                brequiere_motivo: 'f',
                bactivo: 'f',
            },
            modules: [],
            stages: [],
            processes: [],
            // REGLAS
            rules: {
                ...rules,
            },
            peopleModulePermissions: [],
            dialogViewRegister: false,
            dialogViewProcess: false,
            dialogViewFlow: false,
            options: {
                dinamycRegisterInProcess: [],
                page: 1,
                itemsPerPage: 10,
                sortBy: ['txtnombre'],//nombre
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
                {
                    text: "Nombre",
                    value: "txtnombre",
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
                    text: "Activo",
                    value: "bactivo",
                    align: "center",
                    class: "font-weight-bold",
                },
                {
                    text: "Acciones",
                    value: "acciones",
                    align: "center",
                    sortable: false,
                    width: "196px",
                },
            ],
        }
    },
    computed: {
        ...mapState('app', ['dinamycRegisterInProcessFilters', 'dinamycRegisterInProcess', 'dinamycRegisterInProcessTotalPages', 'dinamycRegisterInProcessTotalItems']),
        //         computed: {
        //     ...mapState('app', ['dinamycRegisterInProcess', 'dinamycRegisterInProcessTotalPages', 'dinamycRegisterInProcessTotalItems']),
        //   },
        activeFilters() {
            return Object
                .values(this.dinamycRegisterInProcessFilters)
                .filter(v => v && (typeof (v) === 'string' ? v.trim() : v.length))
                .length;
        }
    },
    methods: {
        ...mapActions('app', ['getDinamycRegisterInProcess', 'showSuccess', 'showError']),
        cleanFilters() {
            this.filters = { active: '', name: '', username: '', roles: [] };
        },
        async getFlowByProcess(iidproceso) {
            try {
                let info = await services.inspections().getFlowByProcess({ iidproceso });
                console.log(info.info)
                this.treeFlow = info.info2
                this.flowMessage = info.message
                this.showSuccess(this.flowMessage);
            } catch (error) {
                const message = 'Error al precuperar los módulos ';
                this.showError({ message, error });
            }
        },

        async getProcessWithStagesAndSubstages(iidproceso) {
            try {
                let info = await services.inspections().getProcessWithStagesAndSubstages({ iidproceso });
                // let objectProcess = this.convertToTreeStructure(info.info);
                this.treeProcess = this.convertToTreeStructure(info.info);
                this.processMessage = info.message
                this.showSuccess(this.processMessage);
            } catch (error) {
                const message = 'Error al precuperar los módulos ';
                this.showError({ message, error });
            }
        },
        convertToTreeStructure(etapas) {
            return etapas.map(etapa => {
                return {
                    id: etapa.iidetapa,
                    name: `Etapa: ${etapa.nombre_etapa} -- ${etapa.iidetapa}`,
                    icon: 'mdi-check-circle',
                    children: (etapa.subStages || []).map(subEtapa => {
                        return {
                            id: `${etapa.iidetapa}.${subEtapa.iidsubetapa}`,
                            name: `SubEtapa: ${subEtapa.txtnombre}-- ${etapa.iidetapa}.${subEtapa.iidsubetapa}`,
                            // icon: dinamycIcon
                            icon: 'mdi-check-circle'
                        };
                    })
                };
            });
        },
        async saveRegisterDinamyc() {

            // this.modules =
            try {
                console.log('datos a enviar')
                console.log(this.form)
                if (!this.form.iidoftype) {
                    let saveRegister = await services.inspections().newRegisterInProcess(this.form);
                    console.log('this.saveRegister')
                    console.log(saveRegister)
                    let message = saveRegister.message
                    this.showSuccess(message);
                } else {
                    let saveRegister = await services.inspections().updateRegisterInProcess(this.form);
                    console.log('this.saveRegister')
                    console.log(saveRegister)
                    let message = saveRegister.message
                    this.showSuccess(message);
                }
                this.loadDinamycRegisterInProcessTable()
            } catch (error) {
                const message = 'Error al guardar el registro ';
                this.showError({ message, error });
            }
        },
        async applyFilters() {
            const filters = this.filters;
            this.typeRegister = this.filters.typeRegister
            console.log(filters)
            await this.getDinamycRegisterInProcess({ filters });
            this.dialog = false;
        },
        closeFilters() {
            this.filters = { ...this.dinamycRegisterInProcessFilters };
            this.dialog = false;
        },
        async getAllModules() {
            try {
                this.modules = await services.inspections().getAllModules();
            } catch (error) {
                const message = 'Error al precuperar los módulos ';
                this.showError({ message, error });
            }
        },
        async getAllStages() {
            try {
                this.stages = await services.inspections().getAllStages();
            } catch (error) {
                const message = 'Error al precuperar las etapas ';
                this.showError({ message, error });
            }
        },
        async getAllSubStages() {
            try {
                this.substages = await services.inspections().getAllSubStages();
            } catch (error) {
                const message = 'Error al precuperar las subetapas ';
                this.showError({ message, error });
            }
        },
        async getAllProcess() {
            try {
                this.processes = await services.inspections().getAllProcess();
            } catch (error) {
                const message = 'Error al precuperar los módulos ';
                this.showError({ message, error });
            }
        },

        async getAllNextSubStagesEnabled(value) {
            try {
                console.log('this.form*********')
                console.log(this.form)
                let info = await services.inspections().getAllNextSubStagesEnabled({'iidsubetapa': value});
                console.log('info next substage')
                console.log(info)
                this.dinamycDisabledFields = this.dinamycDisabledFields.filter(item => item !== 'iidsubetapa_siguiente');
                this.nextSubstagesEnabled = info.info
                console.log('ultimo')
                this.formFields.iidsubetapa_siguiente.array.info = info.info
                console.log(this.nextSubstagesEnabled)

                // this.flowMessage = info.message
                // this.showSuccess(this.flowMessage);
                this.showSuccess(info.message);

            } catch (error) {
                const message = 'Error al precuperar los módulos ';
                this.showError({ message, error });
            }
        },

        async dataFirstForm() {
            return {
                typeRegister: {
                    label: 'Seleccione su tipo de registro*',
                    type: 'autocomplete',
                    model: 'selectedRegister',
                    rules: 'required',
                    cols: 12,
                    md: 12,
                    inputClass: 'mx-auto',
                    inputStyle: 'max-width: 50%',
                    array: { type: 'object', info: this.typesRegister, item_text: 'name', item_value: 'type' }
                },
                iidmodulo: {
                    label: 'Seleccione el módulo*',
                    type: 'autocomplete',
                    model: 'iidmodulo',
                    rules: 'required',
                    cols: 12,
                    md: 6,
                    array: { type: 'object', info: this.modules, item_text: 'nombre', item_value: 'id' }
                },
                iidproceso: {
                    label: 'Seleccione el proceso*',
                    type: 'autocomplete',
                    model: 'iidproceso',
                    rules: 'required',
                    cols: 12,
                    md: 6,
                    array: { type: 'object', info: this.processes, item_text: 'txtnombre', item_value: 'iidproceso' }
                },
                iidetapa: {
                    label: 'Seleccione la etapa*',
                    type: 'autocomplete',
                    model: 'iidetapa',
                    rules: 'required',
                    cols: 12,
                    md: 6,
                    array: { type: 'object', info: this.stages, item_text: 'txtetapa_nombre', item_value: 'iidetapa' }
                },
                iidsubetapa: {
                    label: 'Seleccione la subetapa*',
                    type: 'autocomplete',
                    model: 'iidsubetapa',
                    rules: 'required',
                    cols: 12,
                    md: 6,
                    array: { type: 'object', info: this.substages, item_text: 'txtnombre', item_value: 'iidsubetapa' }
                },
                iidsubetapa_siguiente: {
                    label: 'Seleccione la subetapa siguiente*',
                    type: 'autocomplete',
                    model: 'iidsubetapa_siguiente',
                    rules: 'required',
                    cols: 12,
                    md: 6,
                    array: { type: 'object', info: this.nextSubstagesEnabled, item_text: 'txtnombre', item_value: 'iidsubetapa' }
                },
                txtnombre: {
                    label: 'Nombre',
                    type: 'text',
                    model: 'txtnombre',
                    rules: 'required',
                    cols: 12,
                    md: 6
                },
                txtdescripcion: {
                    label: 'Descripción',
                    type: 'text',
                    model: 'txtdescripcion',
                    rules: null,
                    cols: 12,
                    md: 6
                },
                txtsigla: {
                    label: 'Siglas',
                    type: 'text',
                    model: 'txtsigla',
                    rules: 'required|max4chars',
                    cols: 12,
                    md: 6
                },
                txtcolor: {
                    label: 'Color',
                    type: 'color',
                    model: 'txtcolor',
                    rules: null,
                    cols: 12,
                    md: 6
                },
                txtpermiso: {
                    label: 'Permiso',
                    type: 'text',
                    model: 'txtpermiso',
                    rules: null,
                    cols: 12,
                    md: 6
                },
                binicial: {
                    label: 'Inicial',
                    type: 'boolean',
                    model: 'binicial',
                    rules: null,
                    cols: 6,
                    md: 3
                },
                bfinal: {
                    label: 'Final',
                    type: 'boolean',
                    model: 'bfinal',
                    rules: null,
                    cols: 6,
                    md: 3
                },
                bcancelacion: {
                    label: 'Cancelacion',
                    type: 'boolean',
                    model: 'bcancelacion',
                    rules: null,
                    cols: 6,
                    md: 3
                },
                brequiere_motivo: {
                    label: 'Motivo',
                    type: 'boolean',
                    model: 'brequiere_motivo',
                    rules: null,
                    cols: 6,
                    md: 3
                },


                dtfecha_creacion: {
                    label: '´Fecha de creación',
                    type: 'datetime',
                    model: 'dtfecha_creacion',
                    rules: null,
                    cols: 12,
                    md: 4
                },
                dtfecha_modificacion: {
                    label: 'Fecha de modificación',
                    type: 'datetime',
                    model: 'dtfecha_modificacion',
                    rules: null,
                    cols: 12,
                    md: 4
                },
                bactivo: {
                    label: 'Activo',
                    type: 'boolean',
                    model: 'bactivo',
                    rules: null,
                    cols: 6,
                    md: 4
                },
                // txttelefono_mask_phone: { label: 'Teléfono*', type: 'text', model: 'txttelefono_mask_phone', rules: 'required|telefono', cols: 12, md: 6, maskType: 'phone' },
            }
        },

        async loadDinamycRegisterInProcessTable() {

            const { page, itemsPerPage, sortBy, sortDesc } = this.options;
            const data = { page, itemsPerPage, sortBy, sortDesc };
            this.getDinamycRegisterInProcess({ data });
            this.loadingTable = false;
        },
        async actionsHandler(register, action) {
            switch (action) {
                case 'new':
                    this.newRegister = true
                    this.dialogDinamycRegister = true
                    this.formFields = await this.dataFirstForm()
                    this.applyRulesForDinamycForm()
                    this.dinamycRemoveFields = ['iidmodulo', 'iidproceso', 'iidetapa', 'iidsubetapa','iidsubetapa_siguiente','txtnombre', 'txtdescripcion', 'txtsigla', 'txtcolor', 'txtpermiso', 'binicial', 'bfinal', 'bcancelacion', 'brequiere_motivo', 'bactivo', 'dtfecha_creacion', 'dtfecha_modificacion'],  // Decide quita el campo,
                    this.dinamycRemoveFields.push('bactivo', 'dtfecha_creacion', 'dtfecha_modificacion');
                    this.form.iidoftype = 0
                    break;
                case 'edit':
                    console.log('registro seleccionado')
                    console.log(register)
                    this.newRegister = false
                    this.dialogDinamycRegister = true
                    this.formFields = await this.dataFirstForm()
                    this.applyRulesForDinamycForm()
                 
                    register.typeRegister = this.typeRegister
                    this.form.iidoftype = register.iidoftype
                    Object.keys(this.formFields).forEach(key => {
                        if (Object.prototype.hasOwnProperty.call(register, key)) {
                            console.log(`La clave ${key} está presente en el objeto registers. --- valor: ${register[key]}`);
                            this.formFields[key].model = register[key]
                            this.form[key] = register[key]
                        }
                        else {
                            console.log(`La clave ${key} no está presente en el objeto registers.`);
                            this.formFields[key].model = ''
                        }
                    });
                    console.log(this.form)
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
        handleGenericFormValidationConfirm(valid) {
            console.log('Retorno de generic-form-validation valid-form ')

            console.log(valid);
            this.validForm = valid
            // this.validForm = valid
        },
        async handleGenericFormValidationNewValues(key, value) {
            console.log('Retorno de generic-form-validation key-values ')
            console.log(key, value)
            if (key == 'typeRegister') {
                console.log('Cambio en typeRegister ')
                this.typeRegister = value
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
        applyRulesForDinamycForm() {
            if (this.typeRegister === 'Proceso') {
                this.dinamycRemoveFields = ['iidproceso', 'iidetapa', 'txtcolor', 'txtpermiso', 'binicial', 'bfinal', 'bcancelacion', 'brequiere_motivo', 'iidsubetapa', 'iidsubetapa_siguiente', 'bactivo', 'dtfecha_creacion', 'dtfecha_modificacion']
                this.dinamycHiddenFields = []
                this.dinamycDisabledFields = []
            } else if (this.typeRegister === 'Etapa') {
                this.dinamycRemoveFields = ['iidmodulo', 'iidetapa', 'iidsubetapa', 'iidsubetapa_siguiente', 'bactivo', 'dtfecha_creacion', 'dtfecha_modificacion']
                this.dinamycHiddenFields = []
                this.dinamycDisabledFields = []
            } else if (this.typeRegister === 'Subetapa') {
                this.dinamycRemoveFields = ['iidproceso', 'iidmodulo', 'iidsubetapa', 'iidsubetapa_siguiente', 'bactivo', 'dtfecha_creacion', 'dtfecha_modificacion']
                this.dinamycHiddenFields = []
                this.dinamycDisabledFields = []
            } else if (this.typeRegister === 'Flujo') {
                this.dinamycRemoveFields = ['iidetapa', 'iidmodulo','iidproceso', 'txtnombre', 'txtdescripcion', 'txtsigla', 'txtcolor', 'txtpermiso', 'binicial', 'bfinal', 'bcancelacion', 'brequiere_motivo', 'bactivo', 'dtfecha_creacion', 'dtfecha_modificacion']
                this.dinamycDisabledFields = []
                this.dinamycHiddenFields = []
            }
            else{
                this.showError({'message':'Tipo de registro no configurado'})
            }
        }
    },
    watch: {
        'form.typeRegister': function () {
            this.typeRegister = this.form.typeRegister
            this.applyRulesForDinamycForm()
        },

        options: {
            async handler() {
                await this.loadDinamycRegisterInProcessTable();
            },
            deep: true,
        },
    },
    async mounted() {
        await this.getAllModules()
        await this.getAllStages()
        await this.getAllSubStages()
        await this.getAllProcess()
        
        this.formFields = await this.dataFirstForm()
        let user = await services.app().getUserConfig();
        let getActivePermissionsFromUser = await services.admin().getActivePermissionsFromUser(user[0].id);
        this.peopleModulePermissions = getActivePermissionsFromUser.map(permission => permission.siglas);
        console.log('procesos permisos')
    },
}
</script>
<style lang="scss" scoped></style>
