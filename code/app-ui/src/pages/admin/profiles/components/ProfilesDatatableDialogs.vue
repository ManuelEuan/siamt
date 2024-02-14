<template>
<div class="wrapper">
    <v-dialog transition="dialog-top-transition" max-width="600" v-model="show.view">
        <v-card>
            <v-card-title class="text-uppercase primary--text text-h6 py-2"> ver perfil e</v-card-title>
            <v-divider></v-divider>
            <v-card-text class="py-0 my-0">
                <v-list class="pa-0 ma-0">
                    <v-container class="pa-0 ma-0">
                        <v-row dense>
                            <template v-for="(value, key, index) in profile">
                                <v-col v-if="!chips.includes(key)" class="pa-0 ma-0" cols="6" :key="index">
                                    <v-list-item>
                                        <v-list-item-content class="py-2">
                                            <v-list-item-title class="text-capitalize text-h7">
                                                {{ headers[key] ?? key }}
                                            </v-list-item-title>
                                            <v-list-item-subtitle class="text-lowercase text-body-1">
                                                {{ typeof value === 'boolean' ? '' : value }}
                                                <v-icon v-show="value===true" size="medium" color="green"> mdi-check </v-icon>
                                                <v-icon v-show="value===false" size="medium" color="red">mdi-close</v-icon>
                                            </v-list-item-subtitle>
                                        </v-list-item-content>
                                    </v-list-item>
                                </v-col>
                            </template>
                        </v-row>
                    </v-container>
                </v-list>
            </v-card-text>
            <v-divider></v-divider>
            <v-card-text class="py-0 my-0">
                <v-list class="pa-0 ma-0">
                    <v-container class="pa-0 ma-0">
                        <v-row dense>
                            <template v-for="(value, key, index) in profile">
                                <v-col v-if="chips.includes(key)" class="pa-0 ma-0" cols="12" :key="index">
                                    <v-list-item>
                                        <v-list-item-content class="py-2">
                                            <v-list-item-title class="text-capitalize text-h7">
                                                {{ headers[key] ?? key }}
                                            </v-list-item-title>
                                            <v-list-item-subtitle class="text-lowercase text-body-1">
                                                <v-chip-group column>
                                                    <v-chip v-for="(element, index) in value" :key="index">
                                                        {{ element.element }}
                                                    </v-chip>
                                                </v-chip-group>
                                            </v-list-item-subtitle>
                                        </v-list-item-content>
                                    </v-list-item>
                                </v-col>
                            </template>
                        </v-row>
                    </v-container>
                </v-list>
            </v-card-text>
            <v-divider></v-divider>
            <v-card-actions class="py-2">
                <v-spacer></v-spacer>
                <v-btn color="error" text @click="show.view = false"> Cerrar </v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>

    <v-dialog transition="dialog-top-transition" max-width="600" v-model="show.delete">
        <v-card>
            <v-card-title class="text-uppercase primary--text text-h6 py-2">
                {{ profile.activo ? "desactivar" : "activar" }} perfil
            </v-card-title>
            <v-divider></v-divider>
            <v-card-text class="text-lowercase text-body-1 py-2">
                ¿est&aacute;s seguro de que deseas {{ profile.activo ? "desactivar" : "activar" }} este
                perfil?
            </v-card-text>
            <v-divider></v-divider>
            <v-card-actions class="py-2">
                <v-spacer></v-spacer>
                <v-btn color="error" text @click="show.delete = false"> Cerrar </v-btn>
                <v-btn color="primary" text @click="deleteProfile">
                    {{ profile.activo ? "Desactivar" : "Activar" }}
                </v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>

</div>
</template>

<script>
import rules from "@/core/rules.forms";
import services from "@/services";
import { mapActions } from "vuex";

export default {
    name: "ProfileDatatableDialogs",
    data() {
        return {
            chips: ["usuarios", "permisos"],
            headers: {
                id: "no. perfil",
                roles: "perfiles",
                apepat: "apellido paternoss",
                apemat: "apellido materno",
                fecha_creacion: "fecha creacion",
                fecha_modificacion: "fecha modificación",
            },
            show: {
                view: false,
                delete: false,
                change: false,
                reset: false,
            },
            profile: {},
            form: {
                pass: "",
                show1: false,
                show2: false,
                valid: false,
            },
        };
    },
    computed: {
        showPass() {
            return {
                type1: this.form.show1 ? "text" : "password",
                type2: this.form.show2 ? "text" : "password",
                icon1: this.form.show1 ? "mdi-eye" : "mdi-eye-off",
                icon2: this.form.show2 ? "mdi-eye" : "mdi-eye-off",
            };
        },
        samePass() {
            return this.form.pass === this.profile.clave;
        },
        valid() {
            return this.samePass && this.form.valid;
        },
        rules() {
            return {
                ...rules,
                samePass: this.samePass || "Las contraseñas no coinciden.",
            };
        }
    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),
        async viewProfile() {
            try {
                const { id } = this.profile;

                let [ ...perfil ] = await Promise.all([
                    services.admin().getEditProfileInfo({ id }),
                ]);
                console.log('perfil---')
                console.log(perfil)
                let usuarios = perfil[0].perfiles.usuarios
                let permisos = perfil[0].perfiles.permisos

                this.profile.usuarios = usuarios
                this.profile.permisos = permisos

                this.show.view = true;
            } catch (error) {
                const message = 'Error al cargar la información.';
                this.showError({ message, error });
            }
        },
        async deleteProfile() {
            try {
                const { message } = await services.admin().deleteProfile(this.profile.id);
                this.$parent.loadProfilesTable();
                this.showSuccess(message);
            } catch (error) {
                const message = 'Error al activar/desactivar usuario.';
                this.showError({ message, error });
            }

            this.show.delete = false;
        },
        async changePass() {
            if (!this.valid) return;

            try {
                const { id, clave } = this.profile;
                const { message } = await services.admin().changeProfilePass({ id, clave });
                this.showSuccess(message);
            } catch (error) {
                const message = 'Error al modificar contraseña de usuario.';
                this.showError({ message, error });
            }

            this.show.change = false;
        },
        async resetPass() {
            try {
                const { id } = this.profile;
                const { message } = await services.admin().resetProfilePass({ id });
                this.showSuccess(message);
            } catch (error) {
                const message = 'Error al restablecer contraseña de usuario.';
                this.showError({ message, error });
            }

            this.show.reset = false;
        },
    },
    watch: {
        ["show.change"](newValue) {
            if (newValue) return;
            this.$refs.form.reset();
        },
    },
};
</script>
