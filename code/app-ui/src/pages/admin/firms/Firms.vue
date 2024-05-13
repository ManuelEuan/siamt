<template>
    <v-container fluid>
        <v-flex xs12 align-center class="my-4">
            <div v-if="template.iidfirma_plantilla" id="signature-gen"
                style="margin: 0 auto; padding: 1em 1em 1em 1em; width: 900px; min-height: 225px; line-height: 20px; ">
                <!-- background:#fff;border: 1px solid #000; -->
                <v-progress-circular :size="70" :width="7" color="red" indeterminate
                    v-if="!!loadingSignature"></v-progress-circular>
                <component :is="dynTemplate" v-bind="$props"></component>
            </div>
            <div v-else>
                <h3 class="mb-3 h3" v-if="!template.iidfirma_plantilla">Selecciona una Plantilla para continuar...
                </h3>
            </div>
        </v-flex>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <v-card flat>
                    <v-row class="py-0 px-2 my-0">
                        <v-col cols="12" md="4" style="display: flex; align-items:center;">
                            <v-toolbar-title>Datos para la firma</v-toolbar-title>
                        </v-col>
                        <v-col cols="12" md="8" class="mt-4 py-0">
                            <v-autocomplete style="display: flex; align-items:center;" :rules="[rules.required]"
                                v-model="firm.iidfirma_plantilla" label="Seleccione su plantilla" :items="templates"
                                dense outlined item-text="txtnombre" item-value="iidfirma_plantilla" />
                        </v-col>
                    </v-row>

                </v-card>
                <v-form>
                    <v-card flat class="mt-5">
                        <v-row class="px-2">
                            <generic-form-validation :formFields="formFields" @form-valid="handleGenericFormValidationConfirm"
                                :formFieldsWithValues="sendFieldsWithValues"
                                @new-value="handleGenericFormValidationNewValues"></generic-form-validation>
                            <v-col cols="12" md="12" class="d-flex justify-end" v-if="!firm.iidfirma_registro">
                                <v-btn color="primary" text :disabled="!validForm || !firm.iidfirma_plantilla"
                                    @click="downloadSignature()"> Generar
                                    firma
                                </v-btn>
                                <a href="//:0" id="download-signature" style="display:none"></a>
                                <v-btn color="info" text @click="dialogSearch = true">
                                    Buscar</v-btn>
                            </v-col>
                            <v-col cols="12" md="12" class="d-flex justify-end" v-else>
                                <v-btn color="warning" text :disabled="!validForm || !firm.iidfirma_plantilla"
                                    @click="resetFirm()"> Nueva Firma
                                </v-btn>
                                <v-btn color="primary" text :disabled="!validForm || !firm.iidfirma_plantilla"
                                    @click="downloadSignature(true)"> Obtener
                                    firma
                                </v-btn>
                                <v-btn color="primary" text :disabled="!validForm || !firm.iidfirma_plantilla"
                                    @click="downloadSignature()"> Actualizar firma
                                </v-btn>
                                <a href="//:0" id="download-signature" style="display:none"></a>
                                <v-btn color="info" text @click="dialogSearch = true">
                                    Buscar</v-btn>
                            </v-col>
                        </v-row>
                    </v-card>
                </v-form>
            </v-col>
        </v-row>
        <!-- MODAL BÚSQUEDA -->
        <v-dialog transition="dialog-top-transition" max-width="600" v-model="dialogSearch">
            <v-card>
                <v-card-title class="text-uppercase primary--text text-h6 py-2">
                    Buscar firma
                </v-card-title>
                <v-divider></v-divider>
                <v-card-text class="text-lowercase text-body-1 py-2">
                    <template>
                        <v-card>
                            <v-card-title>
                                Firma
                                <v-spacer></v-spacer>
                                <v-text-field v-model="search" append-icon="mdi-magnify" label="Buscar" single-line
                                    hide-details></v-text-field>
                            </v-card-title>
                            <v-data-table v-model="selected" :headers="headers" :items="firms" :search="search"
                                :items-per-page="5" :single-select="singleSelect" show-select
                                item-key="iidfirma_registro">
                            </v-data-table>
                        </v-card>
                    </template>
                </v-card-text>
                <v-divider></v-divider>
                <v-card-actions class="py-2">
                    <v-spacer></v-spacer>
                    <v-btn color="error" text @click="dialogSearch = false"> Cerrar </v-btn>
                    <v-btn color="primary" text @click="getFirmById"> Seleccionar </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-container>
