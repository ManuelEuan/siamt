<template>
    <div style="width: 100%">
        <!-- <v-data-table :headers="headers" :items="getAllInfoPermissionsFromUser"></v-data-table> -->
        <v-row class="d-flex align-center mx-auto mt-5" v-if="!request.idOfSearch">
            <v-col cols="12" class="text-center" style="padding: 0;">Seleccione una forma de búsqueda:</v-col>
            <v-col cols="12" class="text-center" style="padding: 0;">
                <v-radio-group v-model="search" :row="$vuetify.breakpoint.smAndUp" class="p-radio">
                    <v-radio label="Nombre" value="NOMBRE" class="mr-4"></v-radio>
                    <v-radio label="CURP" value="CURP" class="mr-4"></v-radio>
                    <v-radio label="RFC" value="RFC"></v-radio>
                </v-radio-group>
            </v-col>
        </v-row>
        <v-row class="d-flex align-center mx-auto" v-if="!request.idOfSearch">
            <v-col cols="12" md="4" sm="6" style="margin: 0 0 0 auto; padding: 0; height: 40px;"
                v-if="search === 'NOMBRE'">
                <v-text-field v-model="nombre" label="NOMBRE(S)*" :rules="[rules.required]" hide-details="auto"
                    clearable dense @input="toUpperCase" outlined />
            </v-col>
            <v-col cols="12" md="4" sm="6" class="pl-0" v-if="search === 'NOMBRE'">
                <v-btn class="ml-sm-3" :disabled="nombre.length < 3" depressed color="primary" @click="verifyCurp()">
                    Realizar búsqueda
                </v-btn>
            </v-col>
        </v-row>
        <v-row class="d-flex align-center mx-auto" v-if="!request.idOfSearch">
            <v-col cols="12" md="4" sm="6" style="margin: 0 0 0 auto; padding: 0; height: 40px;"
                v-if="search === 'CURP'">
                <v-text-field v-model="curp" label="CURP*" :rules="[rules.curp]" maxlength="18" hide-details="auto"
                    clearable dense @input="toUpperCase" outlined />
            </v-col>
            <v-col cols="12" md="4" sm="6" class="pl-0" v-if="search === 'CURP'">
                <v-btn class="ml-sm-3" :disabled="!curpValida" depressed color="primary" @click="verifyCurp()">
                    Realizar búsqueda
                </v-btn>
            </v-col>
        </v-row>
        <v-row class=" d-flex align-center mx-auto" v-if="!request.idOfSearch">
            <v-col cols="12" md="4" sm="6" style="margin: 0 0 0 auto; padding: 0; height: 40px;"
                v-if="search === 'RFC'">
                <v-text-field v-model="rfc" label="RFC*" :rules="[rules.rfc]" maxlength="13" hide-details="auto"
                    clearable dense @input="toUpperCase" outlined />
            </v-col>
            <v-col cols="12" md="4" sm="6" class="pl-0" v-if="search === 'RFC'">
                <v-btn class="ml-sm-3" :disabled="!rfcValida" depressed color="primary" @click="verifyCurp()">
                    Realizar búsqueda
                </v-btn>
            </v-col>
        </v-row>


        <v-row v-if="personaDisponible">
            <v-col cols="12" md="4">
                <v-text-field v-model="persona.txtnombre_completo" label="Nombre Completo" hide-details="auto" clearable
                    dense disabled outlined />
            </v-col>
            <v-col cols="12" md="4" v-if="persona.bfisica">
                <v-text-field v-model="persona.txtcurp" label="CURP" hide-details="auto" clearable dense disabled
                    outlined />
            </v-col>
            <v-col cols="12" md="4" v-else>
                <v-text-field v-model="persona.txtrfc" label="RFC" hide-details="auto" clearable dense disabled
                    outlined />
            </v-col>
            <v-col cols="6" md="2" sm="6" v-if="peopleModulePermissions.includes('vemp')">
                <v-btn depressed color="primary" @click="showDialogPerson(persona.iidpersona)">
                    Información
                </v-btn>
            </v-col>
            <v-col cols="6" md="2" sm="6" v-if="!request.idOfSearch && request.type" ref="showSelectionPerson"
                :style="{ display: showSelectionPerson ? 'block' : 'none' }">
                <v-btn depressed color="primary" @click="emitToParentComponent()">
                    Seleccionar
                </v-btn>
            </v-col>
        </v-row>


        <generic-dialog :dialogVisible="dialogRegisterPerson" dialogTitle="No se han encontrado registros en el sistema"
            :showButtons=false @update:dialogVisible="dialogRegisterPerson = $event" @confirm="showDialogPerson(0)">
            <template v-slot:default>
                <!-- <div> -->
                <div v-if="search === 'NOMBRE'">
                    En caso de requerir el registro de la persona es necesario proporcionar el tipo de persona y sus
                    datos
                    requeridos
                    <p class="mt-3 primary--text mb-0 font-weight-bold">Tipo de persona</p>
                    <v-radio-group cols="12" md="4" v-model="typePersonFisica" mandatory row>
                        <v-radio color="success" label="Física" :value="true" style="max-width:80px"></v-radio>
                        <v-radio color="success" label="Moral" :value="false" style="max-width:80px"></v-radio>
                    </v-radio-group>
                    <v-text-field v-if="typePersonFisica" v-model="curpRegisterField" label="CURP*"
                        style="max-height: 40px;" :rules="[rules.curp]" maxlength="18" hide-details="auto" clearable
                        dense @input="toUpperCase" outlined />
                    <v-text-field v-else v-model="rfcRegisterField" label="RFC*" style="max-height: 40px;"
                        :rules="[rules.rfc]" maxlength="13" hide-details="auto" clearable dense @input="toUpperCase"
                        outlined />
                    <v-card-actions class="justify-end" style="margin-bottom: -1rem; margin-top: 1rem;">
                        <v-btn color="error" text @click="dialogRegisterPerson = false">Cancelar</v-btn>
                        <v-btn color="primary"
                            :disabled="(typePersonFisica && (!curpValida || !curpRegisterField)) || (!typePersonFisica && (!rfcValida || !rfcRegisterField))"
                            text @click="showDialogPerson(0)">Aceptar</v-btn>
                    </v-card-actions>
                </div>
                <div v-else class="mb-3">
                    ¿Desea registrarlo?
                    <v-card-actions class="justify-end" style="margin-bottom: -2.5rem;">
                        <v-btn color="error" text
                            @click="dialogRegisterPerson = false, personaEncontrada = false, personaDisponible = false">Cancelar</v-btn>
                        <v-btn color="primary" text @click="showDialogPerson(0)">Aceptar</v-btn>
                    </v-card-actions>
                </div>
            </template>
        </generic-dialog>

        <!-- DIALOG SIN PERMISOS PARA CREAR PERSONA -->
        <generic-dialog :dialogVisible="dialogWithpoutPermissionsToCreatePerson"
            dialogTitle="No se han encontrado registros en el sistema"
            @update:dialogVisible="dialogWithpoutPermissionsToCreatePerson = $event"
            @confirm="dialogWithpoutPermissionsToCreatePerson = false">
            <template v-slot:default>
                No cuenta con permisos suficientes para crear un registro de persona, favor de contactar al
                administrador del sitio.
            </template>
        </generic-dialog>

        <!-- DIALOG BÚSQUEDA DINÁMICA -->
        <generic-dialog :dialogVisible="dialogRedirectFoundRequest" :dialogTitle=messageDialogOfRequest
            @update:dialogVisible="dialogRedirectFoundRequest = $event" @confirm="redirectRouteTypeOfRequest">
            <template v-slot:default>
                ¿Desea verificar la información?
            </template>
        </generic-dialog>

        <!-- DIALOG MULTIPLE PEOPLE  -->
        <generic-dialog :dialogVisible="dialogPeopleFounds"
            dialogTitle="Se han encontrado varios registros asociados a la búsqueda"
            @update:dialogVisible="dialogPeopleFounds = $event">
            <template v-slot:default>
                Favor de seleccionar un registro
                <v-row>
                    <v-col cols="12" md="12">
                        <v-simple-table>
                            <template v-slot:default>
                                <thead>
                                    <tr>
                                        <th class="text-left">
                                            Nombre
                                        </th>
                                        <th class="text-left">
                                            Fecha de Nacimiento
                                        </th>
                                        <th class="text-left" v-if="request.type == 'Inspector'">
                                            ¿Es inspector?
                                        </th>
                                        <th class="text-left" v-if="request.type == 'Empresa'">
                                            ¿Es una empresa?
                                        </th>
                                        <th class="text-left" style="min-width: 140px;">
                                            Acciones
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in peopleFounds" :key="item.iidpersona">
                                        <td>{{ item.txtnombre_completo }}</td>
                                        <td>{{ item.dfecha_nacimiento }}</td>
                                        <td v-if="request.type == 'Inspector'">
                                            <template item.foundRequestSearched>
                                                <v-icon v-show="item.foundRequestSearched" size="medium" color="green">
                                                    mdi-check
                                                </v-icon>
                                                <v-icon v-show="!item.foundRequestSearched" size="medium"
                                                    color="red">mdi-close</v-icon>
                                            </template>
                                        </td>
                                        <td v-if="request.type == 'Empresa'">
                                            <template item.foundRequestSearched>
                                                <v-icon v-show="item.foundRequestSearched" size="medium" color="green">
                                                    mdi-check
                                                </v-icon>
                                                <v-icon v-show="!item.foundRequestSearched" size="medium"
                                                    color="red">mdi-close</v-icon>
                                            </template>
                                        </td>
                                        <td>
                                            <template>
                                                <v-tooltip bottom v-if="!item.foundRequestSearched">
                                                    <template v-slot:activator="{ on, attrs }">
                                                        <v-btn v-bind="attrs" v-on="on" icon small
                                                            @click="peopleSelected(item)">
                                                            <v-icon small v-show="item.foundRequestSearched">
                                                                mdi-close
                                                            </v-icon>
                                                            <v-icon small v-show="!item.foundRequestSearched">
                                                                mdi-check
                                                            </v-icon>
                                                        </v-btn>
                                                    </template>
                                                    <span>Seleccionar persona</span>
                                                </v-tooltip>
                                            </template>
                                        </td>
                                    </tr>
                                </tbody>
                            </template>
                        </v-simple-table>
                    </v-col>
                </v-row>
            </template>
        </generic-dialog>

        <!-- DIALOG MODAL PERSON -->
        <generic-dialog :dialogVisible="dialogModalPerson" dialogTitle='' :showButtons=false :max-width="900"
            @update:dialogVisible="dialogModalPerson = $event">
            <template v-slot:default>
                <v-tabs v-model="tab" centered icons-and-text>
                    <v-tabs-slider color="primary" />
                    <v-tab href="#generaltab">
                        Datos Generales
                        <v-badge class="badge_change"
                            :color="receivedTabGeneralPersonData.valid ? 'success' : 'warning'">
                            <v-icon> mdi-clipboard-text </v-icon>
                        </v-badge>
                    </v-tab>
                    <v-tab href="#direccionestab" v-if="peopleModulePermissions.includes('vedp')">
                        Dirección
                        <v-badge class="badge_change"
                            :color="!receivedTabAddress.newOrEdit && !newRegisterPerson || receivedTabAddress.newOrEdit && receivedTabAddress.valid ? 'success' : 'warning'">
                            <v-icon> mdi-card-account-details </v-icon>
                        </v-badge>
                    </v-tab>
                    <v-tab href="#telefonostab" v-if="peopleModulePermissions.includes('vetp')">
                        Teléfono
                        <v-badge class="badge_change"
                            :color="!receivedTabPhone.newOrEdit && !newRegisterPerson || receivedTabPhone.newOrEdit && receivedTabPhone.valid ? 'success' : 'warning'">
                            <v-icon> mdi-card-account-details </v-icon>
                        </v-badge>
                    </v-tab>
                    <v-tab href="#filestab" v-if="peopleModulePermissions.includes('veap')">
                        Archivos
                        <v-icon> mdi-card-account-details </v-icon>
                    </v-tab>
                </v-tabs>
                <v-tabs-items v-model="tab">
                    <v-card flat>
                        <v-tab-item :key="1" value="generaltab" class="py-1">
                            <general-person-data-verification :iidpersona="setPerson" :preLoadPerson="preLoadPerson"
                                @general-person-data-validation="handleTabGeneralPersonData"></general-person-data-verification>
                        </v-tab-item>
                        <v-tab-item :key="2" value="direccionestab" class="py-1">
                            <address-verification :iidpersona="setPerson"
                                @address-validation="handleTabAddress"></address-verification>
                        </v-tab-item>
                        <v-tab-item :key="3" value="telefonostab" class="py-1">
                            <phone-verification :iidpersona="setPerson"
                                @phone-validation="handleTabPhone"></phone-verification>
                        </v-tab-item>
                        <v-tab-item :key="4" value="filestab" class="py-1">
                        </v-tab-item>
                    </v-card>
                </v-tabs-items>
                <v-card-actions v-if="!iidpersona">
                    <v-spacer />
                    <v-btn color="error" text @click="dialogModalPerson = false"> Cerrar
                    </v-btn>
                    <v-btn color="primary" v-if="newRegisterPerson" text
                        :disabled="!receivedTabGeneralPersonData.valid || !receivedTabAddress.valid || !receivedTabPhone.valid"
                        @click="savePersonWithAddressAndPhone()">
                        Guardar
                    </v-btn>
                </v-card-actions>
                <v-card-actions v-else>
                    <v-spacer />
                    <v-btn color="error" text @click="dialogModalPerson = false"> Cerrar
                    </v-btn>
                </v-card-actions>
            </template>
        </generic-dialog>

    </div>
