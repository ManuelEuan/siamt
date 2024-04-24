<template>
    <div>
        <div class="row">
            <p class="col-md-12 primary--text text-h6 text-center">PROCESO: <span class="text-h10"
                    style="color: #000;">{{ process.txtnombre }}</span></p>
            <p class="col-md-8 primary--text text-h6">ETAPA ACTUAL: <span class="text-h10" style="color: #000;">{{
                        currentSubStage.nombre_etapa }}</span></p>
            <div class="col-md-4" v-if="request.idOfSearch">
                <v-btn color="primary" @click="dialogRequestTrace = true">Seguimiento del proceso</v-btn>
            </div>
        </div>



        <template>
            <v-stepper v-model="steepSubStage" vertical>
                <v-stepper-step complete editable step="1">
                    {{ currentSubStage.nombre_subetapa_actual }} ({{ currentSubStage.sigla_subetapa_actual }})
                    <span
                        v-if="currentSubStage.iidetapa_subetapa_actual != currentSubStage.iidetapa_subetapa_siguiente">
                        <i style="color: orange;" aria-hidden="true"
                            class="v-icon notranslate mdi mdi-alert theme--light"></i> Pasára a la siguiente etapa
                    </span>
                </v-stepper-step>

                <v-stepper-content step="1">
                    <div height="100px">
                        <div :style="'background-color: ' + (currentSubStage.color_subetapa_actual !== '' ? currentSubStage.color_subetapa_actual : 'gray')"
                            class="mb-6 d-flex align-center justify-center py-2"
                            style="color: white; font-weight: bold; font-size: 16px;margin-bottom: 1rem !important;">
                            Descripción: {{ currentSubStage.descripcion_subetapa_actual }}
                        </div>
                    </div>
                    <div v-if="!lastSubStage">
                        <v-btn color="primary" @click="confirmAction">Siguiente</v-btn>
                        <v-btn text @click="cancelAction">Cancelar</v-btn>
                    </div>
                    <div v-else>
                        <v-btn color="primary" @click="showAlertFinalize()">Finalizar</v-btn>
                    </div>
                </v-stepper-content>

                <v-stepper-step step="2" v-if="!lastSubStage">
                    {{ currentSubStage.nombre_subetapa_siguiente }}
                </v-stepper-step>

                <v-stepper-content step="2" v-if="!lastSubStage">
                    <v-card
                        :style="'background-color: ' + (currentSubStage.color_subetapa_siguiente !== '' ? currentSubStage.color_subetapa_siguiente : 'gray')"
                        class="mb-6 d-flex align-center justify-center" height="200px">
                        {{ currentSubStage.descripcion_subetapa_siguiente }}
                    </v-card>
                </v-stepper-content>
            </v-stepper>
        </template>
        <!-- DIALOG CONFIRMATION NEXT SUB STAGE -->
        <generic-dialog :dialogVisible="dialogRequestTrace" dialogTitle="Visualizar seguimiento"
            @update:dialogVisible="dialogRequestTrace = $event" @confirm="dialogRequestTrace = false">
            <template v-slot:default>
                <template>
                    <v-stepper v-if="dinamycTrace.length > 1" vertical style="padding-bottom: .5rem !important">
                        <template v-for="(item, index) in dinamycTrace">
                            <v-stepper-step :key="item.iidinspector_seguimiento" :step="index"
                                v-if="item.iidsubetapa_anterior != item.iidsubetapa_actual"
                                :complete="isStepComplete(index)">
                                <!-- {{ 'Step ' + (index + 1) }} -->
                                {{ 'Subetapa capturada ' + (index) }}: {{ item.nombre_subetapa_anterior }}
                            </v-stepper-step>
                            <!-- <v-stepper-content :key="'content_' + item.iidinspector_seguimiento" :step="index + 1"
                                style="height: auto !important;">
                            </v-stepper-content> -->
                        </template>
                    </v-stepper>
                    <v-stepper v-else vertical style="padding: .5rem !important">
                        <template v-for="(item) in dinamycTrace">
                            <v-stepper-step :key="item.iidinspector_seguimiento" complete editable step="1">
                                {{ 'Subetapa actual ' + (1) }}: {{ item.nombre_subetapa_anterior }}
                            </v-stepper-step>
                            <!-- <v-stepper-content :key="'content_' + item.iidinspector_seguimiento" :step="index + 1"
                                style="height: auto !important;">
                            </v-stepper-content> -->
                        </template>
                    </v-stepper>
                </template>
            </template>
        </generic-dialog>
    </div>
    <!-- </div> -->
</template>
<style>
.v-stepper__wrapper div {
    height: auto !important;
}
</style>

