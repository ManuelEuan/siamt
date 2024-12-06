<template>
    <v-card flat>
        <v-toolbar>
            <v-toolbar-title>Actividades</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-tooltip top>
                <template v-slot:activator="{ on, attrs }">
                    <v-btn color="primary" class="me-1" @click="newActividad" v-bind="attrs" v-on="on">
                        <v-icon> mdi-format-list-bulleted </v-icon>
                    </v-btn>
                </template>
                <span>Agregar Actividad</span>
            </v-tooltip>
            <v-divider vertical class="mx-2"></v-divider>
            <v-badge overlap :content="activeFilters" :value="activeFilters">
                <v-dialog v-model="dialog" width="600">
                    <template v-slot:activator="{ on, attrs }">
                        <v-btn fab color="secondary" v-bind="attrs" v-on="on" small>
                            <v-icon>mdi-filter</v-icon>
                        </v-btn>
                    </template>

                    <v-card>
                        <v-card-title class="text-uppercase primary--text text-h6 py-2">Filtros</v-card-title>
                        <v-divider></v-divider>
                        <v-card-text>
                            <v-row dense>
                                <v-col cols="12" md="6">
                                    <v-text-field v-model="filters.clave" label="Clave" hide-details="auto" clearable dense outlined></v-text-field>
                                </v-col>

                                <v-col cols="12" md="6">
                                    <v-select v-model="filters.dirigido_a" label="Dirigido" :items="dirigido" item-text="descripcion" item-value="valor" hide-details clearable outlined dense>
                                        <template v-slot:prepend-inner>
                                            <div class="d-flex align-center" style="height: 25px;">
                                                <v-icon size="medium">
                                                    mdi-minus
                                                </v-icon>
                                                <v-divider class="mx-1" vertical></v-divider>
                                            </div>
                                        </template>
                                    </v-select>
                                </v-col>

                                <v-col cols="12" md="6">
                                    <v-select v-model="filters.modelo_id" label="Modelo" :items="modelos" item-text="nombre" item-value="id" hide-details clearable outlined dense>
                                        <template v-slot:prepend-inner>
                                            <div class="d-flex align-center" style="height: 25px;">
                                                <v-icon size="medium">
                                                    mdi-minus
                                                </v-icon>
                                                <v-divider class="mx-1" vertical></v-divider>
                                            </div>
                                        </template>
                                    </v-select>
                                </v-col>

                                <v-col cols="12" md="6">
                                    <v-select v-model="filters.complejidad_id" label="Complejidad" :items="complejidades.items" item-text="txtdescripcion" item-value="iid" hide-details clearable outlined dense>
                                        <template v-slot:prepend-inner>
                                            <div class="d-flex align-center" style="height: 25px;">
                                                <v-icon size="medium">
                                                    mdi-minus
                                                </v-icon>
                                                <v-divider class="mx-1" vertical></v-divider>
                                            </div>
                                        </template>
                                    </v-select>
                                </v-col>
                            </v-row>
                        </v-card-text>

                        <v-divider></v-divider>
                        <v-card-actions class="justify-end py-2">
                            <v-spacer></v-spacer>
                            <v-btn color="warning" text @click="cleanFilters">
                                Limpiar
                            </v-btn>
                            <v-btn color="error" text @click="closeFilters">
                                Cerrar
                            </v-btn>
                            <v-btn color="primary" text @click="applyFilters">
                                Aplicar
                            </v-btn>
                        </v-card-actions>
                    </v-card>
                </v-dialog>
            </v-badge>
        </v-toolbar>
    </v-card>
</template>

<script>
import services from '@/services';
import { mapActions, mapState } from 'vuex';

export default {
    name: "ActividadesFilters",
    data() {
        return {
            dirigido: [],
            modelos: [],
            complejidades: [],
            dialog: false,
            filters: {
                clave: '',
                modelo_id: '',
                complejidad_id: '',
                dirigido_a: ''
            },
        };
    },
    computed: {
        ...mapState('app', ['actividadesFilters']),
        activeFilters() {
            let length = 0;
            if(this.filters.clave != '')
                length++;
            if(this.filters.modelo_id != '')
                length++;
            if(this.filters.complejidad_id != '')
                length++;
            if(this.filters.dirigido_a != '')
                length++;

            return length;
        }
    },
    methods: {
        ...mapActions('app', ['getActividades', 'showError']),
        cleanFilters() {
            this.filters = { clave: '', modelo_id: '', complejidad_id: '', dirigido_a: ''};
        },
        async applyFilters() {
            const filters = this.filters;
            await this.getActividades({ filters });
            this.dialog = false;
        },
        closeFilters() {
            this.filters = { clave: '', modelo_id: '', complejidad_id: '', dirigido_a: ''};
            this.dialog = false;
        },
        newActividad() {
            this.$router.push("/mantenimiento/actividades/new");
        },
    },
    async mounted() {
        this.complejidades  = await services.mantounidades().getComplejidad();
        this.dirigido       = [{ valor: 'vehiculo', descripcion : 'Vehículos' },{valor:'equipo_de_carga', descripcion : 'Equipos de carga'}];
        this.modelos        = await services.mantounidades().getModelos();
    },
};
</script>