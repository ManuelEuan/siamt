<template>
    <div>
        {{ currentFlow.nextSubStage }}
        <div class="row">
            <p class="col-md-12 primary--text text-h6 text-center">PROCESO: <span class="text-h10"
                    style="color: #000;">{{ allFlow.txtnombre }}</span></p>
            <p class="col-md-8 primary--text text-h6">ETAPA ACTUAL: <span class="text-h10" style="color: #000;">
                    {{ currentFlow.currentSubStage.etapa_nombre }}</span></p>
            <div class="col-md-4" v-if="request.idOfType">
                <v-btn color="primary" @click="dialogRequestTrace = true">Seguimiento del proceso</v-btn>
            </div>
        </div>

        <template>
            <v-stepper v-model="steepSubStage" vertical>
                <v-stepper-step complete editable step="1">
                    {{ currentFlow.currentSubStage.subetapa_nombre }} ({{ currentFlow.currentSubStage.txtsigla }})
                    <span v-if="currentFlow.currentSubStage.iidetapa != currentFlow.nextSubStage.iidetapa">
                        <i style="color: orange;" aria-hidden="true"
                            class="v-icon notranslate mdi mdi-alert theme--light"></i> Pasára a la siguiente etapa
                    </span>
                </v-stepper-step>

                <v-stepper-content step="1">
                    <div height="100px">
                        <div :style="'background-color: ' + (currentFlow.currentSubStage.txtcolor !== '' ? currentFlow.nextSubStage.txtcolor : 'gray')"
                            class="mb-6 d-flex align-center justify-center py-2"
                            style="color: white; font-weight: bold; font-size: 16px;margin-bottom: 1rem !important;">
                            Descripción: {{ currentFlow.currentSubStage.descripcion_subetapa_actual }}
                        </div>
                    </div>
                    <div v-if="currentFlow.nextSubStage">
                        <v-btn color="primary" @click="dialogverifyNextSubStage = true">Siguiente</v-btn>
                        <v-btn text @click="cancelAction">Cancelar</v-btn>
                    </div>
                    <div
                        v-else-if="!currentFlow.nextSubStage && currentFlow.currentSubStage.iidsubetapa !== currentFlow.nextSubStage.iidsubetapa">
                        <v-btn color="primary" @click="showAlertFinalize()">Ya no existe flujo posterior</v-btn>
                    </div>
                    <div v-else-if="currentFlow.currentSubStage.iidsubetapa === currentFlow.nextSubStage.iidsubetapa">
                        <v-btn color="primary" @click="showAlertFinalize()">Finalizar</v-btn>
                    </div>
                    <div v-else>
                        <!-- <v-btn color="primary" @click="showAlertFinalize()">Ya no existe flujo posterior</v-btn> -->
                        No contemplado
                    </div>

                </v-stepper-content>

                <v-stepper-step step="2">
                    {{ currentFlow.currentSubStage.nombre_subetapa_siguiente }}
                </v-stepper-step>

                <v-stepper-content step="2">
                    <v-card
                        :style="'background-color: ' + (currentFlow.currentSubStage.txtcolor !== '' ? currentFlow.currentSubStage.txtcolor : 'gray')"
                        class="mb-6 d-flex align-center justify-center" height="200px">
                        {{ currentFlow.nextSubStage.txtdescripcion }}
                    </v-card>
                </v-stepper-content>
            </v-stepper>
        </template>

        <!-- DIALOG CONFIRMATION NEXT SUB STAGE -->
        <generic-dialog :dialogVisible="dialogRequestTrace" dialogTitle="Visualizar seguimiento"
            @update:dialogVisible="dialogRequestTrace = $event" @confirm="dialogRequestTrace = false">
            <template v-slot:default>
                {{ treeData }}
                <template>
                    <v-treeview :items="treeData" :expanded.sync="expandedItems" activatable
                        color="primary" transition open-all open-on-click>
                        <template v-slot:prepend="{ item }">
                            <v-icon v-if="item.icon" color="primary">{{ item.icon }}</v-icon>
                        </template>
                    </v-treeview>
                </template>
            </template>
        </generic-dialog>

        <generic-dialog :dialogVisible="dialogDemoProcess" dialogTitle="Parámetros faltantes"
            @update:dialogVisible="dialogDemoProcess = $event" @confirm="dialogDemoProcess = false">
            <template v-slot:default>
                Existen parámetros que no se han enviado o que no han sido configurados, favor de contactar al
                administrador.
            </template>
        </generic-dialog>

        <generic-dialog :dialogVisible="dialogverifyNextSubStage" dialogTitle="Cambio en el proceso"
            @update:dialogVisible="dialogverifyNextSubStage = $event" @confirm="confirmAction">
            <template v-slot:default>
               Estos cambios son irreversibles. ¿Desea continuar con el proceso?
            </template>
        </generic-dialog>
    </div>
    <!-- </div> -->
