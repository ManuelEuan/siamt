<!-- DIALOG  -->
<template>
    <div class="">
        <v-dialog v-model="dialogModalCreatePersonWithAddressAndPhone" max-width="800">
            <v-card prepend-icon="mdi-account">
                <v-col cols="12" class="pa-0 mt-2">
                    <v-tabs v-model="tab" centered icons-and-text>
                        <v-tabs-slider color="primary" />
                        <v-tab href="#generaltab">
                            Datos Generales
                            <v-badge :color="receivedTabGeneralPersonData.valid ? 'success' : 'warning'">
                                <v-icon> mdi-clipboard-text </v-icon>
                            </v-badge>
                        </v-tab>
                        <v-tab href="#direccionestab">
                            Dirección
                            <v-badge
                                :color="!receivedTabAddress.newOrEdit && !newRegisterPerson || receivedTabAddress.newOrEdit && receivedTabAddress.valid ? 'success' : 'warning'">
                                <v-icon> mdi-card-account-details </v-icon>
                            </v-badge>
                        </v-tab>
                        <v-tab href="#telefonostab">
                            Teléfono
                            <v-badge
                                :color="!receivedTabPhone.newOrEdit && !newRegisterPerson || receivedTabPhone.newOrEdit && receivedTabPhone.valid ? 'success' : 'warning'">
                                <v-icon> mdi-card-account-details </v-icon>
                            </v-badge>
                        </v-tab>
                        <v-tab href="#filestab">
                            Archivos
                            <!-- <v-badge v-if="newRegisterPerson" :color="filesValidation ? 'success' : 'warning'">
                                <v-icon> mdi-card-account-details </v-icon>
                            </v-badge> -->
                            <!-- <v-badge v-else :color="filesValidation ? 'success' : 'warning'"> -->
                            <!-- <v-icon v-else> mdi-card-account-details </v-icon> -->
                            <v-icon> mdi-card-account-details </v-icon>
                            <!-- </v-badge> -->
                        </v-tab>
                    </v-tabs>
                    <v-tabs-items v-model="tab">
                        <v-card flat>
                            <v-tab-item :key="1" value="generaltab" class="py-1">
                                <general-person-data-verification :iidpersona="iidpersona"
                                    :preLoadPerson="preLoadPerson"
                                    @general-person-data-validation="handleTabGeneralPersonData"></general-person-data-verification>
                            </v-tab-item>
                            <v-tab-item :key="2" value="direccionestab" class="py-1">
                                <address-verification :iidpersona="iidpersona"
                                    @address-validation="handleTabAddress"></address-verification>
                            </v-tab-item>
                            <v-tab-item :key="3" value="telefonostab" class="py-1">
                                <phone-verification :iidpersona="iidpersona"
                                    @phone-validation="handleTabPhone"></phone-verification>
                            </v-tab-item>
                            <v-tab-item :key="4" value="filestab" class="py-1">
                                <!-- <files-verification :iidpersona="iidpersona"
                                    @files-validation="handleFromFilesVerification"
                                    v-model="filesValidation"></files-verification> -->
                            </v-tab-item>
                        </v-card>
                    </v-tabs-items>
                    <v-card-actions v-if="!iidpersona">
                        <v-spacer />
                        <v-btn color="error" text @click="dialogModalCreatePersonWithAddressAndPhone = false"> Cerrar
                        </v-btn>
                        <v-btn color="primary" v-if="newRegisterPerson" text
                            :disabled="!receivedTabGeneralPersonData.valid || !receivedTabAddress.valid || !receivedTabPhone.valid"
                            @click="savePersonWithAddressAndPhone()">
                            Guardar
                        </v-btn>
                    </v-card-actions>
                    <v-card-actions v-else>
                        <v-spacer />
                        <v-btn color="error" text @click="dialogModalCreatePersonWithAddressAndPhone = false"> Cerrar
                        </v-btn>
                    </v-card-actions>
                </v-col>
            </v-card>
        </v-dialog>
    </div>
</template>

<style>
.v-badge__badge {
    inset: auto auto calc(100% - 4px) calc(100% - -8px) !important;
    height: 15px !important;
    min-width: 15px !important;
}
</style>

<script>
// import rules from "@/core/rules.forms";
import services from "@/services";
import { mapActions } from "vuex";
import GeneralPersonDataVerification from '@/components/common/GeneralPersonDataVerification.vue';
import AddressVerification from '@/components/common/AddressVerification.vue';
import PhoneVerification from '@/components/common/PhoneVerification.vue';

