<template>
    <div style="width: 100%">
        <tickets-datatable-dialogs ref="dialogs" />
        <div class="row mx-2 my-3">
            <p class="col-md-12 primary--text text-h6 text-md-center  mb-3 py-1">PROCESO: <span class="text-h10"
                    style="color: #000;">{{ allFlow.txtnombre }}</span></p>
            <p class="col-md-6 primary--text text-h6 text-md-center  mb-0 py-1">ETAPA ACTUAL: <span class="text-h10"
                    style="color: #000;">
                    {{ currentFlow.currentSubStage.etapa_nombre }}</span></p>
            <div class="col-md-3 d-md-flex   py-1">
                <v-btn class="mx-auto" v-if="request.idOfType" style="max-width: 200px" color="info"
                    @click="dialogRequestTrace = true">Seguimiento</v-btn>
            </div>
            <div class="col-md-3 d-md-flex  py-1">
                <v-btn class="mx-auto" v-if="request.idOfType && currentFlow.currentSubStage.txtsigla === 'EBIN'"
                    style="max-width: 200px" color="primary" @click="dialogShowBoletas = true">Boleta</v-btn>
            </div>
        </div>
        <template>
            <v-stepper v-model="steepSubStage" vertical>
                <v-stepper-step complete editable step="1">
                    {{ currentFlow.currentSubStage.subetapa_nombre }} ({{ currentFlow.currentSubStage.txtsigla }})
                    <span
                        v-if="currentFlow.currentSubStage.iidetapa != currentFlow.nextSubStage.iidetapa && !!currentFlow.nextSubStage.iidetapa">
                        <i style="color: orange;" aria-hidden="true"
                            class="v-icon notranslate mdi mdi-alert theme--light"></i> Pasára a la siguiente etapa
                    </span>
                </v-stepper-step>


                <v-stepper-content step="1">
                    <div height="100px" style="max-width: 90%; margin: 0 auto;">
                        <div :style="'background-color: ' + (currentFlow.currentSubStage.txtcolor !== '' ? currentFlow.currentSubStage.txtcolor : 'gray')"
                            class="mb-6 d-flex align-center justify-center py-2 px-2"
                            style="color: white; font-weight: bold; font-size: 16px;margin-bottom: 1rem !important;">
                            Descripción: {{ currentFlow.currentSubStage.txtdescripcion }}
                        </div>
                        <div v-if="currentFlow.nextSubStage.length">
                            <v-btn color="primary" @click="verifyNextSubStage()">Siguiente</v-btn>
                            <v-btn text @click="cancelAction">Cancelar</v-btn>
                        </div>
                    </div>
                </v-stepper-content>
                <div v-if="currentFlow.nextSubStage.length === 1">
                    <v-stepper-step step="2">
                        {{ currentFlow.nextSubStage[0].subetapa_nombre }} ({{ currentFlow.nextSubStage[0].txtsigla }} -
                        {{ currentFlow.nextSubStage[0].txtdescripcion }})
                    </v-stepper-step>

                    <v-stepper-content step="2" class="step_two">
                        <div>
                            <!-- <div :style="'background-color: ' + (currentFlow.nextSubStage[0].txtcolor !== '' ? currentFlow.nextSubStage[0].txtcolor : 'gray')" -->
                            <div :style="'background-color: gray'" class="mb-6 d-flex align-center justify-center py-2 px-1"
                                style="color: white; font-weight: bold; font-size: 16px;margin-bottom: 1rem !important;">
                                Descripción: {{ currentFlow.nextSubStage[0].txtdescripcion }}
                            </div>
                        </div>
                        <div>
                            <!-- <v-btn color="primary" @click="showAlertFinalize()">Ya no existe flujo posterior</v-btn> -->
                            Sin acciones por el momento | contacte al administrador)
                        </div>
                    </v-stepper-content>
                </div>
                <div v-if="currentFlow.nextSubStage.length > 1">
                    <v-stepper-step step="2">
                        Bifurcación de proceso
                    </v-stepper-step>

                    <v-stepper-content step="2" class="step_two" style="">
                        <div height="100px" style="">
                            <div :style="'background-color: gray;'" class="mb-6 d-flex align-center justify-center py-2"
                                style="color: white; font-weight: bold; font-size: 16px;margin-bottom: 1rem !important;">
                                Debe seleccionar la opción siguiente para ver los flujos disponibles
                            </div>
                            <div>
                                Sin acciones por el momento2
                            </div>
                        </div>
                    </v-stepper-content>
                </div>
            </v-stepper>
        </template>

        <!-- DIALOG CONFIRMATION NEXT SUB STAGE -->
        <generic-dialog :dialogVisible="dialogRequestTrace" dialogTitle="Visualizar seguimiento"
            @update:dialogVisible="dialogRequestTrace = $event" @confirm="dialogRequestTrace = false">
            <template v-slot:default>
                Movimientos en el flujo: {{ allFlow.txtnombre }}
                <template>
                    <v-treeview :items="treeData" :expanded.sync="expandedItems" activatable color="primary" transition
                        open-all open-on-click>
                        <template v-slot:prepend="{ item }">
                            <v-icon v-if="item.icon" color="primary">{{ item.icon }}</v-icon>
                        </template>
                    </v-treeview>
                </template>
            </template>
        </generic-dialog>

        <!-- DIALOG INFO BOLETA -->
        <generic-dialog :dialogVisible="dialogShowTicket" dialogTitle="Visualizar boleta"
            @update:dialogVisible="dialogShowTicket = $event" @confirm="dialogShowTicket = false">
            <template v-slot:default>
                Fecha: {{ ticket.dtfecha_hora_infraccion }}
                Nombre de infractor: {{ ticket.nombre_infractor }}
                Nombre de empleado: {{ ticket.nombre_empleado }}
                <!-- <template>
                    <v-treeview :items="treeData" :expanded.sync="expandedItems" activatable color="primary" transition
                        open-all open-on-click>
                        <template v-slot:prepend="{ item }">
                            <v-icon v-if="item.icon" color="primary">{{ item.icon }}</v-icon>
                        </template>
                    </v-treeview>
                </template> -->
            </template>
        </generic-dialog>

        <generic-dialog :dialogVisible="dialogDemoProcess" dialogTitle="Parámetros faltantes"
            @update:dialogVisible="dialogDemoProcess = $event" @confirm="dialogDemoProcess = false">
            <template v-slot:default>
                Existen parámetros que no se han enviado o que no han sido configurados, favor de contactar al
                administrador.
            </template>
        </generic-dialog>

        <generic-dialog :dialogVisible="dialogVerifyNextSubStage" dialogTitle="Cambio en el proceso"
            @update:dialogVisible="dialogVerifyNextSubStage = $event" @confirm="confirmAction">
            <template v-slot:default>
                Estos cambios son irreversibles. ¿Desea continuar con el proceso?
            </template>
        </generic-dialog>


        <generic-dialog :dialogVisible="dialogShowBoletas" dialogTitle="Boletas" :maxWidth=700
            @update:dialogVisible="dialogShowBoletas = $event">
            <template v-slot:default>
                <v-tabs vertical>
                    <v-tab >
                        <v-icon left>
                            mdi-account
                        </v-icon>
                        <div v-if="!isSmallScreen">Crear</div>
                    </v-tab>
                    <v-tab >
                        <v-icon left>
                            mdi-lock
                        </v-icon>
                        <div v-if="!isSmallScreen">Generadas</div>
                    </v-tab>
                    <v-tab-item>
                        <v-card flat>
                            <v-card-text>
                                <div>Aca sería el formulario</div>
                            </v-card-text>
                        </v-card>
                    </v-tab-item>
                    <v-tab-item>
                        <v-card flat>
                            <v-card-text>
                                Boletas generadas por inspector
                                <!-- TABLA DE BOLETAS -->
                                <v-data-table :headers="headersTblBoleta" :items="itemsDemo">
                                    <template v-slot:item.bactual="{ item }">
                                        <v-icon v-show="item.bactual" size="medium" color="green">mdi-check</v-icon>
                                        <v-icon v-show="!item.bactual" size="medium" color="red">mdi-close</v-icon>
                                    </template>
                                    <template v-slot:item.actions="{ item }">
                                        <div style="min-width: 85px;">
                                            <v-tooltip bottom>
                                                <template v-slot:activator="{ on, attrs }">
                                                    <v-btn v-bind="attrs" v-on="on" icon small
                                                        @click="showTicket(item)">
                                                        <v-icon small>mdi-eye</v-icon>
                                                    </v-btn>
                                                </template>
                                                <span>Seleccionar</span>
                                            </v-tooltip>
                                        </div>
                                    </template>
                                </v-data-table>


                            </v-card-text>
                        </v-card>
                    </v-tab-item>

                </v-tabs>



            </template>
        </generic-dialog>

        <generic-dialog :dialogVisible="dialogBifurcation" dialogTitle="Bifurfación de proceso"
            @update:dialogVisible="dialogBifurcation = $event">
            <template v-slot:default>
                En el proceso de esta sub etapa existen diferentes flujos, favor de seleccionar uno
                <!-- TABLA DE BIFURCACIÓN -->
                <v-data-table :headers="headers" :items="currentFlow.nextSubStage">
                    <template v-slot:item.bactual="{ item }">
                        <v-icon v-show="item.bactual" size="medium" color="green">mdi-check</v-icon>
                        <v-icon v-show="!item.bactual" size="medium" color="red">mdi-close</v-icon>
                    </template>
                    <template v-slot:item.actions="{ item }">
                        <div style="min-width: 85px;">
                            <v-tooltip bottom>
                                <template v-slot:activator="{ on, attrs }">
                                    <v-btn v-bind="attrs" v-on="on" icon small
                                        @click="confirmNextSubStageOfBifurcation(item.iidetapa, item.iidsubetapa)">
                                        <v-icon small>mdi-check</v-icon>
                                    </v-btn>
                                </template>
                                <span>Seleccionar</span>
                            </v-tooltip>
                        </div>
                    </template>
                </v-data-table>
            </template>
        </generic-dialog>
    </div>
    <!-- </div> -->
