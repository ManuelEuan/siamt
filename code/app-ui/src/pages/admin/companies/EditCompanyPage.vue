<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <v-card flat>
                    <v-toolbar>
                        <v-toolbar-title>{{ createMode ? "Nuevo" : "Editar" }} Empresa</v-toolbar-title>
                    </v-toolbar>
                </v-card>
            </v-col>
            <v-col cols="12" class="pa-0 mt-2">
                <v-tabs v-model="tab" centered icons-and-text>
                    <v-tabs-slider color="primary" />
                    <v-tab href="#generaltab">
                        Datos Generales
                        <v-icon> mdi-clipboard-text </v-icon>
                    </v-tab>
                </v-tabs>
                <v-tabs-items v-model="tab">
                    <v-card flat>
                        <v-tab-item :key="1" value="generaltab" class="py-1">
                            <v-card-text>
                                <curp-verification :request="request" :activateDialogPerson="activateModalPerson" @person-info="handlePersonInfo">
                                </curp-verification>
                                <overlay :value="overlay"></overlay>
                                <v-form v-model="validationFieldsCompany">
                                    <v-row v-if="personaEncontrada && personaDisponible || !createMode">
                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="company.vnomenclatura" label="Nomenclatura"
                                                hide-details="auto" clearable dense outlined />
                                        </v-col>
                                    </v-row>
                                </v-form>
                            </v-card-text>
                        </v-tab-item>
                        <v-card-actions v-if="!createMode || personaEncontrada && personaDisponible">
                            <v-spacer />
                            <v-btn color="error" text @click="showAllCompanies()"> Cerrar </v-btn>
                            <v-btn color="primary" text
                                :disabled="!validationFieldsCompany"
                                @click="saveCompany()">
                                Guardar </v-btn>
                        </v-card-actions>

                    </v-card>
                </v-tabs-items>
            </v-col>
        </v-row>

        <!-- DIALOG CAMBIO DE CURP -->
        <generic-dialog :dialogVisible="dialogCurpChanged" dialogTitle="Se ha detectado un cambio en el CURP verificado"
            @update:dialogVisible="dialogCurpChanged = $event" @confirm="verifyCurp()">
            <template v-slot:default>
                Favor de verificar de nuevo
            </template>
        </generic-dialog>

        <!-- DIALOG CONFIRMATION NEXT SUB STAGE -->
        <generic-dialog :dialogVisible="dialogConfirmationNextSubStage"
            dialogTitle="Confirmar cambio a sub etapa siguiente"
            @update:dialogVisible="dialogConfirmationNextSubStage = $event" @confirm="getNextSubStage()">
            <template v-slot:default>
                ¿Desea realizar el cambio de sub etapa?. Este cambio no es reversible.
            </template>
        </generic-dialog>
    </v-container>
</template>

<script>
import rules from "@/core/rules.forms";
import services from "@/services";
import CurpVerification from '@/components/common/CurpVerification.vue';
// import GenericProcessFlow from '@/components/common/GenericProcessFlow.vue';
import GenericDialog from '@/components/common/GenericDialog.vue';
import Overlay from '@/components/common/Overlay.vue';

import { mapActions } from "vuex";

export default {
    components: {
        CurpVerification,
        // GenericProcessFlow,
        GenericDialog,
        Overlay,
    },
    data() {
        return {
            // DATOS INFORMATIVOS
            overlay: false,
            validationFieldsCompany: false,
            tab: "generaltab",
            personaEncontrada: false,
            personaDisponible: false,
            genera_boleta: false,

            // WATCHERS FUNCIONALIDAD

            // VIENEN DE SERVICIOS

            // ARREGLOS
            persona: {
                iidpersona: 0,
                txtnombre_completo: 'Sin nombre 2',
                txtrfc: '',
                txtcurp: '',
            },
            company: {
                iidempresa: 0,
                iidpersona: 0,
                activo: '',
                fecha_creacion: '',
                fecha_modificacion: '',
            },

            // MODALES
            dialogCurpChanged: false,
            dialogConfirmationNextSubStage: false,

            // PROPS SEND
            activateModalPerson: false,
            request: { // UTILIZANDO COMPONENTE GENÉRICO DE PROCESOS
                type: 'Empresa', // dinamyc Type
                idOfType: 0, // dinamyc id
                idOfSubStage: 0, //iidsubStage
                idOfNextSubStage: 0, //iidsubStage
                finalizeProcess: false,
            },

            // REGLAS
            rules: {
                ...rules,
            },

             // RETORNO DE COMPONENTE GENÉRICO PROCESS FLOW
             SubStage: {
                info: [],
                process: [],
                hasFlowAfter: false,
            },
        };
    },
    computed: {
        createMode() {
            return !this.$route.params.id;
        },
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



        // OBTENER DATOS DEL INSPECTOR (BD)
        async setEditMode() {
            try {
                const { id } = this.$route.params;
                this.company = { ...await services.admin().getCompanyInfo({ id }) };
                console.log('**********this.request*********');

                this.request = {
                    type: 'Empresa',
                    idOfSearch: this.company.iidpersona,
                    idOfType: this.company.iidempresa,
                }
                console.log(this.request);
            } catch (error) {
                const message = 'Error al cargar información de empresa.';
                this.showError({ message, error });
            }
        },

        async saveCompany() {
            console.log(this.company)
            if (!this.validationFieldsCompany) return;

            try {
                const { message } = await (
                    this.createMode ?
                        services.admin().createCompany(this.company) :
                        services.admin().updateCompany(this.company)
                );
                this.showSuccess(message);
                this.showAllCompanies();
            } catch (error) {
                const message = 'Error al guardar la empresa.';
                this.showError({ message, error });
            }
        },

        showAllCompanies() {
            this.$router.push("/transports/companies");
        },

        showDialogPerson() {
            console.log('showDialogPerson')
            this.activateModalPerson = true
        },

        // RETORNO DE COMPONENTE GENÉRICO CURP VERIFICATION
        handlePersonInfo(personFound, availablePerson, person) {
            console.log('retorno del componente Curp Verification')
            console.log('Persona encontrada: ' + personFound)
            console.log('Persona disponible: ' + availablePerson)
            console.log('Persona Información Completa: ')
            console.log(person)
            this.activateModalPerson = false
            this.personaEncontrada = personFound
            this.personaDisponible = availablePerson

            if (this.personaDisponible || this.personaEncontrada && person.iidpersona != 0) {
                this.company.iidpersona = person.iidpersona
            } else {
                this.company.iidpersona = 0
            }
            this.persona = person
        },

    },
    watch: {
        overlay(val) {
            val && setTimeout(() => {
                this.overlay = false
            }, 3000)
        },
    },
    async mounted() {
        if (!this.createMode) {
            await this.setEditMode();
        }
    }
};
</script>