export default {
    name: 'ModalCreatePerson',
    components: {
        GeneralPersonDataVerification,
        AddressVerification,
        PhoneVerification,
    },
    props: {
        iidpersona: {
            type: Number,
            default: 0 // Valor predeterminado
        },
        activateModalPerson: {
            type: Boolean,
            default: false // Valor predeterminado
        },
        preLoadPerson: {
            bfisica: true,
            txtvariable: ''
        }
    },
    data() {
        return {
            // DATOS INFORMATIVOS
            newRegisterPerson: false,
            newRegister: true,
            tab: "generaltab",
            dataPerson: {},
            files: [],
            responseCreatePerson: {},

            // DIALOGS
            dialogModalCreatePersonWithAddressAndPhone: false,

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
        }
    },
    computed: {
    },
    methods: {
        // (GUARDADO COMPLETO DE PERSONA EN BD)
        ...mapActions('app', ['showError', 'showSuccess']),
        async savePersonWithAddressAndPhone() {
            console.log('Guardando persona con dirección y teléfono');

            try {
                console.log('se va a crear')
                console.log(this.dataPerson)
                let allInfo = {
                    person: this.receivedTabGeneralPersonData.data,
                    phone: this.receivedTabPhone.data,
                    address: this.receivedTabAddress.data,
                }
                this.responseCreatePerson = await services.inspections().createPerson(allInfo);
                console.log('responseCreatePerson create')
                console.log(this.responseCreatePerson)
                this.showSuccess(this.responseCreatePerson.message);
                this.$emit('modal-create-person', this.responseCreatePerson.persona, true)
                this.dialogModalCreatePersonWithAddressAndPhone = false
            } catch (error) {
                const message = 'Error al guardar ';
                this.showError({ message, error });
            }
        },

        // HANDLERS
        handleTabGeneralPersonData(newOrEdit, generalPersonData, valid) {
            console.log('🚀 ~ receivedFromGeneralPersonDataVerification ~ 🚀 received editing mode, generalPersonData, validation 🚀')
            this.receivedTabGeneralPersonData = {
                newOrEdit: newOrEdit,
                data: generalPersonData,
                valid: valid
            }
            console.log(this.receivedTabGeneralPersonData)
        },

        handleTabAddress(newOrEdit, address, valid) {
            console.log('🚀 ~ receivedFromAddressVerification ~ 🚀 received editing mode, address, validation 🚀')
            this.receivedTabAddress = {
                newOrEdit: newOrEdit,
                data: address,
                valid: valid
            }
            console.log(this.receivedTabAddress)
        },

        handleTabPhone(newOrEdit, phone, valid) {
            console.log('🚀 ~ receivedFromPhoneVerification ~ 🚀 received editing mode, phone, validation 🚀')
            this.receivedTabPhone = {
                newOrEdit: newOrEdit,
                data: phone,
                valid: valid
            }
            console.log(this.receivedTabPhone)
        },
    },
    watch: {
        // WATCHERS GENERAL
        'dialogModalCreatePersonWithAddressAndPhone': function () {
            if (!this.dialogModalCreatePersonWithAddressAndPhone) {
                console.log('se cerró el modal de persona')
                localStorage.setItem('newPerson', false);
                let info = ''
                if (this.receivedTabGeneralPersonData.data.iidpersona) {
                    info = this.receivedTabGeneralPersonData.data
                } else {
                    info = this.responseCreatePerson.persona
                }
                console.log(this.persona)
                console.log(this.receivedTabGeneralPersonData.data)
                console.log(this.responseCreatePerson.persona)
                console.log(info)
                this.$emit('modal-create-person', info, true)
            } else if (this.dialogModalCreatePersonWithAddressAndPhone && this.dataPerson.iidpersona == 0) {
                console.log('se abrió el modal de persona y no existe persona')
                localStorage.setItem('newPerson', true);
            }
            this.newRegisterPerson = localStorage.getItem('newPerson');
            this.newRegisterPerson = this.newRegisterPerson === 'true';
        },
        // WATCHERS PROPS
        'activateModalPerson': function () {
            if (this.activateModalPerson) {
                this.dialogModalCreatePersonWithAddressAndPhone = true
            } else {
                this.dialogModalCreatePersonWithAddressAndPhone = false
            }
        },
        'preLoadPerson': function () {
            console.log('llego el preload desde curp verification')
            console.log(this.preLoadPerson)
        }

    },
    mounted() {
        this.newRegisterPerson = localStorage.getItem('newPerson');
        this.newRegisterPerson = this.newRegisterPerson === 'true';
        if (this.newRegisterPerson) {
            this.dataPerson = {}
        }
    }


}
</script>