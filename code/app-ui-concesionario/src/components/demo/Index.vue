<template>
    <v-container fluid>
        <div>
            <h2 class="text-center mb-3 primary--text">COMPONENTES DE QUE NO REQUIEREN PROPS</h2>
            <h4>BÚSQUEDA, CREACIÓN, EDICIÓN DE PERSONA, DIRECCIONES,TELÉFONOS (SEGÚN PERMISOS)</h4>
            <curp-verification :activateDialogPerson=activateModalPerson @person-info="handlePersonInfo"
                :request=request></curp-verification>
        </div>
        <div>
            <h2 class="text-center mb-3 primary--text">COMPONENTES QUE REQUIEREN PROPS</h2>
            <h4>FLUJO DE ETAPAS Y SUB ETAPAS</h4>
            <generic-process-flow :request=request @process-flow="handleProcessFlow"></generic-process-flow>
        </div>
        <div>
            <h2 class="text-center mb-3 primary--text">EJEMPLO DE SERVICIOS EXTERNOS</h2>
            <h4>VINDEN</h4>
            <div class="col-md-12">
                <a ref="urlFrame" target="_blank">Abrir URL del Servicio Vinden</a>
            </div>
            <div class="col-md-12">
                <iframe ref="serviceFrame" class="embed-responsive-item" style="height: 100%; width: 100%"
                    allowfullscreen></iframe>
            </div>
        </div>
        <div>

            <h2 class="text-center mb-3 primary--text">UTILS</h2>
            <overlay :value="overlay"></overlay>
            <v-btn color="deep-purple accent-4" class="white--text" @click="overlay = !overlay">
                Launch Application
                <v-icon right>
                    mdi-open-in-new
                </v-icon>
            </v-btn>
        </div>
        <div>
            <generic-file-input v-model="files.actaNacimiento" :modelo="'actaNacimiento'" :label="'Acta de nacimiento'"
                :placeholder="'Seleccione su Acta de nacimiento'" :color="'primary'" @file-upload="handleFileUpload" />
            <generic-file-input v-model="files.curp" :modelo="'curp'" :label="'CURP'"
                :placeholder="'Seleccione su CURP'" :color="'primary'" @file-upload="handleFileUpload" />
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
        </div>
    </v-container>
</template>

<script>
// import services from "@/services";
import CurpVerification from '@/components/common/CurpVerification.vue';
import GenericFileInput from '@/components/common/GenericFileInput.vue';
import GenericProcessFlow from '@/components/common/GenericProcessFlow.vue';
import Overlay from '@/components/common/Overlay.vue';
export default {
    name: 'InspectorsPage',
    components: {
        CurpVerification,
        GenericFileInput,
        GenericProcessFlow,
        Overlay,
    },
    data() {
        return {
            data: '',
            overlay: false,
            expand2: false,
            files: {
                // actaNacimiento: '', // Inicialmente vacío
                // curp: '', // Inicialmente vacío
            },
            request: { //DEMO
                type: 'Inspector', // dinamyc Type
                idOfType: 3, // dinamyc id
                idOfSubStage: 1, //iidsubStage
                idOfNextSubStage: 0, //iidsubStage
                finalizeProcess: false,
            },
        }
    },
    methods: {
        handleFileUpload(modelo, file) {
            console.log('desde el emit del generic input uplad')
            // Actualizar el modelo correspondiente dinámicamente
            this.$set(this.files, modelo, file[0]);
        },
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
    watch: {
        overlay(val) {
            val && setTimeout(() => {
                this.overlay = false
            }, 3000)
        },
    },
    async mounted() {
        // await this.getServiceVindenUrlDebitaciones()
    }
}
</script>

<style lang="scss" scoped></style>