</template>
<style>
.v-stepper__wrapper div {
    height: auto !important;
}

/* Estilos personalizados para el icono */
.v-treeview-node__label {
    display: flex;
    align-items: center;
}

.v-treeview-node__prepend {
    margin-right: 8px;
}
</style>

<script>
import services from "@/services";
import GenericDialog from '@/components/common/GenericDialog.vue';
import { mapActions } from "vuex";
export default {
    components: {
        GenericDialog,
    },
    data() {
        return {
            activeStep: 0,
            // activeStep: -1,
            // activeStep: null,
            steepSubStage: 1,
            traceOfRequest: 2,
            switch1: false,
            requestDinamyc: {
                type: '', //type-dinamyc
                idOfType: 0, //iid-dinamyc
                idOfSubStage: 0, //iidsubStage
                idOfNextSubStage: 0, //iidsubStage
                finalizeProcess: false,
            },
            // iidProperties: {
            //     'Inspector': 'iidinspector',
            //     'Boleta': 'iidboleta',
            // },
            dialogverifyNextSubStage:false,
            // ARRAYS
            allFlow: [],
            currentFlow: { // EJEMPLO DE RESPUESTA
                "currentSubStage": {
                    "iidsubetapa": 0,
                    "subetapa_nombre": "",
                    "txtsigla": "",
                    "txtdescripcion": "",
                    "txtcolor": "",
                    "txtpermiso": null,
                    "binicial": false,
                    "bfinal": false,
                    "bcancelacion": false,
                    "brequiere_motivo": false,
                    "iidetapa": 0,
                    "iidproceso": 0,
                    "etapa_nombre": ""
                },
                "nextSubStage": {
                    "iidsubetapa": 0,
                    "subetapa_nombre": "",
                    "txtsigla": "MJC1",
                    "txtdescripcion": "",
                    "txtcolor": "",
                    "txtpermiso": null,
                    "binicial": false,
                    "bfinal": false,
                    "bcancelacion": false,
                    "brequiere_motivo": false,
                    "iidetapa": 0,
                    "iidproceso": 0,
                    "etapa_nombre": ""
                }
            },
            followUp: [],
            treeData: [],
            expandedItems: [0],
            // DIALOGS
            dialogRequestTrace: false,
            dialogDemoProcess: false,

            // this.foundSubStage, this.currentSubStage, this.process, this.hasFlowAfter
            // EMITIR
            emitResponse: { //DEMO
                foundSubStage: '', // Encontrado
                currentSubStage: 0, // iidsubStage all data
                process: {}, // process all data
                hasFlowAfter: false, // continua proceso
            },

        }
    },
    props: {
        nextStage: {
            type: Boolean,
            required: false
        },
        finalizeProcess: {
            type: Boolean,
            required: false,
            default: false,
        },
        request: {
            type: Object,
            default: function () {
                return {
                    type: '', //type-dinamyc
                    idOfType: 0, //iid-dinamyc
                    idOfSubStage: 0, //iidsubStage
                    idOfNextSubStage: 0, //iidsubStage
                    finalizeProcess: false,
                };
            }
        },

    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),
        async loadFlowData() {
            try {
                console.log('this.requestDinamyc');
                console.log(this.requestDinamyc);
                let allInfo = await services.inspections().getInfoBySubStage(this.requestDinamyc);
                console.log(allInfo);
                this.allFlow = allInfo.allFlow
                this.currentFlow = allInfo.currentFlow
                this.followUp = allInfo.followUp
                this.treeData = this.convertToTreeStructure(allInfo.allFlow.etapas);
                console.log(this.requestDinamyc)
                if (!this.requestDinamyc.type) { // Si no hay un id en especifico para buscar se mostrará un modal que diciendo que solo es fase de pruebas
                    // this.lastSubStage = true
                    this.dialogDemoProcess = true
                }

            } catch (error) {
                const message = 'Error al procesar datos en componente de procesos1 ';
                this.showError({ message, error });
            }
        },
        cancelAction() {
            alert('click finalizar');
        },

        async confirmAction() {
            // this.$emit('confirm');
            try {
                console.log('****************this.SubStage*****************')
                // console.log(this.SubStage)
                let sendNewSubStage = {
                    "type": this.requestDinamyc.type,
                    "idOfType": this.requestDinamyc.idOfType,
                    // [this.iidProperties[this.requestDinamyc.type]]: this.requestDinamyc.idOfType,
                    "iidetapa_anterior": this.currentFlow.currentSubStage.iidetapa,
                    "iidsubetapa_anterior": this.currentFlow.currentSubStage.iidsubetapa,
                    "iidetapa_nueva": this.currentFlow.nextSubStage.iidetapa,
                    "iidsubetapa_nueva": this.currentFlow.nextSubStage.iidsubetapa,
                };
                let updateInspectorSubStage = await services.inspections().newDinamycSubStage(sendNewSubStage);
                console.log(updateInspectorSubStage)
                this.requestDinamyc.idOfSubStage = updateInspectorSubStage.info
                await this.loadFlowData();

            } catch (error) {
                const message = 'Error al guardar inspector.';
                this.showError({ message, error });
            }

        },
        showAlertFinalize() {
            alert('Se acabó el proceso completo, procede a guardar último')
            this.$emit('confirm');
        },
        cancel() {
            // Lógica para cancelar la operación actual
        },
        // EMITIR A COMPONENTE PADRE
        emitToParentComponent() {
            console.log('🚀 ~ emitToParentComponent ~ 🚀 sending editing mode, generalPersonData, validation 🚀')
            console.log('******************generic process flow to emit parent***********************')
            console.log(this.emitResponse)
            this.$emit('process-flow', this.emitResponse);
        },
        convertToTreeStructure(etapas) {
            return etapas.map(etapa => {
                console.log('-----etapa----');
                console.log(etapa);
                return {
                    id: etapa.iidetapa,
                    name: `Etapa: ${etapa.nombre_etapa} -- ${etapa.iidetapa}`,
                    children: (etapa.subStages || []).map(subEtapa => {
                        console.log('-----subEtapa----');
                        console.log(subEtapa);
                        let dinamycIcon = ''
                        if (subEtapa.historicStatus == "pendiente") {
                            dinamycIcon = 'mdi-checkbox-blank-circle-outline'

                        }
                        if (subEtapa.historicStatus == "actualmente") {
                            dinamycIcon = 'mdi-check-circle'

                        }
                        if (subEtapa.historicStatus == "pasado") {
                            dinamycIcon = 'mdi-checkbox-blank-circle'

                        }
                        return {
                            id: `${etapa.iidetapa}.${subEtapa.iidsubetapa}`,
                            name: `SubEtapa: ${subEtapa.txtnombre}-- ${etapa.iidetapa}.${subEtapa.iidsubetapa}`,
                            icon: dinamycIcon
                        };
                    })
                };
            });
        },
    },
    watch: {
        'request': async function () {
            console.log('cambio en la solicitud de procesos: ')
            if (this.request.idOfType && this.request.type) {
                console.log('Leyendo: ')
                this.requestDinamyc = this.request
                await this.loadFlowData();
            }
        }
    },
    async mounted() {
        console.log('cargando')
        this.requestDinamyc = this.request
        await this.loadFlowData();

    }

};
</script>
