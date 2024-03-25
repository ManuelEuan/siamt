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
                  
                </v-tabs>
                <v-tabs-items v-model="tab">
                    <v-card flat>
                        <v-tab-item :key="1" value="generaltab" class="py-1">
                            <v-card-text>
                                <v-form v-model="valid">
                                    <v-row>
                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="inspector.curp" label="CURP*" :rules="[rules.curp]" maxlength="18"
                                                hide-details="auto" clearable dense outlined />
                                        </v-col>
                                        <v-col cols="12" md="6" class="d-flex align-center">
                                            <v-btn depressed color="primary" @click="verifyPerson()">
                                                Verificar CURP
                                            </v-btn>
                                        </v-col>
                                    </v-row>
                                    <!-- CAMPOS DE PRE CARGA -->
                                    <v-row v-if="personaEncontrada">
                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="persona.txtnombre" label="Nombre/s"
                                                hide-details="auto" clearable dense outlined disabled/>
                                        </v-col>
                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="persona.txtapepat" label="Apellido paterno"
                                                hide-details="auto" clearable dense outlined disabled/>
                                        </v-col>
                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="persona.txtapemat" label="Apellido materno"
                                                hide-details="auto" clearable dense outlined disabled/>
                                        </v-col>
                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="persona.txtrfc" label="RFC"
                                                hide-details="auto" clearable dense outlined disabled/>
                                        </v-col>
                                        <!-- <v-col cols="12" md="6">
                                            <v-text-field v-model="persona.txtcurp" label="CURP"
                                                hide-details="auto" clearable dense outlined disabled/>
                                        </v-col> -->
                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="persona.txtestado_civil" label="Estado civil"
                                                hide-details="auto" clearable dense outlined disabled/>
                                        </v-col>
                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="persona.txtsexo" label="Sexo"
                                                hide-details="auto" clearable dense outlined disabled/>
                                        </v-col>
                                    </v-row>
                                    <v-row>
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
                                    
                                   
                                        
                                    </v-row>
                                </v-form>
                            </v-card-text>
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
            persona: {
                iidpersona: null,
                bfisica: null,
                txtnombre: '',
                txtapepat: '',
                txtapemat: '',
                txtrfc: '',
                txtcurp: '',
                txtestado_civil: '',
                txtsexo: '',
                activo: null,
                fecha_creacion: null,
                fecha_modificacion: null
            },
            personaEncontrada: false,
            categorias: [],
            inspector: {
                id: 0,
                curp: '',
                tarjeton: "",
                comentarios: "",
                modulos: [],
                usuarios: [],
                permisos: [],
            },
            curpValida: false,
            hints: {
                inspector: "Solo . _ - números y letras sin acentos ni espacios.",
                optional: "Opcional.",
            },
            rules: {
                ...rules,
                categoria: v => v.length > 0 || "Requerido.",
            }
          
           
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
        async verifyPerson(){
            console.log(rules.curp(this.inspector.curp))
            if(rules.curp(this.inspector.curp) === true){
                try {
                    let curp = this.inspector.curp;
                    console.log(curp)
                    console.log(this.persona);

                    let response  = await services.inspections().getPersonByCurp({ curp });
                    console.log(response);
                    if(response){
                        this.personaEncontrada = true
                        this.persona = {...response}
                    }else{
                        this.personaEncontrada = false
                        this.persona = {}
                        alert('no encontrado')
                    }
                    // this.persona = response.data;
                    // console.log(this.persona);
                    //   const { nombre, descripcion, activo, fecha_creacion, fecha_modificacion, ...inspector } = inspector;
                    //   this.inspector = inspector;
                    // this.inspector = inspector;
                } catch (error) {
                    const message = 'Error al procesar curp.';
                    this.showError({ message, error });
                }
            }else{
                console.log('no válida')
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
