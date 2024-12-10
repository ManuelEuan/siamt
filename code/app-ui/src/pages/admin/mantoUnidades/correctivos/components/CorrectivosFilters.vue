<template>
    <v-card flat>
        <v-toolbar>
            <v-toolbar-title>Correctivos</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-tooltip top>
                <template v-slot:activator="{ on, attrs }">
                    <v-btn color="primary" class="me-1" @click="newCorrectivo" v-bind="attrs" v-on="on">
                        <v-icon>mdi-format-list-bulleted</v-icon>
                    </v-btn>
                </template>
                <span>Agregar correctivo</span>
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
                                    <v-text-field v-model="filters.empresa_id" label="Empresa" hide-details="auto" clearable dense outlined></v-text-field>
                                </v-col>
                                <v-col cols="12" md="6">
                                    <v-text-field v-model="filters.marca_id" label="Marca" hide-details="auto" clearable dense outlined></v-text-field>
                                </v-col>

                                <v-col cols="12" md="6">
                                    <v-text-field v-model="filters.modelo_id" label="Modelo" hide-details="auto" clearable dense outlined></v-text-field>
                                </v-col>

                                <v-col cols="12" md="6">
                                    <v-text-field v-model="filters.unidad_id" label="Serie" hide-details="auto" clearable dense outlined></v-text-field>
                                </v-col>

                                <v-col cols="6">
                                    <v-autocomplete label="Estatus" :items="estatus.items" hide-details="auto" clearable dense outlined 
                                        v-model="filters.estatus_id" item-text="txtdescripcion" item-value="iid" ></v-autocomplete>
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
    name: "CorrectivosFilters",
    data() {
        return {
            dialog: false,
            empresas: [],
            marcas: [],
            modelos: [],
            estatus: [],
            filters: {
                empresa_id: '',
                marca_id: '',
                modelo_id: '',
                estatus_id: '',
                unidad_id: ''              
            },
        };
    },
    computed: {
        ...mapState('app', ['correctivosFilters']),
        activeFilters() {
            let length = 0;
            Object.keys(this.filters).forEach((key) => {
                if (this.filters[key] !== '' && key !== 'fechaIngresoMenu') {
                    length++;
                }
            });
            return length;
        }
    },
    methods: {
        ...mapActions('app', ['getCorrectivos', 'showError']),
        cleanFilters() {
            this.filters = {
                empresa_id: '',
                marca_id: '',
                modelo_id: '',
                estatus_id: '',
                unidad_id: ''     
            };
        },
        async applyFilters() {
            const filters = { ...this.filters };
            delete filters.fechaIngresoMenu; // Remover propiedades auxiliares
            await this.getCorrectivos({ filters });
            this.dialog = false;
        },
        closeFilters() {
            this.cleanFilters();
            this.dialog = false;
        },
        newCorrectivo() {
            this.$router.push("/mantenimiento/correctivos/new");
        },
    },
    async mounted() {
        this.empresas   = await services.mantounidades().getComplejidad();
        this.marcas     = [{ valor: 'vehiculo', descripcion : 'Vehículos' },{valor:'equipo_de_carga', descripcion : 'Equipos de carga'}];
        this.modelos    = await services.mantounidades().getModelos();
        this.estatus    = await services.mantounidades().getEstatus({tipo:'correctivo'});
        console.log(this.estatus);
    },
};
</script>
