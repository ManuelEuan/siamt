<template>
    <v-container fluid>
        <div class="row">
            <div class="col-md-12">
                <curp-verification @person-info="handlePersonInfo"></curp-verification>
                <!-- <curp-verification @person-info="handlePersonInfo" :typeOfRequest="'Inspector'"></curp-verification> -->
            </div>
            <!-- <div class="col-md-12">
                <a ref="urlFrame" target="_blank">Abrir URL del Servicio Vinden</a>
            </div> -->
            <div class="col-md-12">
                <iframe ref="serviceFrame" class="embed-responsive-item" style="height: 100%; width: 100%" allowfullscreen></iframe>
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
                <!-- :iidsubStage=exampleProccessFlow
                :finalizeProcess=finalizeProcess -->
                <!-- @process-flow="handleProcessFlow" -->
                <generic-process-flow class="col-md-12" 
                    :request=request
                    @update:dialogVisible="dialogRegisterPerson = $event" 
                    @confirm="getNextSubStage()"
                ></generic-process-flow>
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
// import services from "@/services";
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
            },
            request: { //DEMO
                type: 'Inspector',
                idOfType: 3,
                idOfSubStage: 7, //iidsubStage
                idOfNextSubStage: 0, //iidsubStage
                finalizeProcess: false,
            },
            // REQUERIDOS PARA PROCESS FLOW
            // exampleProccessFlow: 8,
            // finalizeProcess: false,

        }
    },
    methods: {
        handleFileUpload(modelo, file) {
            console.log('desde el emit del generic input uplad')
            // Actualizar el modelo correspondiente dinámicamente
            this.$set(this.files, modelo, file[0]);
        },
         // RETORNO DE COMPONENTE GENÉRICO PROCESS FLOW (AUTOMÁTICO)
        // handleProcessFlow(foundSubStage, infoSubStage, processSubStage, hasFlowAfter) {
        //     console.log('Retornando desde GENERIC PROCESS FLOW ')
        //     if (foundSubStage) {
        //         this.SubStage.info = infoSubStage
        //         this.SubStage.process = processSubStage
        //         this.SubStage.hasFlowAfter = hasFlowAfter
        //     } else {
        //         alert('No se encontró registro de la sub etapa')
        //     }
        // },
         // RETORNO DE COMPONENTE GENÉRICO PROCESS FLOW (CLICK EN BUTTON)
        // getNextSubStage(){
        //     console.log('****************this.SubStage*****************')
        //     console.log(this.SubStage)
        //     this.exampleProccessFlow = this.SubStage.info.iidsubetapa_siguiente
        //     // this.inspector.iidsubetapa = this.SubStage.info.iidsubetapa_siguiente
        //     if(!this.SubStage.hasFlowAfter){
        //         // Si no existe una sub etapa que tenga flujo posterior significa que será el ultimo cambio posible del proceso
        //         this.finalizeProcess = true
        //     }
        // },

        // GET (BD)
        // async getServiceVindenUrlDebitaciones() {
        //     try {
        //         let url = await services.inspections().getServiceVindenUrlDebitaciones();
        //         this.$refs.urlFrame.href = url;
        //         this.$refs.serviceFrame.src = url;
        //     } catch (error) {
        //         const message = 'Error al cargar servicio de Vinden.';
        //         // this.showError({ message, error });
        //         alert(message);
        //     }
        // },
        // HANDLERS DEMO
        // RETORNO DE COMPONENTE GENÉRICO CURP VERIFICATION
        handlePersonInfo(personFound, availablePerson, person) {
            console.log('retorno del componente Curp Verification')
            console.log('Persona encontrada: ' + personFound)
            console.log('Persona disponible: ' + availablePerson)
            console.log('Persona Información Completa: ')
            console.log(person)
        },
        
    },
    async mounted(){
        // await this.getServiceVindenUrlDebitaciones()
    }

}
</script>

<style lang="scss" scoped></style>
