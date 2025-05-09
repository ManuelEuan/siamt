<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <v-card flat>
                    <v-toolbar>
                        <v-toolbar-title>{{ createMode ? "Nuevo" : "Editar" }} Inspector</v-toolbar-title>
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

                                <curp-verification :request=request :activateDialogPerson=activateModalPerson
                                    @person-info="handlePersonInfo">
                                </curp-verification>

                                <overlay :value="overlay"></overlay>
                                <v-form v-model="validationFieldsInspector">
                                    <v-row v-if="personaEncontrada && personaDisponible || !createMode">
                                        <v-col cols="12" md="6">
                                            <v-select v-model="inspector.iidturno" label="Turno*"
                                                :rules="[rules.required]" :items="shifts" item-text="txtnombre"
                                                item-value="iidturno" hide-details="auto" small-chips clearable dense
                                                outlined />
                                        </v-col>
                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="inspector.txtfolio_inspector" label="Folio"
                                                hide-details="auto" clearable dense outlined />
                                        </v-col>

                                        <v-col cols="12" md="6">
                                            <v-select v-model="inspector.iidinspector_categoria"
                                                @change="verifyCategorie" label="Categoría*" :rules="[rules.required]"
                                                :items="categories" item-text="txtnombre"
                                                item-value="iidinspector_categoria" hide-details="auto" small-chips
                                                clearable dense outlined />
                                        </v-col>

                                        <v-col cols="12" md="6" v-if="genera_boleta">
                                            <v-text-field v-model="inspector.dvigencia" clearable dense outlined
                                                label="Vigencia*" type="date" :min="getDate" :rules="[rules.required]"
                                                :mask="'####/##/##'"></v-text-field>
                                        </v-col>

                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="inspector.dfecha_alta" clearable dense outlined
                                                label="Fecha de alta" type="date" :mask="'####/##/##'"></v-text-field>
                                        </v-col>

                                        <v-col cols="12" md="6" v-if="!createMode">
                                            <v-text-field v-model="inspector.dfecha_baja" clearable dense outlined
                                                label="Fecha de baja" type="date" :mask="'####/##/##'"></v-text-field>
                                        </v-col>

                                        <generic-process-flow v-if="!createMode" :request=request
                                            @process-flow="handleProcessFlow"></generic-process-flow>

                                        <v-col cols="12">
                                            <v-textarea v-model="inspector.txtcomentarios" label="Comentarios"
                                                hide-details="auto" clearable dense outlined />
                                        </v-col>
                                    </v-row>
                                </v-form>
                            </v-card-text>
                        </v-tab-item>
                        <v-card-actions v-if="!createMode || personaEncontrada && personaDisponible">
                            <v-spacer />
                            <v-btn color="error" text @click="showAllInspectors()"> Cerrar </v-btn>
                            <v-btn color="primary" text
                                :disabled="!validationFieldsInspector"
                                @click="saveInspector()">
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
import GenericProcessFlow from '@/components/common/GenericProcessFlow.vue';
import GenericDialog from '@/components/common/GenericDialog.vue';
import Overlay from '@/components/common/Overlay.vue';

import { mapActions } from "vuex";

export default {
    components: {
        CurpVerification,
        GenericProcessFlow,
        GenericDialog,
        Overlay,
    },
    data() {
        return {
            // DATOS INFORMATIVOS
            overlay: false,
            validationFieldsInspector: false,
            tab: "generaltab",
            personaEncontrada: false,
            personaDisponible: false,
            genera_boleta: false,

            // WATCHERS FUNCIONALIDAD

            // VIENEN DE SERVICIOS
            shifts: [],
            categories: [],

            // ARREGLOS
            persona: {
                iidpersona: 0,
                txtnombre_completo: 'Sin nombre 2',
                txtrfc: '',
                txtcurp: '',
            },
            inspector: {
                iidinspector: 0,
                iidpersona: 0,
                iidetapa: 1,
                iidsubetapa: 1,
                txtfolio_inspector: "",
                iidturno: 0,
                iidinspector_categoria: 0,
                dvigencia: '',
                dfecha_alta: '',
                dfecha_baja: '',
                txtcomentarios: '',
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
                type: 'Inspector', // dinamyc Type
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

        // GET (BD)
        async getAllCategoriesInspector() {
            try {
                this.categories = await services.inspections().getAllCategoriesInspector();
            } catch (error) {
                const message = 'Error al cargar el catálogo de categorías.';
                this.showError({ message, error });
            }
        },

        // GET (BD)
        async getAllShiftsInspector() {
            try {
                this.shifts = await services.inspections().getAllShiftsInspector();
            } catch (error) {
                const message = 'Error al cargar el catálogo de turnos.';
                this.showError({ message, error });
            }
        },

        // OBTENER DATOS DEL INSPECTOR (BD)
        async setEditMode() {
            try {
                const { id } = this.$route.params;
                this.inspector = { ...await services.inspections().getInspectorInfo({ id }) };
                console.log('**********this.request*********');

                this.request = {
                    type: 'Inspector',
                    idOfSearch: this.inspector.iidpersona,
                    idOfType: this.inspector.iidinspector,
                    idOfSubStage: this.inspector.iidsubetapa,
                }
                console.log(this.request);
            } catch (error) {
                const message = 'Error al cargar información de inspector.';
                this.showError({ message, error });
            }
        },

        verifyCategorie() {
            let selectedCategorie = this.categories.find(item => item.iidinspector_categoria === this.inspector.iidinspector_categoria);
            const bgenera_boleta = selectedCategorie.bgenera_boleta;
            if (bgenera_boleta) {
                this.genera_boleta = true;
            } else {
                this.genera_boleta = false;
                this.inspector.dvigencia = null
            }
        },

        async saveInspector() {
            console.log(this.inspector)
            if (!this.validationFieldsInspector) return;

            try {
                const { message } = await (
                    this.createMode ?
                        services.inspections().createInspector(this.inspector) :
                        services.inspections().updateInspector(this.inspector)
                );
                this.showSuccess(message);
                this.showAllInspectors();
            } catch (error) {
                const message = 'Error al guardar inspector.';
                this.showError({ message, error });
            }
        },

        showAllInspectors() {
            this.$router.push("/inspections/inspectors");
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
                this.inspector.iidpersona = person.iidpersona
            } else {
                this.inspector.iidpersona = 0
            }
            this.persona = person
        },

        // RETORNO DE COMPONENTE GENÉRICO PROCESS FLOW (AUTOMÁTICO)
        handleProcessFlow(foundSubStage, infoSubStage, processSubStage, hasFlowAfter) {
            console.log('Retornando desde GENERIC PROCESS FLOW ')
            if (foundSubStage) {
                this.SubStage = {
                    info: infoSubStage,
                    process: processSubStage,
                    hasFlowAfter: hasFlowAfter,
                }
                console.log(this.SubStage)
            } else {
                alert('No se encontró registro de la sub etapa')
            }
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
        await this.getAllCategoriesInspector()
        await this.getAllShiftsInspector()
        if (!this.createMode) {
            await this.setEditMode();
        }
    }
};
</script>
