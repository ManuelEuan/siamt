<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <v-card flat>
                    <v-toolbar>
                        <v-toolbar-title>{{ createMode ? "Nuevo" : "Editar" }} Correctivo</v-toolbar-title>
                    </v-toolbar>
                </v-card>
            </v-col>
            <v-col cols="12" class="pa-0 mt-2">
                <v-card flat>
                    <v-card-text>
                        <v-form v-model="valid">
                            <v-row>
                                <v-col cols="6" md="4">
                                    <v-text-field v-model="correctivo.equipo" label="Equipo*" :rules="[rules.required]" hide-details="auto" clearable dense outlined />
                                </v-col>
                                <v-col cols="6" md="4">
                                    <v-text-field v-model="correctivo.marca" label="Marca*" :rules="[rules.required]" hide-details="auto" clearable dense outlined />
                                </v-col>
                                <v-col cols="6" md="4">
                                    <v-text-field v-model="correctivo.modelo" label="Modelo*" :rules="[rules.required]" hide-details="auto" clearable dense outlined />
                                </v-col>
                                <v-col cols="6" md="4">
                                    <v-text-field v-model="correctivo.serie" label="Serie*" :rules="[rules.required]" hide-details="auto" clearable dense outlined />
                                </v-col>
                                <v-col cols="6" md="4">
                                    <v-text-field v-model="correctivo.placa" label="Placa*" :rules="[rules.required]" hide-details="auto" clearable dense outlined />
                                </v-col>
                                <v-col cols="6" md="4">
                                    <v-text-field type="number" v-model="correctivo.año" label="Año*" :rules="[rules.required, rules.positiveIntNumber]" hide-details="auto" clearable dense outlined />
                                </v-col>
                                <v-col cols="6" md="4">
                                    <v-menu
                                        v-model="correctivo.fechaIngresoMenu"
                                        :close-on-content-click="false"
                                        :nudge-right="40"
                                        transition="scale-transition"
                                        offset-y
                                        min-width="290px"
                                    >
                                        <template v-slot:activator="{ on, attrs }">
                                            <v-text-field
                                                v-model="correctivo.fechaIngreso"
                                                label="Fecha Ingreso*"
                                                readonly
                                                v-bind="attrs"
                                                v-on="on"
                                                outlined
                                                dense
                                            ></v-text-field>
                                        </template>
                                        <v-date-picker v-model="correctivo.fechaIngreso" no-title scrollable>
                                            <v-spacer></v-spacer>
                                            <v-btn text color="primary" @click="correctivo.fechaIngresoMenu = false">
                                                Cancelar
                                            </v-btn>
                                            <v-btn text color="primary" @click="correctivo.fechaIngresoMenu = false">
                                                OK
                                            </v-btn>
                                        </v-date-picker>
                                    </v-menu>
                                </v-col>
                                <v-col cols="6" md="4">
                                    <v-text-field type="number" v-model="correctivo.costo" label="Costo*" :rules="[rules.required, rules.positiveIntNumber]" hide-details="auto" clearable dense outlined />
                                </v-col>
                                <v-col cols="12">
                                    <v-textarea v-model="correctivo.comentarios" label="Comentarios" hide-details="auto" clearable dense outlined />
                                </v-col>
                                <v-col cols="12">
                                    <v-textarea v-model="correctivo.acciones" label="Acciones Realizadas" hide-details="auto" clearable dense outlined />
                                </v-col>
                            </v-row>
                        </v-form>
                    </v-card-text>
                    <v-card-actions>
                        <v-spacer />
                        <v-btn color="error" text @click="exitWindow()"> Cerrar </v-btn>
                        <v-btn color="primary" text :disabled="!valid" @click="save()"> Guardar </v-btn>
                    </v-card-actions>
                </v-card>
            </v-col>
        </v-row>
    </v-container>
</template>

<script>
import rules from "@/core/rules.forms";
import services from "@/services";
import { mapActions } from "vuex";

export default {
    data() {
        return {
            valid: false,
            correctivo: {
                equipo: "",
                marca: "",
                modelo: "",
                serie: "",
                placa: "",
                año: "",
                fechaIngreso: "",
                fechaIngresoMenu: false,
                costo: "",
                comentarios: "",
                acciones: "",
            },
            rules: {
                ...rules,
            },
        };
    },
    computed: {
        createMode() {
            return !this.$route.params.id;
        },
    },
    methods: {
        ...mapActions("app", ["showError", "showSuccess"]),
        async setEditMode() {
            try {
                const { id } = this.$route.params;
                const correctivo = await services.mantounidades().getCorrectivo({ id });

                this.correctivo = { ...correctivo.items[0] };
            } catch (error) {
                this.showError({ message: "Error al cargar la información del correctivo.", error });
            }
        },
        async save() {
            if (!this.valid) return;

            try {
                const { message } = await (
                    this.createMode
                        ? services.mantounidades().saveCorrectivo(this.correctivo)
                        : services.mantounidades().updateCorrectivo(this.correctivo)
                );

                this.showSuccess(message);
                this.exitWindow();
            } catch (error) {
                this.showError({ message: "Error al guardar el correctivo.", error });
            }
        },
        exitWindow() {
            this.$router.push("/mantenimiento/correctivos");
        },
    },
    async mounted() {
        if (!this.createMode) await this.setEditMode();
    },
};
</script>
