<template>
    <v-card flat>
        <v-toolbar>
            <v-toolbar-title>Procesos</v-toolbar-title>
            <v-spacer></v-spacer>
            <!-- <v-tooltip v-if="permissions.includes('crii')" top> -->
            {{ selectedRegister }}
            <v-tooltip top>
                <template v-slot:activator="{ on, attrs }">
                    <v-btn color="primary" class="me-1" @click="dialogNewRegister = true" v-bind="attrs" v-on="on">
                        <v-icon> mdi-plus </v-icon>
                    </v-btn>
                </template>
                <span>Agregar registro</span>
            </v-tooltip>
            <v-divider vertical class="mx-2"></v-divider>
            <!-- <v-badge overlap :content="activeFilters" :value="activeFilters">
                <v-dialog v-model="dialog" width="600">
                    <template v-slot:activator="{ on, attrs }">
                        <v-btn fab color="secondary" v-bind="attrs" v-on="on" small>
                            <v-icon>mdi-filter</v-icon>
                        </v-btn>
                    </template>

                    <v-card>
                        <v-card-title class="text-uppercase primary--text text-h6 py-2">Filtros</v-card-title>
                        <v-divider></v-divider>
                        <v-card-text>
                            <v-row dense>
                                <v-col cols="12" md="6">
                                    <v-text-field v-model="filters.name" label="Nombre" hide-details="auto" clearable
                                        dense outlined></v-text-field>
                                </v-col>
                                <v-col cols="12" md="6">
                                    <v-text-field v-model="filters.tarjeton" label="Folio" hide-details="auto" clearable
                                        dense outlined></v-text-field>
                                </v-col>
                                <v-col cols="12" md="6">
                                    <v-text-field v-model="filters.etapa" label="Etapa" hide-details="auto" clearable
                                        dense outlined></v-text-field>
                                </v-col>
                                <v-col cols="12" md="6">
                                    <v-text-field v-model="filters.turno" label="Turno" hide-details="auto" clearable
                                        dense outlined></v-text-field>
                                </v-col>
                                <v-col cols="12" md="6">
                                    <v-text-field v-model="filters.categoria" label="Categoría" hide-details="auto"
                                        clearable dense outlined></v-text-field>
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
                            <v-btn color="primary" text @click="applyFilters">
                                Aplicar
                            </v-btn>
                        </v-card-actions>
                    </v-card>
                </v-dialog>
            </v-badge> -->
        </v-toolbar>
        <!-- DIALOG ACTUALIZAR TELÉFONO ACTUAL -->
        <generic-dialog :dialogVisible="dialogNewRegister" dialogTitle="Nuevo registro"
            @update:dialogVisible="dialogNewRegister = $event" @confirm="saveRegisterDinamyc()">
            <template v-slot:default>
                Seleccione las opciones necesarias según su tipo de registros
                <generic-form-validation :formFields="formFieldTypeRegister"
                    @form-valid="handleGenericFormValidationConfirmFragmentOne"
                    :formFieldsWithValues="sendFieldsWithValues"
                    @new-value="handleGenericFormValidationNewValuesFragmentOne"></generic-form-validation>

                <generic-form-validation :formFields="formFieldTypeRegister"
                    @form-valid="handleGenericFormValidationConfirmFragmentTwo"
                    :formFieldsWithValues="sendFieldsWithValues"
                    @new-value="handleGenericFormValidationNewValuesFragmentTwo"></generic-form-validation>
            </template>
        </generic-dialog>
    </v-card>
</template>


<script>
import services from '@/services';
import GenericDialog from '@/components/common/GenericDialog.vue';
import GenericFormValidation from "@/components/common/GenericFormValidation.vue";
export default {
    name: 'ProcessPage',
    components: {
        GenericDialog,
        GenericFormValidation,
    },
    data() {
        return {
            dialogNewRegister: false,
            selectedRegister: null,
            sendFieldsWithValues: {},
            validForm: false,
            typesRegister: [
                {
                    "type": 'process',
                    "name": "Nuevo proceso",
                },
                {
                    "type": 'stage',
                    "name": "Nueva etapa",
                },
                {
                    "type": 'substage',
                    "name": "Nueva subetapa",
                }
            ],
            peopleModulePermissions: [],
            form: {
                permisos_autocomplete_list: [],
                permisos_autocomplete_object: [],
                txttitulo: '',
                txttelefono: '',
            },
        }
    },
    computed: {
        formFieldTypeRegister() {
            return {
                selectedRegister: {
                    label: 'Seleccione su tipo de registro*',
                    type: 'autocomplete',
                    model: 'selectedRegister',
                    rules: 'required',
                    cols: 12,
                    md: 12,
                    class: 'mx-auto',
                    style: 'max-width: 50%',
                    array: { type: 'object', info: this.typesRegister, item_text: 'name', item_value: 'type' }
                },
                txttitulo: { label: 'Título', type: 'text', model: 'txttitulo', rules: null, cols: 12, md: 6 },
                // txttelefono_mask_phone: { label: 'Teléfono*', type: 'text', model: 'txttelefono_mask_phone', rules: 'required|telefono', cols: 12, md: 6, maskType: 'phone' },
            }
        }
    },
    methods: {
        saveRegisterDinamyc() {
            console.log(this.selectedRegister)
        },
        handleGenericFormValidationConfirmFragmentOne(valid) {
            console.log('Retorno de generic-form-validation valid-form FragmentOne')

            console.log(valid);
            // this.validForm = valid
        },
        handleGenericFormValidationNewValuesFragmentOne(key, value) {
            console.log('Retorno de generic-form-validation key-values FragmentOne')
            console.log(key, value)
            // if ()
        },
        handleGenericFormValidationConfirmFragmentTwo(valid) {
            console.log('Retorno de generic-form-validation valid-form FragmentTwo')
            console.log(valid);
            // this.validForm = valid
        },
        handleGenericFormValidationNewValuesFragmentTwo(key, value) {
            console.log('Retorno de generic-form-validation key-values FragmentTwo')
            console.log(key, value)
            // if ()
        },

    },
    async mounted() {
        // await this.getAllTemplates();
        // await this.getAllFirms();
        let user = await services.app().getUserConfig();
        let getActivePermissionsFromUser = await services.admin().getActivePermissionsFromUser(user[0].id);
        this.peopleModulePermissions = getActivePermissionsFromUser.map(permission => permission.siglas);
        console.log('procesos permisos')
        console.log(this.peopleModulePermissions)
        // let firm = {
        //     txttitulo: '',
        //     txttelefono_mask_phone: 7889,
        //   }
        // this.sendFieldsWithValues = firm
    },
}
</script>
<style lang="scss" scoped></style>