</template>
<style>
.v-stepper__wrapper div {
    height: auto !important;
}

.v-stepper__content {
    margin: 0 !important;
    padding: 0 !important;
}

/* Estilos personalizados para el icono */
.v-treeview-node__label {
    display: flex;
    align-items: center;
}

.v-treeview-node__prepend {
    margin-right: 8px;
}

.step_two .v-stepper__wrapper {
    height: 120px !important;
    max-width: 90%;
    margin: 0 auto;
}
</style>

<script>
import services from "@/services";
import GenericDialog from '@/components/common/GenericDialog.vue';
import TicketsDatatableDialogs from "@/pages/inspections/tickets/components/TicketsDatatableDialogs";
import { mapActions } from "vuex";
export default {
    components: {
        GenericDialog,
        TicketsDatatableDialogs,
    },
    data() {
        return {
            tab: 'crear',
            activeStep: 0,
            // activeStep: -1,
            // activeStep: null,
            steepSubStage: 1,
            traceOfRequest: 2,
            switch1: false,
            ticket: [],
            requestDinamyc: {
                type: '', //type-dinamyc
                idOfType: 0, //iid-dinamyc
                idOfSubStage: 0, //iidsubStage
                idOfNextSubStage: 0, //iidsubStage
                finalizeProcess: false,
            },
            headers: [
                // { text: 'ID', value: 'id' },
                { text: 'Nombre', value: 'subetapa_nombre' },
                { text: 'Sigla', value: 'txtsigla' },
                { text: 'Descripción', value: 'txtdescripcion' },
                { text: 'Acciones', value: 'actions' }
            ],
            headersTblBoleta: [
                // { text: 'ID', value: 'id' },
                { text: 'Infractor', value: 'nombre_infractor' },
                { text: 'Acciones', value: 'actions' }
            ],
            itemsDemo: [
                // { nombre_completo: 'Ejemplo 1', bactual: true },
                // { nombre_completo: 'Ejemplo 2', bactual: false },
            ],
            isSmallScreen: false,
            // iidProperties: {
            //     'Inspector': 'iidinspector',
            //     'Boleta': 'iidboleta',
            // },
            dialogVerifyNextSubStage: false,
            dialogBifurcation: false,
            dialogShowBoletas: false,
            dialogShowTicket: false,
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
        showTicket(ticket){
            this.ticket = ticket
            // this.dialogShowTicket = true
            this.$refs.dialogs.ticket = ticket;
            this.$refs.dialogs.viewTicket();
            this.$refs.dialogs.show['view'] = true;
            console.log(ticket)
        },
        verifyNextSubStage() {
            console.log(this.currentFlow.nextSubStage)
            if (this.currentFlow.nextSubStage.length === 1) {
                this.dialogVerifyNextSubStage = true
            } else if (this.currentFlow.nextSubStage.length > 1) {
                this.dialogBifurcation = true
            }
        },
        async loadFlowData() {
            try {
                console.log('this.requestDinamyc');
                console.log(this.requestDinamyc);
                let allInfo = await services.admin().getInfoBySubStage(this.requestDinamyc);
                console.log('*******************allInfo*******');
                console.log(allInfo);
                this.itemsDemo = allInfo.boletas
                this.allFlow = allInfo.allFlow
                this.currentFlow = allInfo.currentFlow
                this.followUp = allInfo.followUp
                this.treeData = allInfo.allFlow.etapas.info2
                // this.treeData = this.convertToTreeStructure(allInfo.allFlow.etapas);
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
        async confirmNextSubStageOfBifurcation(iidetapa, iidsubetapa) {
            console.log('nextStage; ' + iidetapa)
            console.log('nextSubStage; ' + iidsubetapa)
            console.log('ORIGINAL; ')
            console.log(this.currentFlow.nextSubStage)
            this.currentFlow.nextSubStage[0].iidetapa = iidetapa
            this.currentFlow.nextSubStage[0].iidsubetapa = iidsubetapa
            console.log('Modiifiica; ')
            console.log(this.currentFlow.nextSubStage)
            await this.confirmAction()
            this.dialogBifurcation = false
        },

        async confirmAction() {
            // this.$emit('confirm');
            try {
                console.log('***************Confirm action*****************')
                // console.log(this.SubStage)
                let sendNewSubStage = {
                    "type": this.requestDinamyc.type,
                    "idOfType": this.requestDinamyc.idOfType,
                    // [this.iidProperties[this.requestDinamyc.type]]: this.requestDinamyc.idOfType,
                    "iidetapa_anterior": this.currentFlow.currentSubStage.iidetapa,
                    "iidsubetapa_anterior": this.currentFlow.currentSubStage.iidsubetapa,
                    "iidetapa_nueva": this.currentFlow.nextSubStage[0].iidetapa,
                    "iidsubetapa_nueva": this.currentFlow.nextSubStage[0].iidsubetapa,
                };
                console.log('let sendNewSubStage')
                console.log(sendNewSubStage)
                let message = ''
                if (!this.demo) {

                    let updateInspectorSubStage = await services.admin().newDinamycSubStage(sendNewSubStage);
                    console.log('response updateInspectorSubStage')
                    console.log(updateInspectorSubStage)
                    this.requestDinamyc.idOfSubStage = updateInspectorSubStage.info
                    message = 'Actualización de proceso exitosa.';
                } else {
                    this.requestDinamyc.idOfSubStage = this.currentFlow.nextSubStage[0].iidsubetapa
                    message = 'Actualización de proceso exitosa.';

                }
                await this.loadFlowData();

                this.showSuccess(message);

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
                // console.log('-----etapa----');
                // console.log(etapa);
                return {
                    id: etapa.iidetapa,
                    name: `Etapa: ${etapa.nombre_etapa} -- ${etapa.iidetapa}`,
                    children: (etapa.subStages || []).map(subEtapa => {
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
        checkScreenSize() {
            this.isSmallScreen = window.innerWidth < 600; // Definir el ancho de la pantalla que consideras como "pequeño"
        },
    },
    beforeDestroy() {
        window.removeEventListener('resize', this.checkScreenSize);
    },
    watch: {
        'request': async function () {
            console.log('cambio en la solicitud de procesos: ')
            if (this.request.idOfType && this.request.type) {
                console.log('Leyendo: ')
                this.requestDinamyc = this.request
                await this.loadFlowData();
                this.demo = false
            }
        },
        'dialogShowTicket': async function () {
            if (this.dialogShowTicket) {
                this.dialogShowBoletas = false

            }else{
                this.dialogShowBoletas = true
            }
        },
    },
    async mounted() {
        console.log('cargando')
        window.addEventListener('resize', this.checkScreenSize);
        this.checkScreenSize();
        this.requestDinamyc = this.request
        await this.loadFlowData();

    }

};
</script>
