<template>
    <v-container fluid>
        <div class="row">
            <div class="col-md-12">
                <curp-verification ref="curpVerification"></curp-verification>
            </div>
            <v-row>
                <generic-file-input v-model="files.actaNacimiento" :modelo="'actaNacimiento'"
                    :label="'Acta de nacimiento'" :placeholder="'Seleccione su Acta de nacimiento'" :color="'primary'"
                    @file-upload="handleFileUpload" />
                <generic-file-input v-model="files.curp" :modelo="'curp'" :label="'CURP'"
                    :placeholder="'Seleccione su CURP'" :color="'primary'" @file-upload="handleFileUpload" />
                <v-col cols="12" md="6">
                    <h2>Información de los archivos:</h2>
                    <ul>
                        <li v-for="(file, key) in files" :key="key">
                            <strong>Modelo:</strong> {{ key }}<br>
                            <strong>Nombre:</strong> {{ file ? file.name : 'No seleccionado' }}<br>
                            <strong>Tamaño:</strong> {{ file ? file.size : 'No seleccionado' }} bytes<br>
                            <strong>Tipo:</strong> {{ file ? file.type : 'No seleccionado' }}<br>
                            <strong>Última Modificación:</strong> {{ file ? new Date(file.lastModified) : 'No seleccionado' }}
                        </li>
                    </ul>
                </v-col>
                <generic-process-flow :iidsubStage=1 @process-flow="handleProcessFlow"></generic-process-flow>
                {{ SubStage }}
                <v-expand-x-transition>
                    <v-card v-show="expand2" height="100" width="100" class="mx-auto secondary"></v-card>
                </v-expand-x-transition>
            </v-row>


        </div>
        <!-- <direction-verification></direction-verification> -->

        {{ files }}
    </v-container>
</template>

<script>
import CurpVerification from '@/components/common/CurpVerification.vue';
import GenericFileInput from '@/components/common/GenericFileInput.vue';
import GenericProcessFlow from '@/components/common/GenericProcessFlow.vue';

export default {
    name: 'InspectorsPage',
    components: {
        CurpVerification,
        GenericFileInput,
        GenericProcessFlow,
    },
    data() {
        return {
            data: '',
            expand2: false,
            files: {
                // actaNacimiento: '', // Inicialmente vacío
                // curp: '', // Inicialmente vacío
            },
            SubStage: {
                info: [],
                process: []
            }
        }
    },
    methods: {
        handleFileUpload(modelo, file) {
            console.log('desde el emit del generic input uplad')
            // Actualizar el modelo correspondiente dinámicamente
            this.$set(this.files, modelo, file[0]);
        },
        handleProcessFlow(foundSubStage, infoSubStage, processSubStage) {
            console.log('Retornando desde GENERIC PROCESS FLOW ')
            if (foundSubStage) {
                this.SubStage.info = infoSubStage
                this.SubStage.process = processSubStage
            } else {
                alert('No se encontró registro de la sub etapa')
            }
            // console.log(foundSubStage)
            // console.log(infoSubStage)
            // console.log(processSubStage)
        },
    }

}
</script>

<style lang="scss" scoped></style>
