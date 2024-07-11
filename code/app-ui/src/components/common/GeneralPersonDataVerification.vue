<template>
    <div>
        <v-card-text>
            <!-- CAMPOS DE EVENTOS -->
            <v-row class="mx-auto" v-if="peopleModulePermissions.includes('edgp') && iidpersona">
                <v-col cols="12" class="text-right">
                    <v-btn depressed color="primary" :disabled="!generalPersonDataValidation" @click="updatePerson()">
                        Actualizar datos
                    </v-btn>
                </v-col>
            </v-row>
            <!-- CAMPOS DE AGREGAR - MODIFICAR -->
            <v-form v-model="generalPersonDataValidation">
                <div class="row d-flex justify-space-beetwen align-center mx-auto">
                    <p class=" my-0 mx-0 pr-3 py-0">Tipo de persona</p>
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
                    <v-col cols="12" md="6" v-if="generalPersonData.bfisica">
                        <v-text-field v-model="generalPersonData.txtapellido_paterno" label="Apellido paterno*"
                            :rules="[rules.required]" hide-details="auto" clearable dense outlined />
                    </v-col>
                    <v-col cols="12" md="6" v-if="generalPersonData.bfisica">
                        <v-text-field v-model="generalPersonData.txtapellido_materno" label="Apellido materno"
                            hide-details="auto" clearable dense outlined />
                    </v-col>
                    <v-col cols="12" md="6" v-if="generalPersonData.bfisica">
                        <v-text-field v-model="generalPersonData.dfecha_nacimiento" clearable dense outlined
                            label="Fecha de nacimiento*" type="date" :max="getDate" :mask="'####/##/##'"
                            :rules="[rules.required]"></v-text-field>
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="generalPersonData.txtrfc" label="RFC" hide-details="auto" clearable dense
                            outlined maxlength="13" :rules="[rfcValido]" :disabled="!generalPersonData.bfisica" />
                    </v-col>
                    <v-col cols="12" md="6" v-if="generalPersonData.bfisica">
                        <v-text-field v-model="generalPersonData.txtcurp" label="CURP" :rules="[curpValido]"
                            maxlength="18" hide-details="auto" clearable dense outlined
                            :disabled="generalPersonData.bfisica" />
                    </v-col>
                    <v-col cols="12" md="6" v-if="generalPersonData.bfisica">
                        <v-text-field v-model="generalPersonData.txtine" label="INE" hide-details="auto" clearable dense
                            outlined maxlength="19" />
                    </v-col>
                    <v-col cols="12" md="6" v-if="generalPersonData.bfisica">
                        <v-autocomplete v-model="generalPersonData.iidestado_civil" label="Estado civil"
                            :items="civilStatus" item-text="txtnombre" item-value="iidestado_civil" hide-details="auto"
                            small-chips clearable dense outlined />
                    </v-col>
                    <v-col cols="12" md="6" v-if="generalPersonData.bfisica">
                        <v-autocomplete v-model="generalPersonData.iidsexo" label="Género" :items="sexes"
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
                txtapellido_paterno: '',
                txtapellido_materno: '',
                dfecha_nacimiento: '',
                txtrfc: '',
                txtcurp: '',
                txtine: '',
                iidestado_civil: null,
                iidsexo: null,
                txtcorreo: '',
                bactivo: true,
                dtfecha_creacion: '',
                dtfecha_modificacion: ''
            },
            peopleModulePermissions: [],

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
                this.sexes = await services.admin().getAllSexes();
            } catch (error) {
                const message = 'Error al cargar el catálogo de sexo.';
                this.showError({ message, error });
            }
        },

        // GET (BD)
        async getAllCivilStatus() {
            try {
                this.civilStatus = await services.admin().getAllCivilStatus();
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
                txtapellido_paterno: '',
                txtapellido_materno: '',
                dfecha_nacimiento: '',
                txtrfc: '',
                txtcurp: '',
                txtine: '',
                iidestado_civil: null,
                iidsexo: null,
                txtcorreo: '',
                bactivo: true,
                dtfecha_creacion: '',
                dtfecha_modificacion: ''
            }
        },

        async loadDataPerson() {
            try {
                if (this.iidpersona) {
                    this.newRegisterPerson = localStorage.getItem('newPerson');
                    this.newRegisterPerson = this.newRegisterPerson === 'true';
                    this.generalPersonData = await services.admin().getGeneralPersonData(this.iidpersona);
                    // this.emitToParentComponent()
                } else {
                    localStorage.setItem('newPerson', true);
                    this.resetGeneralPersonData()
                    this.generalPersonData.bfisica = this.preLoadPerson.bfisica
                    if (this.preLoadPerson.bfisica) {
                        this.generalPersonData.txtcurp = this.preLoadPerson.txtvariable
                    } else {
                        this.generalPersonData.txtrfc = this.preLoadPerson.txtvariable
                    }
                }
                this.newRegisterPerson = localStorage.getItem('newPerson');
            } catch (error) {
                const message = 'Error al cargar los datos generales de la persona.';
                this.showError({ message, error });
            }
        },

        async updatePerson() {
            console.log('Actualizando persona');
            try {
                let response = { ...await services.admin().updatePerson(this.generalPersonData) };
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
            this.$emit('general-person-data-validation', newOrEdit, this.generalPersonData, this.generalPersonDataValidation);
        }
    },

    watch: {
        // WATCHERS PROP
        'iidpersona': function () {
            console.log('watch iidpersona desde GeneralPersonDataVerification')
            this.loadDataPerson()
        },
        'preLoadPerson': function () {
            console.log('llego el preload desde curp verification')
            console.log(this.preLoadPerson)
            this.generalPersonData.bfisica = this.preLoadPerson.bfisica
            if (this.preLoadPerson.bfisica) {
                this.generalPersonData.txtcurp = this.preLoadPerson.txtvariable
            } else {
                this.generalPersonData.txtrfc = this.preLoadPerson.txtvariable
            }
            console.log(this.generalPersonData)
        },
        // WATCHERS GENERAL
        'generalPersonDataValidation': function () {
            console.log('watch generalPersonDataValidation')
            this.emitToParentComponent()
        },
    },
    async mounted() {
        await this.getAllSexes();
        await this.getAllCivilStatus();
        await this.loadDataPerson();
        const { pel } = await services.security().getPermissions();
        if (pel) this.peopleModulePermissions = pel;
        this.newRegisterPerson = localStorage.getItem('newPerson') === 'true';
    },

}
</script>