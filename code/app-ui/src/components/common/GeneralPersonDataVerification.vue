<template>
    <div>
        <v-card-text>
            <!-- CAMPOS DE EVENTOS -->
            <div class="row d-flex justify-space-around align-center mx-auto" v-if="!preLoadPerson.txtvariable">
                <p class="col-md-6 my-0">Información de persona {{ newRegisterPerson }} -- {{ newGeneralPersonData }} -- {{editGeneralPersonData}}</p>
                <v-col cols="12" md="6">
                    <v-btn depressed color="primary" :disabled="!generalPersonDataValidation" @click="updatePerson()">
                        Actualizar datos generales
                    </v-btn>
                </v-col>
            </div>

            <!-- CAMPOS DE AGREGAR - MODIFICAR -->
            <v-form v-model="generalPersonDataValidation">
                <div class="row d-flex justify-space-beetwen align-center mx-auto">
                    <p class="col-md-2 my-0 mx-0 px-0 py-0">Tipo de persona</p>
                    <v-radio-group cols="12" v-model="generalPersonData.bfisica" mandatory row
                        :disabled="preLoadPerson.txtvariable !== '' || editGeneralPersonData">
                        <v-radio color="success" label="Física" :value="true" style="max-width:80px"></v-radio>
                        <v-radio color="success" label="Moral" :value="false" style="max-width:80px"></v-radio>
                    </v-radio-group>
                </div>
                <v-row>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="generalPersonData.txtnombre" label="Nombre/s*" hide-details="auto"
                            clearable dense outlined :rules="[rules.required]" />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="generalPersonData.txtapepat" label="Apellido paterno*"
                            :rules="[rules.required]" hide-details="auto" clearable dense outlined />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="generalPersonData.txtapemat" label="Apellido materno" hide-details="auto"
                            clearable dense outlined />
                    </v-col>

                    <v-col cols="12" md="6">
                        <v-text-field v-model="generalPersonData.dfecha_nacimiento" clearable dense outlined
                            label="Fecha de nacimiento*" type="date" :max="getDate" :mask="'####/##/##'"
                            :rules="[rules.required]"></v-text-field>
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="generalPersonData.txtrfc" label="RFC" hide-details="auto" clearable dense
                            outlined maxlength="13" :rules="[rfcValido]"
                            :disabled="newRegisterPerson || !generalPersonData.bfisica" />
                    </v-col>

                    <v-col cols="12" md="6">
                        <v-text-field v-model="generalPersonData.txtcurp" label="CURP" :rules="[curpValido]"
                            maxlength="18" hide-details="auto" clearable dense outlined
                            :disabled="newRegisterPerson || generalPersonData.bfisica" />
                    </v-col>

                    <v-col cols="12" md="6">
                        <v-text-field v-model="generalPersonData.txtine" label="INE" hide-details="auto" clearable dense
                            outlined maxlength="19" />
                    </v-col>

                    <v-col cols="12" md="6">
                        <v-select v-model="generalPersonData.iidestado_civil" label="Estado civil" :items="civilStatus"
                            item-text="txtnombre" item-value="iidestado_civil" hide-details="auto" small-chips clearable
                            dense outlined />
                    </v-col>

                    <v-col cols="12" md="6">
                        <v-select v-model="generalPersonData.iidsexo" label="Género" :items="sexes"
                            item-text="txtnombre" item-value="iidsexo" hide-details="auto" small-chips clearable dense
                            outlined />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="generalPersonData.txtcorreo" label="Correo electrónico"
                            hide-details="auto" clearable dense outlined :rules="[rules.ifNotEmptyEmail]" />
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
        iidpersona: {
            type: Number,
            default: 0 // Valor predeterminado
        },
        preLoadPerson: {
            bfisica: true,
            txtvariable: ''
        }
    },
    data() {
        return {
            // DATOS INFORMATIVOS
            editGeneralPersonData: true,
            rfcValido: true,
            curpValido: true,

            // WATCHERS FUNCIONALIDAD
            newRegisterPerson: false,
            newGeneralPersonData: false,
            generalPersonDataValidation: true,

            // VIENEN DE SERVICIOS
            civilStatus: [],
            sexes: [],

            // ARREGLOS
            generalPersonData: {
                iidpersona: 0,
                bfisica: true,
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

            // REGLAS
            rules: {
                ...rules,
            },
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

        // GET (BD)
        async getAllSexes() {
            try {
                this.sexes = await services.inspections().getAllSexes();
            } catch (error) {
                const message = 'Error al cargar el catálogo de sexo.';
                this.showError({ message, error });
            }
        },

        // GET (BD)
        async getAllCivilStatus() {
            try {
                this.civilStatus = await services.inspections().getAllCivilStatus();
            } catch (error) {
                const message = 'Error al cargar el catálogo de estado civil.';
                this.showError({ message, error });
            }
        },

        // RESETEO EN CASO DE NUEVO REGISTRO
        resetGeneralPersonData() {
            this.generalPersonData = {
                iidpersona: 0,
                bfisica: true,
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
            }
        },

        async loadDataPerson() {
            try {
                if (this.iidpersona) {
                    console.log('LOAD GENERAL DATA PERSON')
                    this.newRegisterPerson = localStorage.getItem('newPerson');
                    this.newRegisterPerson = this.newRegisterPerson === 'true';
                    if (this.newRegisterPerson) {
                        this.newGeneralPersonData = true
                    } else {
                        this.newGeneralPersonData = false
                    }
                    console.log('this.iidpersona')
                    console.log(this.iidpersona)
                    this.generalPersonData = await services.inspections().getGeneralPersonData(this.iidpersona);
                    console.log('this.persona getGeneralPersonData GENRAL')
                console.log(this.generalPersonData)
                    console.log(this.generalPersonData)
                } else {
                    this.resetGeneralPersonData()
                }
            } catch (error) {
                const message = 'Error al cargar los datos generales de la persona.';
                this.showError({ message, error });
            }
        },

        async updatePerson() {
            console.log('Actualizando persona');
            try {
                let response = { ...await services.inspections().updatePerson(this.generalPersonData) };
                console.log('response del update person')
                console.log(response)
                this.showSuccess(response.message);
            } catch (error) {
                const message = 'Error al actualizar la persona.';
                this.showError({ message, error });
            }
        },

        // EMITIR A COMPONENTE PADRE
        emitToParentComponent() {
            console.log('🚀 ~ emitToParentComponent ~ 🚀 sending editing mode, generalPersonData, validation 🚀')
            let newOrEdit = false
            if (this.newGeneralPersonData || this.editGeneralPersonData) {
                newOrEdit = true
            }
            console.log('******************this.generalPersonData***********************')
            console.log(this.generalPersonData)
            this.$emit('general-person-data-validation', newOrEdit, this.generalPersonData, this.generalPersonDataValidation);
        }
    },

    watch: {
        // WATCHERS PROP
        'iidpersona': function () {
            console.log('watch iidpersona desde GeneralPersonDataVerification')
            this.loadDataPerson()
        },

        // WATCHERS DATA
        'newRegisterPerson': function () {
            console.log('watch newRegisterPerson')
            if (this.newRegisterPerson) {
                this.resetGeneralPersonData()
                this.newPhone = true
            }
        },
        'newGeneralPersonData': function () {
            console.log('watch newGeneralPersonData')
            if (this.newGeneralPersonData) {
                this.resetGeneralPersonData()
            }
        },
        'generalPersonDataValidation': function () {
            console.log('watch generalPersonDataValidation')
            this.emitToParentComponent()
        },
        'preLoadPerson': function () {
            console.log('llego el preload desde modal')
            console.log(this.preLoadPerson)
            this.generalPersonData.bfisica = this.preLoadPerson.bfisica
            if (this.preLoadPerson.bfisica) {
                this.generalPersonData.txtcurp = this.preLoadPerson.txtvariable
            } else {
                this.generalPersonData.txtrfc = this.preLoadPerson.txtvariable
            }
            console.log(this.generalPersonData)
        },
        'generalPersonData.bfisica': function () {
            if (this.generalPersonData.bfisica) {
                const curpRules = this.rules.curp;
                if (curpRules) {
                    this.curpValido = curpRules(this.generalPersonData.txtcurp) === true;
                }
            }
        },
        'generalPersonData.txtcurp': function () {
            if (this.generalPersonData.bfisica){
                const curpRules = this.rules.curp;
                this.personaEncontrada = false
                if (curpRules) {
                    this.curpValida = curpRules(this.curp) === true;
                }
            }
        },
        'generalPersonData.txtrfc': function () {
            if (!this.generalPersonData.bfisica){
                const rfcRules = this.rules.rfc;
                if (rfcRules) {
                    this.rfcValida = rfcRules(this.rfc) === true;
                }
            }
        },

    },
    async mounted() {
        await this.getAllSexes();
        await this.getAllCivilStatus();
        await this.loadDataPerson();
    },

}
</script>