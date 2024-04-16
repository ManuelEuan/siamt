<template>
    <div>
        <v-card-text>

            <v-form v-model="generalPersonDataValidation">
                <div class="row d-flex justify-space-beetwen align-center mx-auto">
                    <p class="col-md-2 my-0 mx-0 px-0 py-0">Tipo de persona</p>
                    <v-radio-group cols="12" md="4" v-model="persona.bfisica" mandatory @change="validarRFC" row>
                        <v-radio color="success" label="Física" value="true" style="max-width:80px"></v-radio>
                        <v-radio color="success" label="Moral" value="false" style="max-width:80px"></v-radio>
                    </v-radio-group>
                    <v-col cols="12" md="6" v-if="!newRegisterPerson">
                        <v-btn depressed color="primary" :disabled="!generalPersonDataValidation"
                            @click="updatePerson()">
                            Actualizar datos generales
                        </v-btn>
                    </v-col>
                </div>
                <!-- FORMULARIO DATOS GENERALES -->
                <v-row>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="persona.txtnombre" label="Nombre/s*" hide-details="auto" clearable dense
                            outlined :rules="[rules.required]" />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="persona.txtapepat" label="Apellido paterno*" :rules="[rules.required]"
                            hide-details="auto" clearable dense outlined />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="persona.txtapemat" label="Apellido materno" hide-details="auto" clearable
                            dense outlined />
                    </v-col>

                    <v-col cols="12" md="6">
                        <v-text-field v-model="persona.dfecha_nacimiento" clearable dense outlined
                            label="Fecha de nacimiento*" type="date" :max="getDate" :mask="'####/##/##'"
                            :rules="[rules.required]"></v-text-field>
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="persona.txtrfc" label="RFC" hide-details="auto" clearable dense outlined
                            maxlength="13" :rules="[rfcValido]" />
                    </v-col>


                    <v-col cols="12" md="6">
                        <v-text-field v-model="persona.txtcurp" label="CURP*" :rules="[rules.curp]" maxlength="18"
                            hide-details="auto" clearable dense outlined disabled />
                    </v-col>

                    <v-col cols="12" md="6">
                        <v-text-field v-model="persona.txtine" label="INE" hide-details="auto" clearable dense outlined
                            maxlength="19" />
                    </v-col>

                    <v-col cols="12" md="6">
                        <v-select v-model="persona.iidestado_civil" label="Estado civil" :items="civilStatus"
                            item-text="txtnombre" item-value="iidestado_civil" hide-details="auto" small-chips clearable
                            dense outlined />
                    </v-col>

                    <v-col cols="12" md="6">
                        <v-select v-model="persona.iidsexo" label="Género" :items="sexes" item-text="txtnombre"
                            item-value="iidsexo" hide-details="auto" small-chips clearable dense outlined />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="persona.txtcorreo" label="Correo electrónico" hide-details="auto"
                            clearable dense outlined :rules="[validarCorreo]" />
                    </v-col>
                </v-row>
            </v-form>
        </v-card-text>
    </div>
</template>
<script>
import rules from "@/core/rules.forms";
import services from "@/services";
import { mapActions } from "vuex";

