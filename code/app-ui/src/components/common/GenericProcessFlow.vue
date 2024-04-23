<template>
    <div>
        <div class="row">
            <p class="col-md-12 primary--text text-h6 text-center">PROCESO: <span class="text-h10"
                    style="color: #000;">{{ process.txtnombre }}</span></p>
            <p class="col-md-8 primary--text text-h6">ETAPA: <span class="text-h10" style="color: #000;">{{
                        currentSubStage.nombre_etapa }}</span></p>
            <div class="col-md-4" v-if="request.idOfSearch">
                <v-btn color="primary" @click="dialogRequestTrace = true">Seguimiento del proceso</v-btn>
            </div>
        </div>


        <template>
            <v-stepper v-model="steepSubStage" vertical>
                <v-stepper-step step="1" complete>
                    {{ currentSubStage.nombre_subetapa_actual }}
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
                            {{ currentSubStage.descripcion_subetapa_actual }}
                        </div>
                    </div>
                    <div v-if="!lastSubStage">
                        {{ hasFlowAfter }}
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
                Aca va el seguimiento
                <template>
                    <v-stepper v-model="traceOfRequest" vertical>
                        <v-stepper-step step="1" complete>
                            Name of step 1
                        </v-stepper-step>
    
                        <v-stepper-content step="1">
                            <v-card color="grey lighten-1" class="mb-12" height="200px"></v-card>
                            <v-btn color="primary" @click="traceOfRequest = 2">
                                Continue
                            </v-btn>
                            <v-btn text>
                                Cancel
                            </v-btn>
                        </v-stepper-content>
    
                        <v-stepper-step step="2" complete>
                            Name of step 2
                        </v-stepper-step>
    
                        <v-stepper-content step="2">
                            <v-card color="grey lighten-1" class="mb-12" height="200px"></v-card>
                            <v-btn color="primary" @click="traceOfRequest = 3">
                                Continue
                            </v-btn>
                            <v-btn text>
                                Cancel
                            </v-btn>
                        </v-stepper-content>
    
                        <v-stepper-step :rules="[() => false]" step="3">
                            Ad templates
                            <small>Alert message</small>
                        </v-stepper-step>
    
                        <v-stepper-content step="3">
                            <v-card color="grey lighten-1" class="mb-12" height="200px"></v-card>
                            <v-btn color="primary" @click="traceOfRequest = 4">
                                Continue
                            </v-btn>
                            <v-btn text>
                                Cancel
                            </v-btn>
                        </v-stepper-content>
    
                        <v-stepper-step step="4">
                            View setup instructions
                        </v-stepper-step>
    
                        <v-stepper-content step="4">
                            <v-card color="grey lighten-1" class="mb-12" height="200px"></v-card>
                            <v-btn color="primary" @click="traceOfRequest = 1">
                                Continue
                            </v-btn>
                            <v-btn text>
                                Cancel
                            </v-btn>
                        </v-stepper-content>
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
            console.log(this.iidsubStage)
            let last = await services.inspections().getInfoBySubStage({ iidsubStage: this.iidsubStage });
            let currentSubStage = await services.inspections().getAllFlowBySubStage({ iidsubStage: this.iidsubStage });
            if (last && !currentSubStage) { // VERIFICAMOS QUE EXISTE UN FLUJO DESPUÉS, EN CASO DE QUE NO EXISTA SIGNIFICA EL FIN DEL FLUJO CAPTURADO
                this.lastSubStage = true
            }
            if (this.lastSubStage) {
                this.currentSubStage = last
            } else {
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
        'request': function () {
            console.log('cambio en la solicitud de seguimiento: ')
            console.log(this.request)
            if (this.request.idOfSearch) {
                if (this.request.type == 'Inspector') {
                    this.loadData();
                }
            }
        }
    },
    async mounted() {
        await this.loadData();

    }

};
</script>
