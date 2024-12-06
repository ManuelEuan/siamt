<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <v-tooltip top>
                    <template v-slot:activator="{ on, attrs }">
                        <v-btn color="primary" class="me-1" @click="actionsHandler({}, 'new')" v-bind="attrs" v-on="on">
                            Agregar <v-icon> mdi-plus </v-icon>
                        </v-btn>
                    </template>
                    <span>Agregar</span>
                </v-tooltip>
            </v-col>
            <v-col cols="12" class="pa-0 mt-2">
                <div class="wrapper">
                    <v-data-table class="elevation-1" loading-text="Cargando información"
                        :headers="headers"
                        :items="planes"
                        :page-count="planesTotalPages"
                        :server-items-length="planesTotalItems"
                        :options.sync="options"
                        :loading="loadingTable">
                        <template v-slot:item.activo="{ item }">
                            <v-icon v-show="item.activo" size="medium" color="green"> mdi-check </v-icon>
                            <v-icon v-show="!item.activo" size="medium" color="red">mdi-close</v-icon>
                        </template>
                        <template v-slot:item.acciones="{ item }">
                            <v-tooltip bottom>
                                <template v-slot:activator="{ on, attrs }">
                                    <v-btn v-bind="attrs"  v-on="on"  icon  small @click="actionsHandler(item, 'edit')">
                                        <v-icon small> mdi-square-edit-outline </v-icon>
                                    </v-btn>
                                </template>
                                <span>Editar</span>
                            </v-tooltip>
                            <!-- <v-tooltip bottom>
                                <template v-slot:activator="{ on, attrs }">
                                    <v-btn v-bind="attrs"  v-on="on"  icon  small @click="actionsHandler(item, 'delete')" >
                                        <v-icon small v-show="item.bactivo"> mdi-delete </v-icon>
                                    </v-btn>
                                </template>
                                <span>Eliminar</span>
                            </v-tooltip> -->
                        </template>
                    </v-data-table>
                </div>
            </v-col>
        </v-row>
    </v-container>
</template>
<script>  

    import { mapActions, mapState } from "vuex";

    export default {
        name: 'PlanesPage',
        components: {},
        data() {
            return {
                options: {
                    planes: [],
                    page: 1,
                    itemsPerPage: 10,
                    sortBy: ['vnombre'],
                    sortDesc: [false],
                    multiSort: true,
                    mustSort: false,
                },
                loadingTable: true,
                headers: [
                    {
                        text: "Nombre del Plan",
                        value: "vnombre",
                        align: "center",
                        class: "font-weight-bold",
                    },
                    {
                        text: "Modelo",
                        value: "iidmodelo",
                        align: "center",
                        class: "font-weight-bold",
                        sortable: false,
                    },
                    {
                        text: "Ciclo",
                        value: "iciclo",
                        align: "center",
                        class: "font-weight-bold",
                        sortable: false,
                    },
                    {
                        text: "Meses",
                        value: "imeses",
                        align: "center",
                        class: "font-weight-bold",
                        sortable: false,
                    },
                    {
                        text: "Comentarios",
                        value: "txtcomentarios",
                        align: "center",
                        class: "font-weight-bold",
                    },
                    {
                        text: "Acciones",
                        value: "acciones",
                        align: "center",
                        sortable: false,
                        width: "196px",
                    },
                ],
            }
        },
        computed: {
            ...mapState('app', ['planes', 'planesTotalPages', 'planesTotalItems']),
        },
        methods: {
            ...mapActions('app', ['getPlanes']),
            async loadPlanesTable() {
                const { page, itemsPerPage, sortBy, sortDesc } = this.options;
                const data = { page, itemsPerPage, sortBy, sortDesc }; 
                
                this.getPlanes({ data });
                this.loadingTable = false;
            },
            actionsHandler(plan, action) {
                switch (action) {
                    case 'new': this.$router.push(`/mantenimiento/planes/new`); break;
                    case 'edit': this.$router.push(`/mantenimiento/planes/${plan.iid}/edit`); break;
                }
            },
        },
        watch: {
            options: {
                handler() {
                    this.loadPlanesTable();
                },
                deep: true,
            },
        },
    }
</script>
<style lang="scss" scoped></style>