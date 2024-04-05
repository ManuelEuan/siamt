<!-- DIALOG  -->
<template>
    <div class="">
        <v-dialog v-model="dialog" max-width="800">
            <v-card prepend-icon="mdi-account" title="Captura de persona">

                <v-col cols="12" class="pa-0 mt-2">
                    <v-tabs v-model="tab" centered icons-and-text>
                        <v-tabs-slider color="primary" />
                        <v-tab href="#generaltab">
                            Datos Generales
                            <v-icon> mdi-clipboard-text </v-icon>
                        </v-tab>
                        <v-tab href="#direccionestab" v-if="persona.iidpersona">
                            Dirección
                            <v-icon> mdi-card-account-details </v-icon>
                        </v-tab>
                        <!-- <v-tab href="#telefonostab" v-if="persona.iidpersona"> -->
                        <v-tab href="#telefonostab">
                            Telefono
                            <v-icon> mdi-card-account-details </v-icon>
                        </v-tab>
                        <v-tab href="#filestab">
                            Archivos
                            <v-icon> mdi-card-account-details </v-icon>
                        </v-tab>
                    </v-tabs>
                    <v-tabs-items v-model="tab">
                        <v-card flat>
                            <v-tab-item :key="1" value="generaltab" class="py-1">
                                <general-person-data-verification :iidpersona="persona.iidpersona"
                                    :txtcurp="persona.txtcurp"
                                    @general-person-data-validation="handleFromGeneralPersonDataVerification"
                                    v-model="generalPersonDataValidation"></general-person-data-verification>
                            </v-tab-item>
                            <v-tab-item :key="2" value="direccionestab" class="py-1">
                                <direction-verification :iidpersona="persona.iidpersona"
                                    @direction-validation="handleFromDirectionVerification"
                                    v-model="directionValidation"></direction-verification>
                            </v-tab-item>
                            <v-tab-item :key="3" value="telefonostab" class="py-1">
                                <phone-verification :iidpersona="persona.iidpersona"
                                    @phone-validation="handleFromPhoneVerification"
                                    v-model="phoneValidation"></phone-verification>
                            </v-tab-item>
                            <v-tab-item :key="4" value="filestab" class="py-1">
                              
                                <!-- <phone-verification :iidpersona="persona.iidpersona"
                                    @phone-validation="handleFromPhoneVerification"
                                    v-model="phoneValidation"></phone-verification> -->
                         
                            </v-tab-item>
                        </v-card>
                    </v-tabs-items>
                    <v-card-actions v-if="tab === 'generaltab' && !persona.iidpersona">
                        <v-spacer />
                        <v-btn color="error" text @click="dialog = false"> Cerrar </v-btn>
                        <v-btn color="primary" v-if="persona.iidpersona == 0" text
                            :disabled="!generalPersonDataValidation || !phoneValidation" @click="savePersona()">
                            Guardar (principal)
                        </v-btn>
                    </v-card-actions>
                    <v-card-actions v-else>
                        <v-spacer />
                        <v-btn color="error" text @click="dialog = false"> Cerrar </v-btn>
                    </v-card-actions>
                </v-col>
            </v-card>
        </v-dialog>
    </div>
</template>

<script>
// import rules from "@/core/rules.forms";
import services from "@/services";
import { mapActions } from "vuex";
import GeneralPersonDataVerification from '@/components/common/GeneralPersonDataVerification.vue';
import DirectionVerification from '@/components/common/DirectionVerification.vue';
import PhoneVerification from '@/components/common/PhoneVerification.vue';

export default {
    name: 'ModalCreatePerson',
    components: {
        GeneralPersonDataVerification,
        DirectionVerification,
        PhoneVerification,
    },
    data() {
        return {
            tab: "generaltab",
            dataPerson: {},
            dataPhone: '',
            files: [],
            modeEditPhone: false,
            generalPersonDataValidation: false, // Variable para almacenar la validación de datos generales
            directionValidation: false, // Variable para almacenar la validación de la dirección
            phoneValidation: false, // Variable para almacenar la validación del teléfono
            dialog: false,
            showDialog: false,
            persona: {
                iidpersona: 0,
                txtcurp: '',
            }
        }
    },
    computed: {
        selectedFiles() {
            return this.files.slice(); // Devuelve una copia de los archivos seleccionados
        }
    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),

        async savePersona() {
            console.log('Guardando persona');
            console.log(this.persona);
            console.log(this.$parent.personaEncontrada = true)

            try {
                if (this.persona.iidpersona != 0) {
                    console.log('se va a editar ')
                    // let { message } = await services.inspections().updatePerson(this.persona);
                    // this.showSuccess(message);
                } else {
                    console.log('se va a crear')
                    console.log(this.dataPerson)
                    let responsePerson = await services.inspections().createPerson(this.dataPerson);
                    console.log('responsePerson create')
                    console.log(responsePerson)
                    let dataPhone = {
                        iidpersona: responsePerson.iidpersona,
                        phone: this.dataPhone,
                        bactual: true
                    }
                    console.log('dataPhone por enviar');
                    console.log(dataPhone);
                    let responsePhone = await services.inspections().createPhone(dataPhone);
                    console.log('responsePhone create')
                    console.log(responsePhone.message);
                    this.showSuccess(responsePerson.message);

                }
            } catch (error) {
                const message = 'Error al guardar persona.';
                this.showError({ message, error });
            }
        },
        handleFromGeneralPersonDataVerification(generalPersonDataVerify, person) {
            this.generalPersonDataValidation = generalPersonDataVerify
            this.dataPerson = person
        },
        handleFromDirectionVerification(directionVerify) {
            this.directionValidation = directionVerify
        },
        handleFromPhoneVerification(phoneVerify, phone) {
            this.phoneValidation = phoneVerify
            this.dataPhone = phone

        }
    },
    watch: {
        'dataPhone': function () {
            if (this.dataPhone.dataPhone.iidpersona_telefono) {
                this.modeEditPhone = true
            } else {
                this.modeEditPhone = false
            }
        },
    }

}
</script>