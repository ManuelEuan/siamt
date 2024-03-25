<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <v-card flat>
                    <v-toolbar>
                        <v-toolbar-title>{{ createMode ? "Nuevo" : "Editar" }} Inspector</v-toolbar-title>
                    </v-toolbar>
                </v-card>
            </v-col>
            <v-col cols="12" class="pa-0 mt-2">
                <v-tabs v-model="tab" centered icons-and-text>
                    <v-tabs-slider color="primary" />
                    <v-tab href="#generaltab">
                        Datos Generales
                        <v-icon> mdi-clipboard-text </v-icon>
                    </v-tab>
                    <v-tab href="#turnostab">
                        Turnos
                        <v-icon> mdi-card-account-details </v-icon>
                    </v-tab>
                    <v-tab href="#ispectorestab">
                        Ispectores
                        <v-icon> mdi-card-account-details </v-icon>
                    </v-tab>
                    <v-tab href="#trabajostab">
                        Trabajos
                        <v-icon> mdi-card-account-details </v-icon>
                    </v-tab>
                </v-tabs>
                <v-tabs-items v-model="tab">
                    <v-card flat>
                        <v-tab-item :key="1" value="generaltab" class="py-1">
                            <v-card-text>
                                <v-form v-model="valid">
                                    <v-row>
                                        <v-col cols="6">
                                            <!-- v-model="user.dominios" -->
                                            <v-select
                                                label="Personas*"
                                                :rules="[rules.persona]"
                                                :items="personas"
                                                item-text="persona"
                                                item-value="iidpersona"
                                                hide-details="auto"
                                                small-chips
                                                clearable
                                                dense
                                                multiple
                                                outlined
                                            />
                                        </v-col>
                                        <v-col cols="6">
                                            <!-- v-model="user.dominios" -->
                                            <v-select
                                                label="Categoría*"
                                                :rules="[rules.categoria]"
                                                :items="categorias"
                                                item-text="categoria"
                                                item-value="iidcategoria"
                                                hide-details="auto"
                                                small-chips
                                                clearable
                                                dense
                                                multiple
                                                outlined
                                            />
                                        </v-col>
                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="inspector.tarjeton" label="Tarjetón*" :rules="[rules.required]"
                                                hide-details="auto" clearable dense outlined />
                                        </v-col>
                                      
                                        <v-col cols="12">
                                            <v-textarea v-model="inspector.comentarios" label="Comentarios*"
                                                :rules="[rules.required]" hide-details="auto" clearable dense outlined />
                                        </v-col>
                                    
                                        <!-- <v-col cols="12" style="font-size: 20px;">Permisos</v-col>
                                        <v-expansion-panels>
                                            <v-expansion-panel v-for="(item, i) in permissions" :key="i">
                                                <v-expansion-panel-header>
                                                    {{ item.nombre }}
                                                </v-expansion-panel-header>
                                                <v-expansion-panel-content>
                                                    <v-checkbox v-for="(permission, id) in item.permisos"
                                                        v-model="inspector.permisos" :key="id" :value="permission.id"
                                                        @click="click.permission = true">
                                                        <template v-slot:label>
                                                            <v-tooltip right>
                                                                <template v-slot:activator="{ on }">
                                                                    <span v-on="on">{{ permission.nombre }}</span>
                                                                </template>
                                                                {{ permission.descripcion }}
                                                            </v-tooltip>
                                                        </template>
                                                    </v-checkbox>
                                                </v-expansion-panel-content>
                                            </v-expansion-panel>
                                        </v-expansion-panels> -->
                                        
                                    </v-row>
                                </v-form>
                            </v-card-text>
                        </v-tab-item>
                        <v-tab-item :key="2" value="turnostab" class="py-1">
                          
                        </v-tab-item>
                        <v-tab-item :key="3" value="ispectorestab" class="py-1">
                            <v-flex xs6>
                        <v-text-field
                            v-model="carga_trabajo.fecha_inicio"
                            label="Fecha de publicación"
                            prepend-icon="event"
                            :max="carga_trabajo.fecha_vencimiento || '2999-12-12'"
                            type="date"
                        ></v-text-field>
                    </v-flex>

                    <v-flex xs6>
                        <v-text-field
                            v-model="carga_trabajo.fecha_vencimiento"
                            label="Fecha de vencimiento"
                            :disabled="! carga_trabajo.fecha_inicio || carga_trabajo.fecha_inicio == '0000-00-00 00:00:00'"
                            :min="carga_trabajo.fecha_inicio"
                            prepend-icon="event"
                            type="date"
                        ></v-text-field>
                    </v-flex>
                        </v-tab-item>
                        <v-tab-item :key="4" value="trabajostab" class="py-1">

                        </v-tab-item>
                        <v-card-actions>
                            <v-spacer />
                            <v-btn color="error" text @click="exitWindow()"> Cerrar </v-btn>
                            <v-btn color="primary" text :disabled="!valid" @click="saveInspector()"> Guardar </v-btn>
                        </v-card-actions>
                    </v-card>
                </v-tabs-items>
            </v-col>
        </v-row>
    </v-container>
