<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <v-card flat>
                    <v-toolbar>
                        <v-toolbar-title>{{ createMode ? "Nuevo" : "Editar" }} Perfil</v-toolbar-title>
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
                    <!-- <v-tab href="#usuariostab">
                    Usuarios
                    <v-icon> mdi-card-account-details </v-icon>
                </v-tab> -->
                </v-tabs>
                <v-tabs-items v-model="tab">
                    <v-card flat>
                        <v-tab-item :key="1" value="generaltab" class="py-1">
                            <v-card-text>
                                <v-form v-model="valid">
                                    <v-row>
                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="profile.nombre" label="Nombre*" :rules="[rules.required]"
                                                hide-details="auto" clearable dense outlined />
                                        </v-col>
                                        <v-col cols="12">
                                            <v-textarea v-model="profile.descripcion" label="Descripción*"
                                                :rules="[rules.required]" hide-details="auto" clearable dense outlined />
                                        </v-col>
                                        <v-col cols="12" style="font-size: 20px;">Permisos</v-col>
                                        <v-expansion-panels>
                                            <v-expansion-panel v-for="(item, i) in permissions" :key="i">
                                                <v-expansion-panel-header>
                                                    {{ item.nombre }}
                                                </v-expansion-panel-header>
                                                <v-expansion-panel-content>
                                                    <v-checkbox v-for="(permission, id) in item.permisos"
                                                        v-model="profile.permisos" :key="id" :value="permission.id"
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
                                        </v-expansion-panels>
                                    </v-row>
                                </v-form>
                            </v-card-text>
                        </v-tab-item>
                        <!-- <v-tab-item :key="2" value="usuariostab">
                        <v-container>
                            <v-checkbox v-for="(user, id) in usuarios" v-model="profile.usuarios" :key="id" :value="user.id" @click="click.user = true">
                                <template v-slot:label>
                                    <v-tooltip right>
                                        <template v-slot:activator="{ on }">
                                            <span v-on="on">{{ user.usuario }}</span>
                                        </template>
                                        {{ user.nombre }} {{ user.apepat }} {{ user.apemat }}
                                    </v-tooltip>
                                </template>
                            </v-checkbox>
                        </v-container>
                    </v-tab-item> -->
                        <v-card-actions>
                            <v-spacer />
                            <v-btn color="error" text @click="exitWindow()"> Cerrar </v-btn>
                            <v-btn color="primary" text :disabled="!valid" @click="saveProfile()"> Guardar </v-btn>
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
    components: {},
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
            domains: [],
            profile: {
                id: 0,
                nombre: "",
                modulos: [],
                usuarios: [],
                permisos: [],
            },
            hints: {
                profile: "Solo . _ - números y letras sin acentos ni espacios.",
                optional: "Opcional.",
            },
            rules: {
                ...rules,
                domain: v => v.length > 0 || "Requerido.",
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

                const [modules, usuarios, permissions] = await Promise.all([
                    services.admin().getModules(),
                    services.admin().getUsersFromProfile({ id }),
                    services.admin().getPermissions()
                ]);

                this.modules = modules.data;
                this.usuarios = usuarios;
                this.permissions = this.modules.map(({ nombre, id }) => ({
                    nombre,
                    permisos: permissions.filter(p => p.idmodulo === id),
                }));
            } catch (error) {
                const message = 'Error al cargar opciones para nuevo perfil.';
                this.showError({ message, error });
            }
        },
        async setEditMode() {
            try {
                const { id } = this.$route.params;
                const { perfil } = await services.admin().getEditProfileInfo({ id });
                console.log(perfil);
                //   const { nombre, descripcion, activo, fecha_creacion, fecha_modificacion, ...profile } = perfil;
                //   this.profile = profile;
                this.profile = perfil;
            } catch (error) {
                const message = 'Error al cargar información de perfil.';
                this.showError({ message, error });
            }
        },
        setProfileModules() {
            const m = this.permissions //trae los módulos
                .flatMap(p => p.permisos) //trae todos los permisos de los módulos
                .filter(p => this.profile.permisos.includes(p.id)) // trae los permisos seleccionados en this.profile actuales
            // .map(p => p.idmodulo); //trae solo los módulos de los perfiles
            // this.profile.modulos = [...new Set(m)]; // quita los elementos duplicados
            console.log(m)
        },
        async saveProfile() {
            if (!this.valid) return;

            this.setProfileModules();

            try {
                const { message } = await (
                    this.createMode ?
                        services.admin().createProfile(this.profile) :
                        services.admin().updateProfile(this.profile)
                );

                this.showSuccess(message);
                this.exitWindow();
            } catch (error) {
                const message = 'Error al guardar perfil.';
                this.showError({ message, error });
            }
        },
        exitWindow() {
            this.$router.push("/profiles");
        },
    },
    watch: {
        ['profile.permisos'](newPermissions, oldPermissions) {
            if (this.click.permission === false) return;
            if (newPermissions.length === oldPermissions.length) return;

            this.profile.usuarios = this.usuarios
                .filter(r => r.idpermiso.every(id => newPermissions.includes(id)))
                .map(r => r.id);

            this.click.permission = false;
        },
        ['profile.usuarios'](newRoles, oldRoles) {
            if (this.click.user === false) return;
            if (oldRoles.length === newRoles.length) return;

            if (newRoles.length < oldRoles.length) {
                const previousRoles = [...oldRoles];
                const userId = previousRoles.pop();
                const user = this.usuarios.find(r => r.id === userId);
                this.profile.permisos = this.profile.permisos.filter(p => !user.idpermiso.includes(p));
            } else {
                const actualRoles = [...newRoles];
                const userId = actualRoles.pop();
                const user = this.usuarios.find(r => r.id === userId);
                this.profile.permisos.push(...user.idpermiso);
                this.profile.permisos = [...new Set(this.profile.permisos)];
            }

            this.profile.permisos.filter(p => p !== 0);
            this.click.user = false;
        }
    },
    async mounted() {
        await this.loadSelectableData();
        if (!this.createMode) await this.setEditMode();
    },
};
</script>
