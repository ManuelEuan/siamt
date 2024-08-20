<template>
    <v-card flat>
        <v-toolbar>
            <v-toolbar-title>Carga de trabajo</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-tooltip v-if="permissions.includes('cric')" top>
                <template v-slot:activator="{ on, attrs }">
                    <v-btn color="primary" class="me-1" @click="newWorkload" v-bind="attrs" v-on="on">
                        <v-icon> mdi-face-man-profile </v-icon>
                    </v-btn>
                </template>
                <span>Agregar carga de trabajo</span>
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
                                    <v-text-field v-model="filters.name" label="Nombre" hide-details="auto" clearable dense outlined></v-text-field>
                                </v-col>
                                <v-col cols="12" md="6">
                                    <v-text-field v-model="filters.tarjeton" label="Tarjetón" hide-details="auto" clearable dense outlined></v-text-field>
                                </v-col>
                                <v-col cols="12" md="6">
                                    <v-text-field v-model="filters.etapa" label="Etapa" hide-details="auto" clearable dense outlined></v-text-field>
                                </v-col>
                                <v-col cols="12" md="6">
                                    <v-text-field v-model="filters.turno" label="Turno" hide-details="auto" clearable dense outlined></v-text-field>
                                </v-col>
                                <v-col cols="12" md="6">
                                    <v-text-field v-model="filters.categoria" label="Categoría" hide-details="auto" clearable dense outlined></v-text-field>
                                </v-col>
                                <v-col cols="12" md="6">
                                    <v-select v-model="filters.active" label="Activo" :items="items.active" item-text="text" item-value="value" hide-details clearable outlined dense>
                                        <template v-slot:prepend-inner>
                                            <div class="d-flex align-center" style="height: 25px;">
                                                <v-icon v-if="filters.active==='t'" size="medium" color="green">
                                                    mdi-check
                                                </v-icon>
                                                <v-icon v-else-if="filters.active==='f'" size="medium" color="red">
                                                    mdi-close
                                                </v-icon>
                                                <v-icon v-else size="medium">
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
    // import { mapActions,mapState } from 'vuex';
    import { mapActions } from 'vuex';
    
    export default {
        name: "WorkloadsFilters",
        data() {
            return {
                dialog: false,
                permissions: [],
                filters: {
                    active: '',
                    name: '',
                    tarjeton: '',
                    etapa: '',
                    turno: '',
                    categoria: '',
                },
                items: {
                    active: [
                        { text: 'activo', value: 't' },
                        { text: 'inactivo', value: 'f' },
                    ],
                    roles: [],
                },
            };
        },
        computed: {
            // ...mapState('app', ['workloadsFilters']),
            // activeFilters() {
            //     return Object
            //         .values(this.workloadsFilters)
            //         .filter(v => v && (typeof (v) === 'string' ? v.trim() : v.length))
            //         .length;
            // }
        },
        methods: {
            ...mapActions('app', ['getWorkloads', 'showError']),
            cleanFilters() {
                this.filters = { active: '', name: '', username: '', roles: [] };
            },
            async applyFilters() {
                const filters = this.filters;
                await this.getWorkloads({ filters });
                this.dialog = false;
            },
            closeFilters() {
                this.filters = { ...this.workloadsFilters };
                this.dialog = false;
            },
            newWorkload() {
                this.$router.push("/inspections/workloads/new");
            },
        },
        async mounted() {
            try {
                const response = await services.admin().getRoles();
                this.items.roles = response.map(({ id, nombre }) => ({ id, nombre }));
            } catch (error) {
                const message = 'Error al cargar opciones de filtrado.';
                this.showError({ message, error });
            }
            const hola = await services.security().getPermissions();
            console.log('---------------------------------------------hola')
            console.log(hola)
            // console.log(hola)
            const { ica } = await services.security().getPermissions();
            if (ica) this.permissions = ica;
            console.log(this.permissions)
        },
    };
    </script>
    