export default {
    name: 'ModalCreatePerson',
    props: {
        newRegisterPerson: {
            type: Boolean,
            default: false // Valor predeterminado
        },
        iidpersona: {
            type: Number,
            default: 0 // Valor predeterminado
        },
        txtcurp: {
            type: String,
            default: '' // Valor predeterminado
        },
        dataPerson: {
            type: Object,
            default: function () {
                return {
                    // Propiedades predeterminadas del objeto infoPerson
                };
            }
        }
    },
    data() {
        return {
            newPerson: true,
            generalPersonDataValidation: false,
            civilStatus: [],
            sexes: [],
            rules: {
                ...rules,
            },
            rfcValido: true,
            persona: {
                iidpersona: 0,
                bfisica: 'true',
                txtnombre: '',
                txtapepat: '',
                txtapemat: '',
                dfecha_nacimiento: '',
                txtrfc: '',
                txtcurp: '',
                txtine: '',
                iidestado_civil: null,
                iidsexo: null,
                txtcorreo: '',
                bactivo: true,
                fecha_creacion: '',
                fecha_modificacion: ''
            },
            newMode: true,
        }
    },
    computed: {
        getDate() {
            const today = new Date();
            const year = today.getFullYear();
            const month = (today.getMonth() + 1).toString().padStart(2, '0');
            const day = today.getDate().toString().padStart(2, '0');
            return `${year}-${month}-${day}`;
        }
    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),
        resetPerson() {
            this.persona = {
                iidpersona: 0,
                bfisica: 'true',
                txtnombre: '',
                txtapepat: '',
                txtapemat: '',
                dfecha_nacimiento: '',
                txtrfc: '',
                // txtcurp: '',
                txtine: '',
                iidestado_civil: null,
                iidsexo: null,
                txtcorreo: '',
                bactivo: true,
                fecha_creacion: '',
                fecha_modificacion: ''
            }
        },
        async loadSelectableData() {
            try {
                this.sexes = await services.inspections().getAllSexesPerson();
                this.civilStatus = await services.inspections().getAllCivilStatusPerson();

                let data = {
                    typeSearch: 'CURP',
                    dataSearch: this.txtcurp
                }
                console.log('response from curp verification')
                console.log(this.iidpersona)
                console.log(this.txtcurp)
                this.persona.txtcurp = this.txtcurp
                if (this.iidpersona != 0) {
                    console.log('mode edit')
                    this.newMode = false
                    let response = { ...await services.inspections().getPersonByDinamycSearch({ data }) };
                    console.log(response)
                    this.persona = response[0]
                } else {
                    console.log('mode new')
                    this.newMode = true

                }

            } catch (error) {
                const message = 'Error al cargar opciones para nuevo inspector.';
                this.showError({ message, error });
            }
        },
        validarRFC() {
            this.persona.txtrfc = this.persona.txtrfc.toUpperCase()
            let rfc = this.persona.txtrfc.trim();
            if (rfc.length === 0 && this.persona.bfisica === "true") {
                this.$set(this, 'rfcValido', true); // RFC vacío, se considera válido
                return;
            }
            const regexPersonaFisica = /^[A-Z]{4}[0-9]{6}[A-Z0-9]{3}$/;
            const regexPersonaMoral = /^[A-Z]{3}[0-9]{6}[A-Z0-9]{3}$/;
            let regex = this.persona.bfisica === "true" ? regexPersonaFisica : regexPersonaMoral;
            let rfcValido = regex.test(rfc);
            this.$set(this, 'rfcValido', rfcValido ? true : 'RFC inválido');
        },
        validarCorreo(value) {
            if (value && value.trim().length > 0) {
                const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; // Expresión regular para validar correo electrónico
                return regex.test(value) || 'Correo electrónico inválido';
            }
            return true;
        },
        async verifyCurp(curp, needModal) {
            this.persona = { ...await services.inspections().getPersonByCurp({ curp }) };
            console.log('el curp que viene desde edit inspector es de esta persona: ')
            console.log(this.persona)
            console.log('NECESITA ABRIR ' + needModal)
        },
        async updatePerson() {
            console.log('Actualizando persona');
            try {

                if (this.persona.iidpersona != 0) {
                    console.log('se va a editar ')
                    let response = { ...await services.inspections().updatePerson(this.persona) };
                    console.log('response del update persona')
                    console.log(response)
                    this.showSuccess(response.message);
                }
            } catch (error) {
                const message = 'Error al guardar persona.';
                this.showError({ message, error });
            }
        },
    },
    watch: {
        'persona.txtrfc': function () {
            if (!this.persona.bfisica) {

                this.validarRFC()
            }
        },
        'generalPersonDataValidation': function () {
            // generalPersonDataValidation(newValidation) {
            console.log('validación de datos generales de persona')
            console.log(this.generalPersonDataValidation)
            this.$emit('general-person-data-validation', this.generalPersonDataValidation, this.persona);
        },
        'persona.iidpersona': function () {
            if (this.persona.iidpersona != 0) {
                this.newPerson = false
            }
        },
        'newRegisterPerson': function () {
            if (this.newRegisterPerson) {
                // this.showFields = true
                // this.showPersonPhones = false
                this.resetPerson()
                this.persona.txtcurp = this.txtcurp
            } else {
                console.log('aqui entramoossssss')
            }
        },
        'txtcurp': function () {
            console.log('capa 2 recibiendo este curpppp: ' + this.txtcurp)
        },
        'dataPerson': function () {
            console.log('capa 2 recibiendo este curpppp: ' + this.dataPerson)
            this.persona = this.dataPerson
        },
    },
    async mounted() {
        await this.loadSelectableData();

    },

}
</script>