<script>
import services from "@/services";
import GenericDialog from '@/components/common/GenericDialog.vue';
// import { mapActions } from "vuex";
export default {
    components: {
        GenericDialog,
    },
    data() {
        return {
            process: [],
            currentSubStage: [],
            foundSubStage: false,
            steepSubStage: 1,
            iidproceso: 0,
            hasFlowAfter: false,
            lastSubStage: false,
            traceOfRequest: 2,
            dinamycTrace: [],
            switch1: false,

            // DIALOGS
            dialogRequestTrace: false,

        }
    },
    props: {
        iidsubStage: {
            type: Number,
            required: true
        },
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
                    type: '',
                    idOfSearch: 0,
                }; // Objeto vacío como valor predeterminado
            }
        },

    },
    methods: {
        async loadData() {
            try {
                let last = await services.inspections().getInfoBySubStage({ iidsubStage: this.iidsubStage });
                let currentSubStage = await services.inspections().getAllFlowBySubStage({ iidsubStage: this.iidsubStage });
                console.log('load DATA PROCESS')
                console.log(last)
                console.log(currentSubStage)
                if (last && !currentSubStage) { // VERIFICAMOS QUE EXISTE UN FLUJO DESPUÉS, EN CASO DE QUE NO EXISTA SIGNIFICA QUE ES LA ETAPA FINAL LA QUE SE CAPTURARA
                    this.lastSubStage = true

                }
                if (this.lastSubStage) {
                    this.currentSubStage = last
                } else { // SI EXISTE FLUJO SE ASIGNAN NORMAL LAS SUBETAPAS
                    this.currentSubStage = currentSubStage
                }
                // SI EXISTE LA SUBETAPA BUSCADA SE ASIGNAN VALORES Y SE EMITEN AL COMPONENTE PADRE
                if (this.currentSubStage) {
                    this.iidproceso = this.currentSubStage.iidproceso
                    this.foundSubStage = true
                    this.process = await services.inspections().getInfoProcess({ iidproceso: this.iidproceso })
                    this.steepSubStage = 1
                    this.hasFlowAfter = await services.inspections().hasFlowAfter({ iidsubetapa: this.currentSubStage.iidsubetapa_siguiente })
                    this.$emit('process-flow', this.foundSubStage, this.currentSubStage, this.process, this.hasFlowAfter);
                    if (this.request.idOfSearch && this.request.type) {
                        console.log('cambio en la solicitud de seguimiento actualizada: ')
                        console.log(this.request)
                        this.getDinamycTrace()
                    }
                }
            } catch (error) {
                const message = 'Error al procesar datos en componente de procesos ';
                this.showError({ message, error });
            }
        },
        cancelAction() {
            alert('click finalizar');
        },
        confirmAction() {
            this.$emit('confirm');
        },
        showAlertFinalize() {
            alert('Se acabó el proceso completo, procede a guardar último')
            this.$emit('confirm');
        },
        isStepComplete(index) {
            console.log('click a la sub etapa: ' + index)
            // Aquí puedes agregar lógica para determinar si un paso está completo o no, según tus necesidades
            // Por ejemplo, podrías revisar si los datos de un paso específico están presentes o si se ha completado alguna acción relacionada con ese paso
            return true; // Devuelve true si el paso está completo
        },
        // nextStep(step) {
        //     // Lógica para avanzar al siguiente paso
        //     this.traceOfRequest = step + 1; // Avanza al siguiente paso
        // },
        cancel() {
            // Lógica para cancelar la operación actual
        },
        async getDinamycTrace() {
            try {
                this.dinamycTrace = await services.inspections().getDinamycTrace({ request: this.request })
                console.log(this.dinamycTrace)
            } catch (error) {
                const message = 'Error al procesar datos en componente de procesos ';
                this.showError({ message, error });
            }

        }
    },
    watch: {
        'iidsubStage': function () {
            console.log('recibido: ' + this.iidsubStage)
            this.loadData()
        },
        'steepSubStage': function () {
            console.log('cambio desde generic proccess flow')
            console.log(this.steepSubStage)
            console.log(this.iidsubStage)
            // this.$emit('process-flow-next-substage', this.currentSubStage.iidsubetapa_siguiente);
            // if (this.steepSubStage != this.iidsubStage) {
            // }
        },
        'finalizeProcess': function () {
            if (this.finalizeProcess) {
                this.lastSubStage = true
            }
        },
        'request': async function () {
            if (this.request.idOfSearch && this.request.type) {
                console.log('cambio en la solicitud de seguimiento: ')
                console.log(this.request)
                this.getDinamycTrace()
            }

        }
    },
    async mounted() {
        await this.loadData();

    }

};
</script>
