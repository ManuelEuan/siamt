<template>
    <v-container fluid>
        <div class="row">
            <div class="col-md-12">
                <curp-verification ref="curpVerification"></curp-verification>
            </div>
            <v-row>
                <generic-file-input v-model="files.actaNacimiento" :modelo="'actaNacimiento'"
                    :label="'Acta de nacimiento'" :placeholder="'Seleccione su Acta de nacimiento'" :color="'primary'"
                    @file-upload="fileUpload" />
                <generic-file-input v-model="files.curp" :modelo="'curp'" :label="'CURP'"
                    :placeholder="'Seleccione su CURP'" :color="'primary'" @file-upload="fileUpload" />
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
                <generic-dialog 
                    :dialogVisible="dialogCurpChanged"
                    :dialogTitle="'Se ha detectado un cambio en el CURP verificado'"
                    :dialogText="'Favor de verificar de nuevo'"
                    @update:dialogVisible="dialogCurpChanged = $event"
                    @confirm="verifyCurp(false)"
                />
                <v-btn color="primary" @click="dialogCurpChanged=true">Invocar</v-btn>
            </v-row>


        </div>
        <!-- <direction-verification></direction-verification> -->
        {{ files }}
    </v-container>
</template>

<script>
import CurpVerification from '@/components/common/CurpVerification.vue';
import GenericFileInput from '@/components/common/GenericFileInput.vue';
import GenericDialog from '@/components/common/GenericDialog.vue';

export default {
    name: 'InspectorsPage',
    components: {
        CurpVerification,
        GenericFileInput,
        GenericDialog,
    },
    data() {
        return {
            data: '',
            files: {
                // fileActaNacimiento: [],
                // fileCurp: [],
                // actaNacimiento: '', // Inicialmente vacío
                // curp: '', // Inicialmente vacío
            },
            dialogCurpChanged: false,
        }
    },
    methods: {
        // fileUpload(modelo, file) {
        //     console.log('desde el emit del generic input uplad')
        //     console.log(file)

        //     // Actualiza el modelo correspondiente dinámicamente
        //     this.$set(this.files, modelo, file);

        //     console.log(this.files[modelo]);
        // }
        fileUpload(modelo, file) {
            console.log('Modelo:', modelo);
            console.log('Archivo:', file[0]);

            console.log('desde el emit del generic input uplad')
            console.log(file)
            // Actualizar el modelo correspondiente dinámicamente
            this.$set(this.files, modelo, file[0]);
        },
        verifyCurp() {
        // Lógica para verificar el CURP
        alert('aprobado')
        }
    }

}
</script>

<style lang="scss" scoped></style>