</template>

<script>
import { mapActions } from "vuex";
import GenericFormValidation from "@/components/common/GenericFormValidation.vue";
import services from "@/services";
import rules from "@/core/rules.forms";
import capture from "html2canvas";
export default {
    name: 'Firms',
    components: {
        GenericFormValidation,
    },
    data() {
        return {
            peopleModulePermissions: [],
            sendFieldsWithValues: {},
            dialogSearch: false,
            search: '',
            singleSelect: true,
            selected: [],
            validForm: false,
            iiduser: 0,
            firm: {
                iidfirma_registro: null,

                // iplantilla: 0,
                iidfirma_plantilla: null,
                txttitulo: '',
                txtnombre: '',
                txtapepat: '',
                txtapemat: '',
                txtpuesto: '',
                // iiddependencia: '',
                // iidoficina: '',
                txtoficina: '',
                txtdepartamento: '',
                txtemail: '',
                txttelefono: '',
                txtextension: '',
            },
            loadingSignature: false,
            template: [],
            templates: [],
            headers: [
                {
                    text: 'Nombre',
                    align: 'start',
                    sortable: false,
                    value: 'txtnombre',
                },
                // { text: 'Nombre', value: 'txtnombre' },
            ],
            firms: [],
            rules: rules,
            formFields: {
                // iplantilla: { label: 'Plantilla*', type: 'autocomplete', model: 'iplantilla', rules: 'required', cols: 12, md: 6, array: this.dependencias },
                txttitulo: { label: 'Título', type: 'text', model: 'txttitulo', rules: null, cols: 12, md: 6 },
                txtnombre: { label: 'Nombre/s*', type: 'text', model: 'txtnombre', rules: 'required', cols: 12, md: 6 },
                txtapepat: { label: 'Apellido paterno*', type: 'text', model: 'txtapepat', rules: 'required', cols: 12, md: 6 },
                txtapemat: { label: 'Apellido materno', type: 'text', model: 'txtapemat', rules: null, cols: 12, md: 6 },
                txtpuesto: { label: 'Puesto', type: 'text', model: 'txtpuesto', rules: 'required', cols: 12, md: 6 },
                // iiddependencia: { label: 'Dependencia*', type: 'autocomplete', model: 'iiddependencia', rules: 'required', cols: 12, md: 6 },
                txtoficina: { label: 'Oficina*', type: 'text', model: 'txtoficina', rules: 'required', cols: 12, md: 6, array: this.oficinas },
                txtdepartamento: { label: 'Departamento*', type: 'text', model: 'txtdepartamento', rules: null, cols: 12, md: 6 },
                txtemail: { label: 'Email*', type: 'text', model: 'txtemail', rules: null, cols: 12, md: 6 },
                txttelefono_mask_phone: { label: 'Teléfono*', type: 'text', model: 'txttelefono_mask_phone', rules: null, cols: 12, md: 6, maskType: 'phone' },
                txtextension: { label: 'Extensión*', type: 'text', model: 'txtextension', rules: null, cols: 12, md: 6 },
            }


        }
    },
    computed: {
        dynTemplate() {
            var replaceMarks = function (template) {
                template = template.split("{%%NOMBRE_COMPLETO%%}").join("{{ $parent.firm.txttitulo ? $parent.firm.txttitulo + '. ' + $parent.firm.txtnombre + ' ' + $parent.firm.txtapepat : $parent.firm.txtnombre + ' ' + $parent.firm.txtapepat }}");
                // template = template.split("{%%NOMBRE_COMPLETO%%}").join("{{ $parent.firm.txtnombre ? $parent.firm.txtnombre + ' ' + $parent.firm.txtapepat : $parent.firm.txtnombre + ' ' + $parent.firm.txtapepat }}");
                template = template.split("{%%DEPENDENCIA%%}").join("Agencia de Transporte de Yucatán");
                template = template.split("{%%PUESTO%%}").join("{{ $parent.firm.txtpuesto || '___________' }}");
                template = template.split("{%%DEPARTAMENTO%%}").join("{{ $parent.firm.txtdepartamento || '___________' }}");
                template = template.split("{%%OFICINA%%}").join("{{ $parent.firm.txtoficina || '___________' }}");
                template = template.split("{%%TELEFONO%%}").join("{{ $parent.firm.txttelefono || '___________' }}");
                return template;
            };
            let template = (!!this.template && !!this.template.txtplantilla) ? replaceMarks(this.template.txtplantilla) : 'No has seleccionado una Plantilla'
            template = `<div>${template}</div>`;
            return {
                template,
                props: this.$data
            }
        },
    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),
        resetFirm() {
            this.firm = {
                iidfirma_registro: null,
                // iplantilla: 0,
                iidfirma_plantilla: null,
                txttitulo: '',
                txtnombre: '',
                txtapepat: '',
                txtapemat: '',
                txtpuesto: '',
                // iiddependencia: '',
                // iidoficina: '',
                txtoficina: '',
                txtdepartamento: '',
                txtemail: '',
                txttelefono: '',
                txtextension: '',
            }
            this.sendFieldsWithValues = this.firm
            this.selected = []
        },
        async getAllFirms() {
            try {
                let firms = await services.admin().getAllFirms();
                this.firms = firms;
            } catch (error) {
                const message = 'Error al cargar servicio de firmas2.';
                alert(message);
            }
        },
        async downloadSignature(onlyImpresion = false) {
            console.log('hola')

            try {
                let data = {
                    'iidusuario': this.iiduser,
                    'firm': this.firm
                }
                if (!onlyImpresion) {
                    if (!this.firm.iidfirma_registro) {
                        let { message } = await services.admin().saveFirmRegisterByUser(data);
                        this.showSuccess(message);
                        // await this.getAllFirms();
                        setTimeout(() => {
                            window.location.reload()
                        }, 3000);
                    } else {
                        let { message } = await services.admin().updateFirmRegisterByUser(data);
                        this.showSuccess(message);
                        // await this.getAllFirms();
                        setTimeout(() => {
                            window.location.reload()
                        }, 3000);
                    }
                }
                capture(document.querySelector("#signature-gen")).then(canvas => {
                    var a = document.querySelector("#download-signature");
                    // toDataURL defaults to png, so we need to request a jpeg, then convert for file download.
                    a.href = canvas.toDataURL("image/jpeg").replace("image/jpeg", "image/octet-stream");
                    a.download = "firma.jpg";
                    a.click();
                });
            } catch (error) {
                const message = 'Error al guardar el historial de firmas1.';
                alert(message);
            }
        },
        async getTemplateById() {
            try {
                this.loadingSignature = true;
                this.template = await services.admin().getTemplateById({ 'iidfirma_plantilla': this.firm.iidfirma_plantilla });
                this.template.txtplantilla = decodeURIComponent(this.template.txtplantilla)
                console.log(this.template)
                this.loadingSignature = false
            } catch (error) {
                this.loadingSignature = false
                const message = 'Error al cargar servicio de plantilla.';
                alert(message);
            }
        },
        async getFirmById() {
            try {
                this.firm = await services.admin().getFirmById({ 'iidfirma_registro': this.selected[0].iidfirma_registro });
                console.log(this.firm)
                this.sendFieldsWithValues = this.firm
                this.dialogSearch = false
            } catch (error) {
                this.loadingSignature = false
                const message = 'Error al cargar servicio de recuperación de firma.';
                alert(message);
            }
        },
        async getAllTemplates() {
            try {
                let templates = await services.admin().getAllTemplates();
                this.templates = templates;
            } catch (error) {
                const message = 'Error al cargar servicio de plantilla.';
                alert(message);
            }
        },
        handleGenericFormValidationNewValues(key, value) {
            console.log(key, value)
            // if (key == '') { 

            // }
            this.firm[key] = value

        },
        handleGenericFormValidationConfirm(valid) {
            this.validForm = valid
        },
        rawValue() {
            const rawValue = this.formattedValue.replace(/\D/g, '');
            return rawValue
            // return maskedValue.replace(/(\d{3})(\d{3})(\d{4})/, '($1)-$2-$3');
        }
    },
    watch: {
        'firm.iidfirma_plantilla': {
            handler() {
                if (this.firm.iidfirma_plantilla) {
                    this.getTemplateById()
                }
            },
            deep: true,
        },
    },
    async mounted() {
        await this.getAllTemplates();
        await this.getAllFirms();
        let user = await services.app().getUserConfig();
        this.iiduser = user[0].id
        let getActivePermissionsFromUser = await services.admin().getActivePermissionsFromUser(user[0].id);
        this.peopleModulePermissions = getActivePermissionsFromUser.map(permission => permission.siglas);

    },
}
</script>

<style lang="scss" scoped></style>
