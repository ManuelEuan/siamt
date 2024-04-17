<template>
    <div>
        <p class="primary--text text-h6">PROCESO: <span class="text-h10" style="color: #000;">{{ process.txtnombre }}</span></p>
        <p class="primary--text text-h6">ETAPA: <span class="text-h10" style="color: #000;">{{ currentSubStage.nombre_subetapa_actual }}</span></p>
        <p v-if="currentSubStage.iidetapa_subetapa_actual != currentSubStage.iidetapa_subetapa_siguiente" class="primary--text text-h6 py-2">ETAPA: <span class="text-h10" style="color: #000;">{{ currentSubStage.nombre_subetapa_actual }}</span></p>

        <template>
            <v-stepper v-model="steepSubStage" vertical>
                <v-stepper-step step="1" complete>
                    {{currentSubStage.nombre_subetapa_actual}}
                </v-stepper-step>

                <v-stepper-content step="1">
                    <v-card :style="'background-color: ' + (currentSubStage.color_subetapa_actual !== '' ? currentSubStage.color_subetapa_actual : 'gray')" 
                            class="mb-6 d-flex align-center justify-center" height="200px">
                            {{currentSubStage.descripcion_subetapa_actual}}
                    </v-card>
                    <v-btn color="primary" @click="steepSubStage = 2">
                        Continue
                    </v-btn>
                    <v-btn text>
                        Cancel
                    </v-btn>
                </v-stepper-content>

                <v-stepper-step step="2">
                    {{currentSubStage.nombre_subetapa_siguiente}}
                </v-stepper-step>

                <v-stepper-content step="2">
                    <v-card :style="'background-color: ' + (currentSubStage.color_subetapa_siguiente !== '' ? currentSubStage.color_subetapa_siguiente : 'gray')" 
                            class="mb-6 d-flex align-center justify-center" height="200px">
                            {{currentSubStage.descripcion_subetapa_siguiente}}
                    </v-card>
                    <!-- <v-btn color="primary" @click="steepSubStage = 3">
                        Continue
                    </v-btn>
                    <v-btn text>
                        Cancel
                    </v-btn> -->
                </v-stepper-content>

                <!-- <v-stepper-content step="4">
                    <v-card color="grey lighten-1" class="mb-12" height="200px"></v-card>
                    <v-btn color="primary" @click="steepSubStage = 1">
                        Continue
                    </v-btn>
                    <v-btn text>
                        Cancel
                    </v-btn>
                </v-stepper-content> -->
            </v-stepper>
        </template>
    </div>
    <!-- </div> -->
</template>

<script>
import services from "@/services";
// import { mapActions } from "vuex";
export default {
    data() {
        return {
            process: [],
            currentSubStage: [],
            foundSubStage: false,
            steepSubStage: 0
        }
    },
    props: {
        iidsubStage: {
            type: Number,
            required: true
        }
    },
    methods: {
        async loadData() {
            let iidsubStage = this.iidsubStage
            let currentSubStage = await services.inspections().getAllFlowBySubStage({ iidsubStage });
            let iidproceso = currentSubStage.iidproceso
            this.currentSubStage = currentSubStage
            if (this.currentSubStage) {
                this.foundSubStage = true
                this.process = await services.inspections().getInfoProcess({ iidproceso })
                console.log('-------this.currentSubStage')
                console.log(this.currentSubStage)
                this.steepSubStage = 1
            }
            this.$emit('process-flow', this.foundSubStage, this.currentSubStage, this.process);
        },
    },
    async mounted() {
        await this.loadData();

    }

};
</script>
