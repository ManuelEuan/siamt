<style lang="scss" scoped></style>

<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <v-card flat>
                    <v-toolbar>
                        <v-toolbar-title>Plantillas</v-toolbar-title>
                    </v-toolbar>
                </v-card>
                <v-card flat class="mt-5 px-2">
                    <v-row class="px-2">
                        <v-col cols=10 class="mx-auto">
                            <v-text-field v-model="template.txtnombre" label="Nombre de la plantilla"
                                hide-details="auto" clearable dense outlined :rules="[rules.required]" />
                        </v-col>
                        <v-flex xs12>
                            <v-layout align-center justify-center column fill-height>
                                <p>&nbsp;</p>
                                <h4>Crea tu plantilla en este espacio</h4>
                                <editor inline :init="editorInit" v-model="template.txtplantilla"
                                    style="border: 1px solid #000;padding: 0 1em 1em 1em; width: 900px; min-height: 235px; line-height: 20px;background:#fff">
                                </editor>
                                <p>&nbsp;</p>
                            </v-layout>
                        </v-flex>

                        <v-bottom-sheet persistent v-model="codeSync" class="unshadow" full-width>
                            <v-card class="pa-3 elevation-9" title="Vista de código"
                                text="Aqui puedes editar el contenido del editor desde su fuente en formato HTML">
                                <editor inline v-model="template.txtplantilla"
                                    style="margin:auto; border: 1px solid #000;padding: 0 1em 1em 1em; width: 900px; min-height: 235px; line-height: 20px; background:#fff">
                                </editor>
                                <codemirror class="mt-3" ref="code-mirror" v-model="template.txtplantilla"
                                    :options="optionsCode"></codemirror>

                                <v-card-actions>
                                    <v-spacer></v-spacer>
                                    <v-btn color="primary" text @click="codeSync = false">
                                        Aceptar
                                    </v-btn>
                                </v-card-actions>
                            </v-card>
                        </v-bottom-sheet>

                        <v-col cols="12" md="12" class="d-flex justify-end">
                            <!-- <v-btn color="warning" text>
                                {{ !template.iidfirma_plantilla ? 'Nueva' : 'Editar' }} plantilla</v-btn> -->
                            <v-btn color="primary" text :disabled="!template.txtnombre || !template.txtplantilla"
                                @click="saveTemplate()">
                                {{ !template.iidfirma_plantilla ? 'Guardar' : 'Actualizar' }}
                                plantilla </v-btn>
                            <v-btn color="info" text @click="dialogSearch = true">
                                Buscar</v-btn>
                        </v-col>

                    </v-row>
                </v-card>
            </v-col>
        </v-row>
        <!-- MODAL BÚSQUEDA -->
        <v-dialog transition="dialog-top-transition" max-width="600" v-model="dialogSearch">
            <v-card>
                <v-card-title class="text-uppercase primary--text text-h6 py-2">
                    Buscar plantilla
                </v-card-title>
                <v-divider></v-divider>
                <v-card-text class="text-lowercase text-body-1 py-2">
                    <template>
                        <v-card>
                            <v-card-title>
                                Plantilla
                                <v-spacer></v-spacer>
                                <v-text-field v-model="search" append-icon="mdi-magnify" label="Buscar" single-line
                                    hide-details></v-text-field>
                            </v-card-title>
                            <v-data-table v-model="selected" :headers="headers" :items="templates" :search="search"
                                :items-per-page="5" :single-select="singleSelect" show-select
                                item-key="iidfirma_plantilla">
                            </v-data-table>
                        </v-card>
                    </template>
                </v-card-text>
                <v-divider></v-divider>
                <v-card-actions class="py-2">
                    <v-spacer></v-spacer>
                    <v-btn color="error" text @click="dialogSearch = false"> Cerrar </v-btn>
                    <v-btn color="primary" text @click="getTemplateById">
                        Seleccionar
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-container>
</template>

<script>
import services from "@/services";
import rules from "@/core/rules.forms";
import { mapActions } from "vuex";

