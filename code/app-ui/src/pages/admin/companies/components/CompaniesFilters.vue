<template>
    <v-card flat>
        <v-toolbar>
            <v-toolbar-title>Empresas</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-tooltip v-if="permissions.includes('crie')" top>
                <template v-slot:activator="{ on, attrs }">
                    <v-btn color="primary" class="me-1" @click="newCompany" v-bind="attrs" v-on="on">
                        <v-icon> mdi-face-man-profile </v-icon>
                    </v-btn>
                </template>
                <span>Agregar empresa</span>
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
    import { mapActions,mapState } from 'vuex';
    
    export default {
        name: "CompaniesFilters",
        data() {
            return {
                dialog: false,
                permissions: [],
                filters: {
                    active: '',
                    name: ''
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
            ...mapState('app', ['companiesFilters']),
            activeFilters() {
                return Object
                    .values(this.companiesFilters)
                    .filter(v => v && (typeof (v) === 'string' ? v.trim() : v.length))
                    .length;
            }
        },
        methods: {
            ...mapActions('app', ['getCompanies', 'showError']),
            cleanFilters() {
                this.filters = { active: '', name: '', username: '', roles: [] };
            },
            async applyFilters() {
                const filters = this.filters;
                await this.getCompanies({ filters });
                this.dialog = false;
            },
            closeFilters() {
                this.filters = { ...this.companiesFilters };
                this.dialog = false;
            },
            newCompany() {
                this.$router.push("/transports/companies/new");
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
            let user = await services.app().getUserConfig();
            this.newRegisterPerson = localStorage.getItem('newPerson') === 'true';
            this.getAllInfoPermissionsFromUser = await services.admin().getActivePermissionsFromUser( user[0].id );
            this.permissions = this.getAllInfoPermissionsFromUser.map(permission => permission.siglas);
        },
    };
    </script>
    