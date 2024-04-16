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
                            <v-badge v-if="newRegisterPerson" :color="generalPersonDataValidation ? 'success' : 'warning'">
                                <v-icon> mdi-clipboard-text </v-icon>
                            </v-badge>
                            <v-icon v-else> mdi-clipboard-text </v-icon>

                        </v-tab>
                        <v-tab href="#direccionestab">
                            Dirección
                            <v-badge v-if="newRegisterPerson" :color="directionValidation ? 'success' : 'warning'">
                                <v-icon> mdi-card-account-details </v-icon>
                            </v-badge>
                            <!-- <v-badge v-else :color="directionValidation ? 'success' : 'warning'"> -->
                                <v-icon v-else> mdi-card-account-details </v-icon>
                            <!-- </v-badge> -->
                            
                        </v-tab>
                        <v-tab href="#telefonostab">
                            Telefono
                            <v-badge v-if="newRegisterPerson" :color="phoneValidation ? 'success' : 'warning'">
                                <v-icon> mdi-card-account-details </v-icon>
                            </v-badge>
                            <!-- <v-badge v-else :color="phoneValidation ? 'success' : 'warning'"> -->
                                <v-icon v-else> mdi-card-account-details </v-icon>
                            <!-- </v-badge> -->
                        </v-tab>
                        <v-tab href="#filestab">
                            Archivos
                            <v-badge v-if="newRegisterPerson" :color="directionValidation ? 'success' : 'warning'">
                                <v-icon> mdi-card-account-details </v-icon>
                            </v-badge>
                            <!-- <v-badge v-else :color="directionValidation ? 'success' : 'warning'"> -->
                                <v-icon v-else> mdi-card-account-details </v-icon>
                            <!-- </v-badge> -->
                        </v-tab>
                    </v-tabs>
                    <v-tabs-items v-model="tab">
                        <v-card flat>
                            <v-tab-item :key="1" value="generaltab" class="py-1">
                                <general-person-data-verification 
                                    :iidpersona="iidpersona" 
                                    :reset="reset"
                                    :newRegisterPerson="newRegisterPerson"
                                    :txtcurp="curp"
                                    :dataPerson="dataPerson"
                                    @general-person-data-validation="handleFromGeneralPersonDataVerification"
                                    v-model="generalPersonDataValidation"></general-person-data-verification>
                            </v-tab-item>
                            <v-tab-item :key="2" value="direccionestab" class="py-1">
                                <direction-verification 
                                    :iidpersona="iidpersona"
                                    :reset="reset" 
                                    :newRegisterPerson="newRegisterPerson"
                                    @direction-validation="handleFromDirectionVerification"
                                    v-model="directionValidation"></direction-verification>
                            </v-tab-item>
                            <v-tab-item :key="3" value="telefonostab" class="py-1">
                                <phone-verification 
                                    :iidpersona="iidpersona"
                                    :reset="reset" 
                                    :newRegisterPerson="newRegisterPerson"
                                    @phone-validation="handleFromPhoneVerification"
                                    v-model="phoneValidation"></phone-verification>
                            </v-tab-item>
                            <v-tab-item :key="4" value="filestab" class="py-1">
                              
                                <!-- <phone-verification :iidpersona="iidpersona"
                                    @phone-validation="handleFromPhoneVerification"
                                    v-model="phoneValidation"></phone-verification> -->
                         
                            </v-tab-item>
                        </v-card>
                    </v-tabs-items>
                    new register? {{newRegisterPerson}}
                    <v-card-actions v-if="!iidpersona">
                        <v-spacer />
                        <v-btn color="error" text @click="dialog = false"> Cerrar </v-btn>
                        <v-btn color="primary" v-if="iidpersona == 0" text
                            :disabled="!generalPersonDataValidation || !directionValidation || !phoneValidation" @click="savePersona()">
                            Guardar
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
import DirectionVerification from '@/components/common/DirectionVerification.vue';
import PhoneVerification from '@/components/common/PhoneVerification.vue';

