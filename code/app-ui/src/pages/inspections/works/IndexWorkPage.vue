<template>
    <v-container fluid>
        <div class="row">
            <div class="col-md-12">
                <curp-verification ref="curpVerification"></curp-verification>
            </div>
            <div class="col-md-6">
                <template>
                    <v-file-input v-model="files" color="deep-purple accent-4" counter label="File input" multiple
                        placeholder="Select your files" prepend-icon="mdi-paperclip" dense outlined :show-size="1000">
                        <template v-slot:selection="{ index, text }">
                            <v-chip v-if="index < 2" color="deep-purple accent-4" dark label small>
                                {{ text }}
                            </v-chip>

                            <span v-else-if="index === 2" class="text-overline grey--text text--darken-3 mx-2">
                                +{{ files.length - 2 }} File(s)
                            </span>
                        </template>
                    </v-file-input>
                </template>
            </div>
            <v-row>
                <generic-file-input v-model="files.fileActaNacimiento" cols="12" md="6" :label="'Acta de nacimiento'"
                    :modelo="'files.fileActaNacimiento'" :placeholder="'Seleccione su Acta de nacimiento'"
                    :color="'primary'" @file-upload="fileUpload" />
                <generic-file-input v-model="files.fileCurp" cols="12" md="6" :label="'CURP'" :modelo="'files.fileCurp'"
                    :placeholder="'Seleccione su CURP'" :color="'primary'" @file-upload="fileUpload" />
                <v-col cols="12" md="6">
                    <h2>Información del archivo:</h2>
                    <ul>
                        <li v-for="(file, index) in files" :key="index">
                            {{ file }}
                            {{ index }}
                            <strong>Nombre:</strong> {{ files[index].name }}<br>
                            <strong>Tamaño:</strong> {{ files[index].size }} bytes<br>
                            <strong>Tipo:</strong> {{ files[index].type }}<br>
                            <strong>Última Modificación:</strong> {{ new Date(files[index].lastModified) }}
                        </li>
                    </ul>
                </v-col>
            </v-row>
            {{ files }}

        </div>
        <!-- <direction-verification></direction-verification> -->
    </v-container>
</template>

<script>
import CurpVerification from '@/components/common/CurpVerification.vue';
import GenericFileInput from '@/components/common/GenericFileInput.vue';

export default {
    name: 'InspectorsPage',
    components: {
        CurpVerification,
        GenericFileInput,
    },
    data() {
        return {
            data: '',
            files: {
                fileActaNacimiento: [],
                fileCurp: [],
            },
        }
    },
    methods: {
        fileUpload(modelo, file) {
            console.log('desde el emit del generic input uplad')
            console.log(file)

            // Actualiza el modelo correspondiente dinámicamente
            this.$set(this.files, modelo, file);

            console.log(this.files[modelo]);
        }
    }

}
</script>

<style lang="scss" scoped></style>
