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
            </v-tabs>
            <v-tabs-items v-model="tab">
                <v-card flat>
                    <v-tab-item :key="1" value="generaltab" class="py-1">
                        <v-card-text>
                            <v-form v-model="valid">
                                <v-row>
                                    <v-col cols="12" md="6">
                                        <v-text-field v-model="user.nombre" label="Nombre*" :rules="[rules.required]" hide-details="auto" clearable dense outlined />
                                    </v-col>
                                    <v-col cols="12">
                                        <v-textarea v-model="user.descripcion" label="Descripción*" :rules="[rules.required]" hide-details="auto" clearable dense outlined />
                                    </v-col>
                                    <v-col cols="12" style="font-size: 20px;">Permisos</v-col>
                                    <v-col cols="12">
                                        <v-expansion-panels>
                                            <v-expansion-panel v-for="(item, i) in permissions" :key="i">
                                                <v-expansion-panel-header>
                                                    {{ item.nombre }}
                                                </v-expansion-panel-header>
                                                <v-expansion-panel-content>
                                                    <v-checkbox v-for="(permission, id) in item.permisos" v-model="user.permisos" :key="id" :value="permission.id" @click="click.permission = true">
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
                                    </v-col>
                                </v-row>
                            </v-form>
                        </v-card-text>
                    </v-tab-item>
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
                role: false,
                permission: false,
            },
            valid: false,
            tab: "generaltab",
            permissions: [],
            roles: [],
            modules: [],
            domains: [],
            user: {
                id: 0,
                usuario: "",
                nombre: "",
                apepat: "",
                apemat: "",
                correo: "",
                admin: false,
                descripcion: [],
                // dominios: [],
                modulos: [],
                perfiles: [],
                permisos: [],
            },
            hints: {
                user: "Solo . _ - números y letras sin acentos ni espacios.",
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
                const [domains, modules, roles, permissions] = await Promise.all([
                    services.admin().getDomains(),
                    services.admin().getModules(),
                    services.admin().getRoles(),
                    services.admin().getPermissions()
                ]);

                this.domains = domains.map(({ id, nombre }) => ({ id, nombre }));
                this.modules = modules;
                this.roles = roles;
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
                console.log(id)
                const { perfiles } = await services.admin().getEditProfileInfo({ id });
                console.log(perfiles)
                const { usuarios, permisos } = perfiles
                console.log(usuarios)
                console.log(permisos)
                
                // const { ...profile } = nombre;
                // this.profile = profile;
            } catch (error) {
                const message = 'Error al cargar información de perfil.';
                this.showError({ message, error });
            }
        },
        setUserModules() {
            const m = this.permissions
                .flatMap(p => p.permisos)
                .filter(p => this.user.permisos.includes(p.id))
                .map(p => p.idmodulo);

            this.user.modulos = [...new Set(m)];
            this.user.admin = this.user.perfiles.includes(1);
        },
        async saveProfile() {
            if (!this.valid) return;

            this.setUserModules();

            try {
                const { message } = await (
                    this.createMode ?
                    services.admin().createUser(this.user) :
                    services.admin().updateUser(this.user)
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
        ['user.permisos'](newPermissions, oldPermissions) {
            if (this.click.permission === false) return;
            if (newPermissions.length === oldPermissions.length) return;

            this.user.perfiles = this.roles
                .filter(r => r.idpermiso.every(id => newPermissions.includes(id)))
                .map(r => r.id);

            this.click.permission = false;
        },
        ['user.perfiles'](newRoles, oldRoles) {
            if (this.click.role === false) return;
            if (oldRoles.length === newRoles.length) return;

            if (newRoles.length < oldRoles.length) {
                const previousRoles = [...oldRoles];
                const roleId = previousRoles.pop();
                const role = this.roles.find(r => r.id === roleId);
                this.user.permisos = this.user.permisos.filter(p => !role.idpermiso.includes(p));
            } else {
                const actualRoles = [...newRoles];
                const roleId = actualRoles.pop();
                const role = this.roles.find(r => r.id === roleId);
                this.user.permisos.push(...role.idpermiso);
                this.user.permisos = [...new Set(this.user.permisos)];
            }

            this.user.permisos.filter(p => p !== 0);
            this.click.role = false;
        }
    },
    async mounted() {
        await this.loadSelectableData();
        if (!this.createMode) await this.setEditMode();
    },
};
</script>
