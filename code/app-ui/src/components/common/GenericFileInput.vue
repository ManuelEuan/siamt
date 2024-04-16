<template>
    <div class="col-md-6">
        {{ modelo }}
        <v-file-input v-model="fileData" :color="color" :counter="counter" :label="label" :multiple="multiple"
            :placeholder="placeholder" :prepend-icon="prependIcon" :dense="dense" :outlined="outlined"
            :show-size="showSize" @change="validateFile($event)">
            <template v-slot:selection="{ index, text }">
                <v-chip v-if="index < 2" :color="color" dark label small>
                    {{ text }}
                </v-chip>

                <span v-else-if="index === 2" class="text-overline grey--text text--darken-3 mx-2">
                    +{{ fileData.length - 2 }} Archivo
                </span>
            </template>
        </v-file-input>
    </div>
</template>

<script>
export default {
    data() {
        return {
            data: '',
            fileData: [], // Cambiar el nombre de la propiedad a fileData
        }
    },
    props: {
        modelo: {
            type: String,
            required: true,
        },
        maxSize: {
            type: Number,
            default: 5000000,
        },
        fileCurrent: {
            type: String,
            default: '',
        },
        color: {
            type: String,
            default: 'deep-purple accent-4'
        },
        counter: {
            type: Boolean,
            default: true
        },
        label: {
            type: String,
            default: 'File input'
        },
        multiple: {
            type: Boolean,
            default: true
        },
        placeholder: {
            type: String,
            default: 'Select your files'
        },
        prependIcon: {
            type: String,
            default: 'mdi-paperclip'
        },
        dense: {
            type: Boolean,
            default: true
        },
        outlined: {
            type: Boolean,
            default: true
        },
        showSize: {
            type: Number,
            default: 1000
        }
    },
    methods: {
        validateFile(file) {
            if (file.size > this.maxSize) {
                return alert('Peso de archivo excedido');
            }
            this.$emit('file-upload', this.modelo, file);
        }
    }
};
</script>