</template>

  
  
<script>
import rules from "@/core/rules.forms";
import services from "@/services";

import { mapActions } from "vuex";

export default {
    components: {
    },
    data() {
        return {
            click: {
                user: false,
                permission: false,
            },
            valid: false,
            tab: "generaltab",
            permissions: [],
            usuarios: [],
            modules: [],
            personas: [],
            categorias: [],
            inspector: {
                id: 0,
                tarjeton: "",
                comentarios: "",
                modulos: [],
                usuarios: [],
                permisos: [],
            },
            hints: {
                inspector: "Solo . _ - números y letras sin acentos ni espacios.",
                optional: "Opcional.",
            },
            rules: {
                ...rules,
                persona: v => v.length > 0 || "Requerido.",
                categoria: v => v.length > 0 || "Requerido.",
            },
            carga_trabajo: {
                fecha_inicio: '',
                fecha_vencimiento: '',
            },
           
        };
    },
    computed: {
        createMode() {
            return !this.$route.params.id;
        },
    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),
        async loadSelectableData() {
            try {
                const { id } = this.$route.params;
                console.log(id);
                // const [modules, usuarios, permissions] = await Promise.all([
                //     services.admin().getModules(),
                //     services.admin().getUsersFromInspector({ id }),
                //     services.admin().getPermissions()
                // ]);

                // this.modules = modules;
                // this.usuarios = usuarios;
                // this.permissions = this.modules.map(({ nombre, id }) => ({
                //     nombre,
                //     permisos: permissions.filter(p => p.idmodulo === id),
                // }));
            } catch (error) {
                const message = 'Error al cargar opciones para nuevo inspector.';
                this.showError({ message, error });
            }
        },
        async setEditMode() {
            try {
                const { id } = this.$route.params;
                const { inspector } = await services.admin().getEditInspectorInfo({ id });
                console.log(inspector);
                //   const { nombre, descripcion, activo, fecha_creacion, fecha_modificacion, ...inspector } = inspector;
                //   this.inspector = inspector;
                this.inspector = inspector;
            } catch (error) {
                const message = 'Error al cargar información de inspector.';
                this.showError({ message, error });
            }
        },
        setInspectorModules() {
            const m = this.permissions //trae los módulos
                .flatMap(p => p.permisos) //trae todos los permisos de los módulos
                .filter(p => this.inspector.permisos.includes(p.id)) // trae los permisos seleccionados en this.inspector actuales
            // .map(p => p.idmodulo); //trae solo los módulos de los inspectores
            // this.inspector.modulos = [...new Set(m)]; // quita los elementos duplicados
            console.log(m)
        },
        async saveInspector() {
            if (!this.valid) return;

            this.setInspectorModules();

            try {
                const { message } = await (
                    this.createMode ?
                        services.admin().createInspector(this.inspector) :
                        services.admin().updateInspector(this.inspector)
                );

                this.showSuccess(message);
                this.exitWindow();
            } catch (error) {
                const message = 'Error al guardar inspector.';
                this.showError({ message, error });
            }
        },
        exitWindow() {
            this.$router.push("/inspectors");
        },
    },
    watch: {
        ['inspector.permisos'](newPermissions, oldPermissions) {
            if (this.click.permission === false) return;
            if (newPermissions.length === oldPermissions.length) return;

            this.inspector.usuarios = this.usuarios
                .filter(r => r.idpermiso.every(id => newPermissions.includes(id)))
                .map(r => r.id);

            this.click.permission = false;
        },
        ['inspector.usuarios'](newRoles, oldRoles) {
            if (this.click.user === false) return;
            if (oldRoles.length === newRoles.length) return;

            if (newRoles.length < oldRoles.length) {
                const previousRoles = [...oldRoles];
                const userId = previousRoles.pop();
                const user = this.usuarios.find(r => r.id === userId);
                this.inspector.permisos = this.inspector.permisos.filter(p => !user.idpermiso.includes(p));
            } else {
                const actualRoles = [...newRoles];
                const userId = actualRoles.pop();
                const user = this.usuarios.find(r => r.id === userId);
                this.inspector.permisos.push(...user.idpermiso);
                this.inspector.permisos = [...new Set(this.inspector.permisos)];
            }

            this.inspector.permisos.filter(p => p !== 0);
            this.click.user = false;
        }
    },
    async mounted() {
        await this.loadSelectableData();
        if (!this.createMode) await this.setEditMode();
    },
};
</script>