export default {
    name: 'ModalCreatePerson',
    components: {
        GeneralPersonDataVerification,
        DirectionVerification,
        PhoneVerification,
    },
    props: {
        iidpersona: {
            type: Number,
            default: 0 // Valor predeterminado
        },
        curp: {
            type: String,
            default: '' // Valor predeterminado
        },
        activateModal: {
            type: Boolean,
            default: true,
        }
    },
    data() {
        return {
            reset: false,
            newRegisterPerson: false,
            newRegister: true,
            tab: "generaltab",
            dataPerson: {},
            dataDirection: '',
            dataPhone: '',
            files: [],
            generalPersonDataValidation: false, // Variable para almacenar la validación de datos generales
            directionValidation: false, // Variable para almacenar la validación de la dirección
            phoneValidation: false, // Variable para almacenar la validación del teléfono
            dialog: false,
        }
    },
    computed: {
        selectedFiles() {
            return this.files.slice(); // Devuelve una copia de los archivos seleccionados
        }
    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),
        getMode(){
            this.newRegisterPerson = localStorage.getItem('newPerson');
        },
        async savePersona() {
            console.log('Guardando persona');
            console.log(this.persona);
            console.log(this.$parent.personaEncontrada = true)

            try {
                if (this.iidpersona != 0) {
                    console.log('se va a editar ')
                    // let { message } = await services.inspections().updatePerson(this.persona);
                    // this.showSuccess(message);
                } else {
                    console.log('se va a crear')
                    console.log(this.dataPerson)
                    let all = {
                        person: this.dataPerson,
                        phone: this.dataPhone,
                        direction: this.dataDirection,
                    }
                    let responsePerson = await services.inspections().createPerson(all);
                    console.log('responsePerson create')
                    console.log(responsePerson)
                    // let dataPhone = {
                    //     iidpersona: responsePerson.iidpersona,
                    //     phone: this.dataPhone,
                    //     bactual: true
                    // }
                    // console.log('dataPhone por enviar');
                    // console.log(dataPhone);
                    // let responsePhone = await services.inspections().createPhone(dataPhone);
                    // console.log('responsePhone create')
                    // console.log(responsePhone.message);
                    // this.showSuccess(responsePerson.message);


                    // let dataDirection = {
                    //     iidpersona: responsePerson.iidpersona,
                    //     direction: this.dataDirection,
                    //     bactual: true
                    // }
                    // console.log('dataDirection por enviar');
                    // console.log(dataDirection);
                    // let responseDirection = await services.inspections().createDirection(dataDirection);
                    // console.log('responseDirection create')
                    // console.log(responseDirection.message);
                    this.showSuccess(responsePerson.message);
                    this.$emit('person-created', true, this.dataPerson.txtcurp);

                    this.dialog=false
                }
            } catch (error) {
                const message = 'Error al guardar ';
                this.showError({ message, error });
            }
        },
        handleFromGeneralPersonDataVerification(generalPersonDataVerify, person) {
            this.generalPersonDataValidation = generalPersonDataVerify
            this.dataPerson = person
        },
        handleFromDirectionVerification(directionVerify, direction) {
            this.directionValidation = directionVerify
            this.dataDirection = direction

        },
        handleFromPhoneVerification(phoneVerify, phone) {
            this.phoneValidation = phoneVerify
            this.dataPhone = phone

        }
    },
    watch: {
        'iidpersona': function(){
            if(!this.iidpersona){
                this.newRegister = false
            }
        },
        'activateModal': function(){
            this.dialog = this.activateModal;
        },
        'dialog': function () {
            // directionValidation(newValidation) {
            if (!this.dialog) {
                console.log('se cerró')
                localStorage.setItem('newPerson', false);
                
            }else if(this.dialog && this.iidpersona==0){
                console.log('se abrió')
                localStorage.setItem('newPerson', true);
                
                console.log(this.persona)
                console.log(this.dataPerson)
            }
            this.reset = true
            // console.log(this.dataPerson)
            // console.log(this.persona)
            // console.log(this.iidpersona)
            this.newRegisterPerson = localStorage.getItem('newPerson');
            this.newRegisterPerson = this.newRegisterPerson === 'true';
           
        },  
        'curp': function(){
            console.log('recibiendo este curpppp: '+this.curp)
        },  
      
    },
    mounted(){
        this.newRegisterPerson = localStorage.getItem('newPerson');
        if(this.newRegisterPerson){
            this.dataPerson={}
        }
    }


}
</script>