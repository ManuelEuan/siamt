<template>
    <div class="col-md-6">
        <v-file-input v-model="files" :color="color" :counter="counter" :label="label" :multiple="multiple"
            :placeholder="placeholder" :prepend-icon="prependIcon" :dense="dense" :outlined="outlined"
            :show-size="showSize">
            <template v-slot:selection="{ index, text }">
                <v-chip v-if="index < 2" :color="color" dark label small>
                    {{ text }}
                </v-chip>

                <span v-else-if="index === 2" class="text-overline grey--text text--darken-3 mx-2">
                    +{{ files.length - 2 }} Archivo
                </span>
            </template>
        </v-file-input>
    </div>
    <div class="col-md-6">
        <v-file-input v-model="files" :color="color" :counter="counter" :label="label" :multiple="multiple"
            :placeholder="placeholder" :prepend-icon="prependIcon" :dense="dense" :outlined="outlined"
            :show-size="showSize">
            <template v-slot:selection="{ index, text }">
                <v-chip v-if="index < 2" :color="color" dark label small>
                    {{ text }}
                </v-chip>

                <span v-else-if="index === 2" class="text-overline grey--text text--darken-3 mx-2">
                    +{{ files.length - 2 }} Archivo
                </span>
            </template>
        </v-file-input>
    </div>

    <div class="col-md-6">
        <!-- <column :column-attributes="{'sm': '12', lg: '6'}"> -->
        <div class="d-flex justify-end align-items-center" style="height: 100%">
            <input type="file" style="display: none" ref="fileUpload" @change="validateFile($event)">
            <button class="btn-upload" @click="selectFile($event)" :class="fileSelectedClass" type="button">
                <img :src="iconButton" />
                <span>{{ fileLabelText }}</span>
            </button>
        </div>
        <!-- </column> -->
    </div>
</template>

<style>
.articles .article-body {
    line-height: 1.4;
    margin: 0 6rem;
}
  .widget-upload{
    padding: 24px 20px 24px 20px;
    background-color: #F6F6F6;

  }
  .btn-upload{
    width: 9.75rem;
    height: 3.1rem;
    border: 1px solid #B6B6B6;
    border-radius: 15px;
    padding: 12px 20px 12px 20px;
    gap: 10px;
    background: #FFFFFF;
  }
  .btn-upload span{
    margin-left: 0.5rem;
    color: #00A8E4;
    font-weight: 700;
    font-size: 0.87rem;
  }
  .file-selected{
    background: #00A8E4 !important;
    border-color: #00A8E4 !important;

  }

  .file-selected span{
     color: #fff !important;
  }
</style>
<script>
export default {
    data() {
        return {
            data: '',
            files: [],
        }
    },
    props: {
        model: {
            type: String,
            required: false
        },
        fileCurrent: {
            type: String,
            default: null,
        },
        //   files: {
        //     type: Array,
        //     default: () => []
        //   },
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
        validateFile(evt) {
            if (evt.target.files.length > 0) {
                var file = evt.target.files[0]
                if (file.size > 5000000) {
                    this.$emit('onSelectionError', `El archivo (" ${file.name}") excede el límite permitido`, this.inputFileName)
                }
                else {
                    this.file = evt.target.files[0];
                    this.fileLabelText = "Cambiar";
                    this.hasFile = true;
                    this.fileSelectedClass = "file-selected"
                    this.iconButton = `/files-content/${this.iconSelected}`
                    this.$emit('onFileSelected', this.file, this.inputFileName)
                }
            }

        }
    },
    mounted() {
        //this.iconButton = `/files-content/${this.icon}`

        // this.fileSelectedClass = this.fileCurrent !== null ? "file-selected"  : ""
        // this.iconButton = this.fileCurrent !== null ? `/files-content/${this.iconSelected}` : `/files-content/${this.icon}`
        // this.hasFile = true
        this.fileLabelText = this.fileCurrent !== null ? "Cambiar" : "Adjuntar";
    },
    watch: {
        'fileCurrent': function () {
            // handler: function(){
            // this.fileSelectedClass = this.fileCurrent != null ? "file-selected" : ""
            // this.iconButton = this.fileCurrent != null ? `/files-content/${this.iconSelected}` : `/files-content/${this.icon}`
            this.hasFile = this.fileCurrent != null ? true : false
            this.fileLabelText = this.fileCurrent !== null ? "Cambiar" : "Adjuntar";
            // },
            // deep: true
        }
    }
};
</script>