import { codemirror } from 'vue-codemirror'
import 'codemirror/mode/htmlembedded/htmlembedded'
import 'codemirror/lib/codemirror.css'
import 'codemirror/theme/eclipse.css'
import 'codemirror/theme/monokai.css'

import '../../../plugins/tinymce-lang-es_MX';
import 'tinymce/themes/silver/theme'
import 'tinymce/icons/default/icons'
import 'tinymce/plugins/paste';
import 'tinymce/plugins/code';
import { Vue2TinymceEditor } from "vue2-tinymce-editor";
import Editor from '@tinymce/tinymce-vue'
export default {
    name: 'Firms',
    components: {
        'editor': Editor,
        codemirror
    },
    data() {
        return {
            peopleModulePermissions: [],
            dialogSearch: false,
            singleSelect: true,
            selected: [],
            template: {
                iidfirma_plantilla: 0,
                txtnombre: '',
                txtplantilla: '',
            },
            rules: rules,

            search: '',
            headers: [
                {
                    text: 'Nombre',
                    align: 'start',
                    sortable: false,
                    value: 'txtnombre',
                },
                // { text: 'Nombre', value: 'txtnombre' },
            ],
            templates: [],
            codeSync: false,
            editorInit: {
                menu: { // this is the complete default configuration
                    file: { title: 'File', items: 'newdocument | preview | print' },
                    edit: { title: 'Edit', items: 'undo redo | cut copy paste pastetext | selectall | findreplace' },
                    insert: { title: 'Insert', items: 'my_images link media | template hr | insertdatetime' },
                    view: { title: 'View', items: 'view_code | visualaid' },
                    format: { title: 'Format', items: 'bold italic underline strikethrough superscript subscript | formats | removeformat' },
                    table: { title: 'Table', items: 'inserttable deletetable | cell row column' },
                    tools: { title: 'Tools', items: 'spellchecker' }
                },
                // selector: 'textarea', // Selector de los elementos donde TinyMCE se aplicará
                // plugins: 'code', // Agregar el plugin de código a la lista de plugins
                // toolbar: 'code',
                selector: "textarea",
                plugins: [
                    // " code ",
                ],
                toolbar: "insertfile undo redo | styleselect | fontselect fontsizeselect | bold italic | alignleft aligncenter alignright alignjustify | forecolor backcolor | bullist numlist outdent indent | link my_images | etiquetas",
                fontsize_formats: '6pt 8pt 10pt 12pt 14pt 18pt 20pt 24pt 28pt 36pt 42pt 50pt',
                font_formats: 'Panton=Panton;Andale Mono=andale mono,times;Arial=arial,helvetica,sans-serif;Arial Black=arial black,avant garde;Book Antiqua=book antiqua,palatino;Comic Sans MS=comic sans ms,sans-serif;Courier New=courier new,courier;Georgia=georgia,palatino;Helvetica=helvetica;Impact=impact,chicago;Roboto=Roboto,sans-serif;Symbol=symbol;Tahoma=tahoma,arial,helvetica,sans-serif;Terminal=terminal,monaco;Times New Roman=times new roman,times;Trebuchet MS=trebuchet ms,geneva;Verdana=verdana,geneva;Webdings=webdings;Wingdings=wingdings,zapf dingbats;AkrutiKndPadmini=Akpdmi-n',
                language: 'es',
                content_css: ['https://fonts.googleapis.com/css?family=Helvetica:100,400,700'],
                content_style: 'body { font-family:Helvetica,Arial,sans-serif !important; font-size:16px }',
                setup(editor) {
                    editor.ui.registry.addMenuItem('view_code', {
                        text: 'Editar codigo fuente',
                        icon: 'code',
                        context: 'view',
                        onAction: function () {
                            window.vueApp.bus.$emit('edit-code', editor);
                        }
                    });

                    editor.ui.registry.addMenuButton('etiquetas', {
                        text: 'Agregar etiquetas',
                        fetch: (callback) => {
                            const items = [
                                {
                                    type: 'menuitem',
                                    text: 'Agregar Nombre',
                                    onAction: () => editor.insertContent('{%%NOMBRE%%}')
                                },
                                {
                                    type: 'menuitem',
                                    text: 'Agregar Nombre Completo',
                                    onAction: () => editor.insertContent('{%%NOMBRE_COMPLETO%%}')
                                },
                                {
                                    type: 'menuitem',
                                    text: 'Agregar Apellido Paterno',
                                    onAction: () => editor.insertContent('{%%APELLIDO_PATERNO%%}')
                                },
                                {
                                    type: 'menuitem',
                                    text: 'Agregar Apellido Materno',
                                    onAction: () => editor.insertContent('{%%APELLIDO_MATERNO%%}')
                                },
                                {
                                    type: 'menuitem',
                                    text: 'Agregar Puesto',
                                    onAction: () => editor.insertContent('{%%PUESTO%%}')
                                },
                                {
                                    type: 'menuitem',
                                    text: 'Agregar Dependencia',
                                    onAction: () => editor.insertContent('{%%DEPENDENCIA%%}')
                                },
                                {
                                    type: 'menuitem',
                                    text: 'Agregar Departamento',
                                    onAction: () => editor.insertContent('{%%DEPARTAMENTO%%}')
                                },
                                {
                                    type: 'menuitem',
                                    text: 'Agregar Oficina',
                                    onAction: () => editor.insertContent('{%%OFICINA%%}')
                                },
                                {
                                    type: 'menuitem',
                                    text: 'Agregar Telefono',
                                    onAction: () => editor.insertContent('{%%TELEFONO%%}')
                                }

                            ];
                            callback(items);
                        }
                    });

                }
            },
        }
    },
    computed: {
        optionsCode() {
            return {
                tabSize: 4,
                mode: 'text/html',
                theme: 'eclipse',
                lineNumbers: true,
                line: true,
            };
        },
        codemirror() {
            return this.$refs['code-mirror'].codemirror
        },
    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),
        editCode(editor) {
            this.editor = editor;
            this.$parent.$parent.drawer = false
            this.codeSync = true;
            this.$refs['code-mirror'].focus()
        },
        async getTemplateById() {
            try {
                this.dialogSearch = false
                this.template = await services.admin().getTemplateById({ 'iidfirma_plantilla': this.selected[0].iidfirma_plantilla });
                this.template.txtplantilla = decodeURIComponent(this.template.txtplantilla)

            } catch (error) {
                const message = 'Error al cargar servicio de plantilla.';
                alert(message);
            }
        },
        async getAllTemplates() {
            try {
                let templates = await services.admin().getAllTemplates();
                this.templates = templates;
            } catch (error) {
                const message = 'Error al cargar servicio de plantilla.';
                alert(message);
            }
        },
        async saveTemplate() {
            try {
                this.template.txtplantilla = encodeURIComponent(this.template.txtplantilla)
                if (!this.template.iidfirma_plantilla) {
                    // Nueva
                    // let { iidfirma_plantilla, message } = await services.admin().createTemplate(this.template);
                    let { message } = await services.admin().createTemplate(this.template);
                    this.showSuccess(message);
                    setTimeout(() => {
                        window.location.reload()
                    }, 1500);
                } else {
                    // Actualizar
                    let { message } = await services.admin().updateTemplate(this.template);
                    this.showSuccess(message);
                    setTimeout(() => {
                        window.location.reload()
                    }, 1500);
                }
                this.template.txtplantilla = decodeURIComponent(this.template.txtplantilla)
                await this.getAllTemplates();
            } catch (error) {
                const message = 'Error al cargar servicio de plantilla.';
                alert(message);
            }
        }
    },
    watch: {
    },
    async mounted() {
        console.log(Vue2TinymceEditor);
        await this.getAllTemplates();
        console.log('mounted bus');
        console.log(this.$root.bus);
        this.$root.bus.$on('edit-code', this.editCode);
        let user = await services.app().getUserConfig();
        let getActivePermissionsFromUser = await services.admin().getActivePermissionsFromUser(user[0].id);
        this.peopleModulePermissions = getActivePermissionsFromUser.map(permission => permission.siglas);
    }
}
</script>

<style lang="scss" scoped></style>
