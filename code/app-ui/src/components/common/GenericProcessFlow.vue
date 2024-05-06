<template>
    <div>
        {{ request }}
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
                        <v-btn color="primary" @click="confirmAction">Siguiente</v-btn>
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
                dos
                <!-- {{ allFlow.etapas }} -->
                <!-- <template>
                    <v-stepper v-model="activeStep" vertical>
                        <v-stepper-step v-for="(etapa, index) in allFlow.etapas" :key="index"
                            :complete="index < activeStep" :step="index + 1" :editable="false"
                            @click="activeStep = index">
                            {{ etapa.nombre_etapa }}
                        </v-stepper-step>
                    </v-stepper>
                </template> -->
                tres
                <!-- <template>
                    <v-stepper v-model="activeStep" vertical>
                        <v-stepper-step v-for="(etapa, index) in allFlow.etapas" :key="index" :step="index + 1"
                            :editable="false" @click="toggleStep(index)">
                            {{ etapa.nombre_etapa }}
                            <template v-if="activeStep === index">
                                <v-divider></v-divider>
                                <v-list>
                                    <v-list-item v-for="(subEtapa, subIndex) in etapa.subStages" :key="subIndex">
                                        <v-list-item-content>{{ subEtapa.txtnombre }}</v-list-item-content>
                                    </v-list-item>
                                </v-list>
                            </template>
                        </v-stepper-step>
                    </v-stepper>
                </template> -->
                {{ treeData }}
                <template>
                    <!-- <v-treeview :items="treeData" activatable :active.sync="activeItem"></v-treeview> -->
                    <!-- open-on-click -->
                    <!-- <v-treeview :items="treeData" :expanded.sync="expandedItems" activatable  color="primary"
                    transition open-all
                        :active.sync="activeItem"></v-treeview> -->
                    <v-treeview :items="treeData" :active.sync="activeItem" :expanded.sync="expandedItems" activatable
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
            activeItem: [0],
            // activeItem: [
            //     0, // Activa el primer elemento del arreglo (primer hijo del primer elemento)
            //     5, // Activa el segundo elemento del arreglo (segundo hijo del segundo elemento)
            // ],
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

                // this.currentSubStage = allInfo.current
                // this.process = await services.inspections().getInfoProcess({ iidproceso: allInfo.current.iidproceso })
                // console.log('load DATA PROCESS')
                // this.emitResponse= { //DEMO
                //     foundSubStage: true, // Encontrado
                //     currentSubStage: this.currentSubStage, // iidsubStage all data
                //     process: this.process, // process all data
                //     hasFlowAfter: this.hasFlowAfter, // continua proceso
                // },
                // this.emitToParentComponent()

            } catch (error) {
                const message = 'Error al procesar datos en componente de procesos1 ';
                this.showError({ message, error });
            }
        },
        cancelAction() {
            alert('click finalizar');
        },

        // RETORNO DE COMPONENTE GENÉRICO PROCESS FLOW (CLICK EN BUTTON)
        async getNextSubStage() {
            // try {
            //     console.log('****************this.SubStage*****************')
            //     console.log(this.SubStage)
            //     let dataNextSubStage = {
            //         "iidinspector": this.inspector.iidinspector,
            //         "iidetapa": this.SubStage.info.iidetapa_subetapa_siguiente,
            //         "iidsubetapa": this.SubStage.info.iidsubetapa_siguiente,
            //     }
            //     let dataTrace = {
            //         "iidinspector": this.inspector.iidinspector,
            //         "iidetapa_anterior": this.SubStage.info.iidetapa_subetapa_actual,
            //         "iidsubetapa_anterior": this.SubStage.info.iidsubetapa_actual,
            //         "iidetapa_actual": this.SubStage.info.iidetapa_subetapa_siguiente,
            //         "iidsubetapa_actual": this.SubStage.info.iidsubetapa_siguiente,
            //     }

            //     let updateInspectorSubStage = await services.inspections().updateInspectorSubStage(dataNextSubStage);
            //     console.log('updateInspectorSubStage')
            //     console.log(updateInspectorSubStage)
            //     console.log(dataNextSubStage)
            //     let insertInspectorTrace = await services.inspections().insertInspectorTrace({ dataTrace });
            //     console.log('insertInspectorTrace')
            //     console.log(insertInspectorTrace)
            //     console.log(dataTrace)

            //     if (updateInspectorSubStage.success && insertInspectorTrace.success) {
            //         this.inspector.iidsubetapa = this.SubStage.info.iidsubetapa_siguiente
            //         let message = 'Etapa actualizada'
            //         this.showSuccess(message);
            //     }
            //     if (!this.SubStage.hasFlowAfter) {
            //         // Si no existe una sub etapa que tenga flujo posterior significa que será el ultimo cambio posible del proceso
            //         this.finalizeProcess = true
            //     }

            // } catch (error) {
            //     const message = 'Error al guardar inspector.';
            //     this.showError({ message, error });
            // }

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
                // this.requestDinamyc = {
                //     type: '', //type-dinamyc
                //     idOfType: 0, //iid-dinamyc
                //     idOfSubStage: 0, //iidsubStage
                //     idOfNextSubStage: 0, //iidsubStage
                //     finalizeProcess: false,
                // }
                
                // console.log(this.request)
                // console.log(this.requestDinamyc)
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
            console.log('-----etapas----');
            console.log(etapas);
            // console.log(`${this.currentFlow.currentSubStage.iidetapa}.${this.currentFlow.currentSubStage.iidsubetapa}`);
            return etapas.map(etapa => ({
                id: etapa.iidetapa,
                name: `Etapa: ${etapa.nombre_etapa} -- ${etapa.iidetapa}`,
                children: (etapa.subStages || []).map(subEtapa => ({
                    id: `${etapa.iidetapa}.${subEtapa.iidsubetapa}`,
                    name: `SubEtapa: ${subEtapa.txtnombre}-- ${etapa.iidetapa}.${subEtapa.iidsubetapa}`,
                    // icon: 'mdi-check-circle' 
                    // icon: 'mdi-checkbox-blank-circle'
                    icon: 'mdi-checkbox-blank-circle-outline'


                }))
            }));
        },

        toggleStep(index) {
            this.activeStep = (this.activeStep === index) ? null : index;
        }
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
        // console.log(this.request)
        // console.log(this.requestDinamyc)
        await this.loadFlowData();

    }

};
</script>