</template>
<style>
.p-radio .v-input--radio-group__input {
    display: flex;
    justify-content: center;
}

.badge_change .v-badge__badge {
    height: 14px !important;
    min-width: 14px !important;
}
</style>

<script>
import services from "@/services";
import rules from "@/core/rules.forms";
import { mapActions } from "vuex";
// import ModalCreatePerson from "@/components/common/ModalCreatePerson.vue";
import GenericDialog from '@/components/common/GenericDialog.vue';
import GeneralPersonDataVerification from '@/components/common/GeneralPersonDataVerification.vue';
import AddressVerification from '@/components/common/AddressVerification.vue';
import PhoneVerification from '@/components/common/PhoneVerification.vue';

export default {
    components: {
        // ModalCreatePerson,
        GenericDialog,
        GeneralPersonDataVerification,
        AddressVerification,
        PhoneVerification,
    },
    props: {
        iidpersona: {
            type: Number,
            default: 0 // Valor predeterminado
        },
        request: {
            type: Object,
            default: function () {
                return {
                    type: '',
                    idOfSearch: 0,
                }; // Objeto vacío como valor predeterminado
            }
        },
    },
    data() {
        return {
            // DATOS INFORMATIVOS
            showSelectionPerson: true,
            tab: "generaltab",
            newRegisterPerson: false,
            typePersonFisica: true,
            search: 'CURP',
            curpValida: false,
            nombreValido: false,
            rfcValida: false,
            personaEncontrada: false,
            personaDisponible: false,
            routeTypeOfRequest: '', // Si typeOfRequest es mandada y se encuentra un registro en la base datos se convertirá en una route de redirección donde se necesite
            messageDialogOfRequest: '',
            setPerson: {},

            // WATCHERS 
            curp: '',
            curpRegisterField: '',
            nombre: '',
            rfc: '',
            rfcRegisterField: '',

            // VIENEN DE SERVICIOS
            peopleFounds: [],
            getAllInfoPermissionsFromUser: [],
            peopleModulePermissions: [],
            headers: [
                { text: 'ID', value: 'id' },
                { text: 'Nombre', value: 'nombre' },
                { text: 'Descripción', value: 'descripcion' },
                { text: 'Siglas', value: 'siglas' }
            ],

            // ARREGLOS
            persona: {
                iidpersona: 0,
                txtnombre_completo: 'Sin nombre 1',
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

            // MODALES
            dialogRegisterPerson: false,
            dialogWithpoutPermissionsToCreatePerson: false,
            dialogWithPermissionsToCreatePerson: false,
            dialogPeopleFounds: false,
            dialogRedirectFoundRequest: false,
            dialogModalPerson: false,

            preLoadPerson: {},

            // HANDLERS
            receivedTabGeneralPersonData: {
                newOrEdit: false,
                data: {},
                valid: false,
            },
            receivedTabAddress: {
                newOrEdit: false,
                data: {},
                valid: false,
            },
            receivedTabPhone: {
                newOrEdit: false,
                data: {},
                valid: false,
            },

            // REGLAS
            rules: {
                ...rules,
            },


        }
    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),
        checkPermission(code) {
            return this.peopleModulePermissions.includes(code);
        },
        async savePersonWithAddressAndPhone() {
            console.log('Guardando persona con dirección y teléfono');
            try {
                let allInfo = {
                    person: this.receivedTabGeneralPersonData.data,
                    phone: this.receivedTabPhone.data,
                    address: this.receivedTabAddress.data,
                }
                this.responseCreatePerson = await services.admin().createPerson(allInfo);
                // this.$refs.showSelectionPerson
                // this.$refs.showSelectionPerson.hidden = true;
                this.showSelectionPerson = false;
                this.showSuccess(this.responseCreatePerson.message);
                this.personaEncontrada = true
                this.personaDisponible = true
                this.persona = this.responseCreatePerson.persona
                this.emitToParentComponent()
                this.dialogModalPerson = false
                // this.$emit('modal-create-person', this.responseCreatePerson.persona, true)
            } catch (error) {
                const message = 'Error al guardar ';
                this.showError({ message, error });
            }
        },

        toUpperCase() {
            this.nombre = this.nombre.toUpperCase();
            this.curp = this.curp.toUpperCase();
            this.rfc = this.rfc.toUpperCase();
            this.curpRegisterField = this.curpRegisterField.toUpperCase();
            this.rfcRegisterField = this.rfcRegisterField.toUpperCase();
        },

        showDialogPerson(iidpersona) {
            this.dialogRegisterPerson = false
            if (iidpersona == 0) {
                this.setPerson = 0
                if (this.search == "CURP") {
                    this.preLoadPerson = {
                        bfisica: true,
                        txtvariable: this.curp
                    }
                } else if (this.search == "RFC") {
                    this.preLoadPerson = {
                        bfisica: false,
                        txtvariable: this.rfc
                    }
                }
                localStorage.setItem('newPerson', true);
                this.dialogModalPerson = true
            } else {
                this.setPerson = iidpersona
                localStorage.setItem('newPerson', false);
                this.dialogModalPerson = true
            }
        },

        emitToParentComponent() {
            console.log('🚀 ~ emitToParentComponent ~ 🚀 sending editing mode, generalPersonData, validation 🚀')
            console.log('person-info', this.personaEncontrada, this.personaDisponible); // true - true
            this.$emit('person-info', this.personaEncontrada, this.personaDisponible, this.persona);
        },

        async verifyCurp() {
            try {
                let data = {};
                this.showSelectionPerson = true;
                if (this.search === 'CURP') {
                    data = {
                        typeSearch: this.search,
                        dataSearch: this.curp,
                        typeOfRequest: this.request.type
                    }
                }
                if (this.search === 'RFC') {
                    data = {
                        typeSearch: this.search,
                        dataSearch: this.rfc,
                        typeOfRequest: this.request.type
                    }
                }
                if (this.search === 'NOMBRE') {
                    data = {
                        typeSearch: this.search,
                        dataSearch: this.nombre,
                        typeOfRequest: this.request.type
                    }
                }
                let response = await services.admin().getPersonByDinamycSearch({ data });
                // SI NO EXISTE SE AGREGA LA PERSONA
                if (!response || !response[0]) {
                    localStorage.setItem('newPerson', true);
                    this.setPerson = 0
                    this.peopleModulePermissions.includes('crmp') ? this.dialogRegisterPerson = true : this.dialogWithpoutPermissionsToCreatePerson = true
                } else if (response.length > 1) {
                    this.peopleFounds = response
                    this.dialogPeopleFounds = true
                } else {
                    this.personaEncontrada = true
                    this.personaDisponible = true
                    this.persona = response[0]
                    if (this.persona.foundRequestSearched) {  // Si la persona buscada es econtrada significa que no esta disponible
                        if (this.request.type == 'Inspector') {
                            this.routeTypeOfRequest = `/inspections/inspectors/${this.persona.iidOfSearchedRequest}/edit`;
                            this.personaDisponible = false
                            this.messageDialogOfRequest = "La clave ingresada pertenece a un " + this.request.type
                            this.dialogRedirectFoundRequest = true
                            this.$emit('person-info', this.personaEncontrada, this.personaDisponible, this.persona);
                        }
                        if (this.request.type == 'Empresa') {
                            this.routeTypeOfRequest = `/transports/companies/${this.persona.iidOfSearchedRequest}/edit`;
                            this.personaDisponible = false
                            this.messageDialogOfRequest = "La clave ingresada pertenece a una " + this.request.type
                            this.dialogRedirectFoundRequest = true
                            this.$emit('person-info', this.personaEncontrada, this.personaDisponible, this.persona);
                        }
                    }
                }
            } catch (error) {
                const message = 'Error al procesar curp.';
                this.showError({ message, error });
            }
        },
        peopleSelected(persona) {
            this.persona = persona
            this.personaEncontrada = true
            this.personaDisponible = true
            // this.$emit('person-info', this.personaEncontrada, this.personaDisponible, this.persona);
            this.dialogPeopleFounds = false
        },
        redirectRouteTypeOfRequest() {
            this.$router.push(this.routeTypeOfRequest);
            setTimeout(() => {
                window.location.reload()
            }, 100);
        },
        // HANDLERS
        handleTabGeneralPersonData(newOrEdit, generalPersonData, valid) {
            console.log('🚀 ~ receivedFromGeneralPersonDataVerification ~ 🚀 received editing mode, generalPersonData, validation 🚀')
            this.receivedTabGeneralPersonData = {
                newOrEdit: newOrEdit,
                data: generalPersonData,
                valid: valid
            }
            // console.log('aqui', this.receivedTabGeneralPersonData)
        },

        handleTabAddress(newOrEdit, address, valid) {
            console.log('🚀 ~ receivedFromAddressVerification ~ 🚀 received editing mode, address, validation 🚀')
            this.receivedTabAddress = {
                newOrEdit: newOrEdit,
                data: address,
                valid: valid
            }
        },

        handleTabPhone(newOrEdit, phone, valid) {
            console.log('🚀 ~ receivedFromPhoneVerification ~ 🚀 received editing mode, phone, validation 🚀')
            this.receivedTabPhone = {
                newOrEdit: newOrEdit,
                data: phone,
                valid: valid
            }
        },
        async getGeneralPersonData(iidpersona) {
            try {
                this.persona = await services.admin().getGeneralPersonData(iidpersona);
            } catch (error) {
                const message = 'Error al cargar los datos de la persona.';
                this.showError({ message, error });
            }
        },
    },
    watch: {
        // WATCHERS PROPS
        'iidpersona': function () {
            console.log('change iidpersona componente CurpVerification')
        },
        'preLoadPerson': function () {
            console.log('watch this.preLoadPerson')
            console.log(this.preLoadPerson)
        },

        // WATCHERS FUNCIONALIDAD
        'dialogModalPerson': function () {
            this.newRegisterPerson = localStorage.getItem('newPerson') === 'true';
        },
        'curp': function () {
            const curpRules = this.rules.curp;
            if (curpRules) {
                this.curpValida = curpRules(this.curp) === true;
                if (!this.curpValida) {
                    this.personaDisponible = false
                    this.emitToParentComponent()
                }
            }
            this.preLoadPerson = {
                bfisica: true,
                txtvariable: this.curp
            }
        },
        'rfc': function () {
            const rfcRules = this.rules.rfc;
            if (rfcRules) {
                this.rfcValida = rfcRules(this.rfc) === true;
                if (!this.rfcValida) {
                    this.personaDisponible = false
                    this.emitToParentComponent()
                }
            }
            this.preLoadPerson = {
                bfisica: false,
                txtvariable: this.rfc
            }
        },
        'curpRegisterField': function () {
            this.curp = this.curpRegisterField
        },
        'rfcRegisterField': function () {
            this.rfc = this.rfcRegisterField
        },
        'dialogRegisterPerson': function () {
            if (this.dialogRegisterPerson) {
                this.personaEncontrada = false
                this.personaDisponible = false
                // this.$emit('person-info', this.personaEncontrada, this.personaDisponible, this.persona);
            }
        },
        'receivedTabGeneralPersonData': function () {
            if (this.receivedTabGeneralPersonData.data.iidpersona) {
                this.persona = this.receivedTabGeneralPersonData.data
                localStorage.setItem('newPerson', false);
            } else {
                localStorage.setItem('newPerson', true);
            }
        },
        'request': async function () {
            console.log('cambio en la solicitud de búsqueda de personas: ')
            if (this.request.idOfSearch && this.request.type) {
                this.newRegisterPerson = localStorage.getItem('newPerson') === 'true';
                this.personaEncontrada = true
                this.personaDisponible = true
                this.getGeneralPersonData(this.request.idOfSearch)
                this.setPerson = this.request.idOfSearch
            }
        }
    },
    async mounted() {
        let user = await services.app().getUserConfig();
        this.newRegisterPerson = localStorage.getItem('newPerson') === 'true';
        this.getAllInfoPermissionsFromUser = await services.admin().getActivePermissionsFromUser(user[0].id);
        this.peopleModulePermissions = this.getAllInfoPermissionsFromUser.map(permission => permission.siglas);
    }

}
</script>