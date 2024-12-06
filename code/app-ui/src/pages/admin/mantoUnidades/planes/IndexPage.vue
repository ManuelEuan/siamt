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
                                    <v-btn v-bind="attrs" v-on="on" icon small @click="view(item)">
                                    <v-icon small> mdi-eye </v-icon> </v-btn>
                                </template>
                                <span>Ver Plan</span>
                            </v-tooltip>

                            <v-tooltip bottom>
                                <template v-slot:activator="{ on, attrs }">
                                    <v-btn v-bind="attrs"  v-on="on"  icon  small @click="actionsHandler(item, 'edit')">
                                        <v-icon small> mdi-square-edit-outline </v-icon>
                                    </v-btn>
                                </template>
                                <span>Editar</span>
                            </v-tooltip>

                            <v-tooltip bottom>
                                <template v-slot:activator="{ on, attrs }">
                                    <v-btn v-bind="attrs"  v-on="on"  icon  small @click="actionsHandler(item, 'delete')" >
                                        <v-icon small v-show="item.bactivo"> mdi-delete </v-icon>
                                    </v-btn>
                                </template>
                                <span>Eliminar</span>
                            </v-tooltip>
                        </template>
                    </v-data-table>
                </div>
            </v-col>

            <div class="wrapper">
                <v-dialog transition="dialog-top-transition" max-width="600" v-model="show.view">
                <v-card v-model="show.info">
                    <v-card-title class="text-uppercase primary--text text-h6 py-2"> {{ tituloModal }} </v-card-title>
                    <v-divider></v-divider>
                    <v-card-text class="py-0 my-0">
                    <v-list class="pa-0 ma-0">
                        <v-container class="pa-0 ma-0">
                            <template v-if="this.show.info">
                                <v-row dense>
                                    <template v-for="(value, key, index) in datos">
                                        <v-col class="pa-0 ma-0" cols="6" :key="index">
                                            <v-list-item>
                                            <v-list-item-content class="py-2">
                                                <v-list-item-title class="text-capitalize text-h7">
                                                {{ value.titulo }}
                                                </v-list-item-title>

                                                <v-list-item-subtitle class="text-body-1 py-1">
                                                {{ value.valor }}
                                                </v-list-item-subtitle>
                                            </v-list-item-content>
                                            </v-list-item>
                                        </v-col>
                                    </template>
                                </v-row>

                                <v-row dense>
                                    <template >
                                        <v-col class="pa-0 ma-0" cols="12" >
                                            <v-list-item>
                                            <v-list-item-content class="py-2">
                                                <v-list-item-title class="text-capitalize text-h7">
                                                Comentarios
                                                </v-list-item-title>
    
                                                <v-list-item-subtitle class="text-lowercase text-body-1 py-1">
                                                    <v-textarea v-model="this.plan.comentarios" rows="3" disabled hide-details="auto" clearable dense outlined />
                                                </v-list-item-subtitle>
                                            </v-list-item-content>
                                            </v-list-item>
                                        </v-col>
                                    </template>
                                </v-row>
                            </template>

                            <template v-if="this.show.delete">
                                <v-card-text class="text-body-1 py-2"> ¿Estás seguro de que deseas eliminar este plan? </v-card-text>
                                <v-divider></v-divider>
                            </template>
                        </v-container>
                    </v-list>
                    </v-card-text>
                    <v-divider></v-divider>

                    <v-card-actions class="py-2">
                    <v-spacer></v-spacer>
                    <v-btn color="error" text @click="show.view = false"> Cerrar </v-btn>
                        <v-btn color="primary" text v-if="this.show.delete" @click="deletePlan" >  Aceptar </v-btn>
                    </v-card-actions>
                </v-card>
                </v-dialog>
            </div>
        </v-row>
    </v-container>
</template>

<script>  
    import services from "@/services";
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
                show: {
                    view: false,
                    delete: false,
                    info: false,
                },
                plan: {
                    id:'',
                    comentarios: ''
                },
                tituloModal:''
            }
        },
        computed: {
            ...mapState('app', ['planes', 'planesTotalPages', 'planesTotalItems']),
        },
        methods: {
            ...mapActions('app', ['getPlanes','showError', 'showSuccess']),
            async loadPlanesTable() {
                const { page, itemsPerPage, sortBy, sortDesc } = this.options;
                const data = { page, itemsPerPage, sortBy, sortDesc }; 
                
                this.getPlanes({ data });
                this.loadingTable = false;
            },
            actionsHandler(plan, action) {
                switch (action) {
                    case 'new':
                        this.$router.push(`/mantenimiento/planes/new`); 
                        break;
                    case 'edit': 
                        this.$router.push(`/mantenimiento/planes/${plan.iid}/edit`);
                        break;
                    case 'delete': 
                        this.plan.id   = plan.iid;
                        this.tituloModal = 'Eliminar el plan';
                        this.show.view = true;
                        this.show.info = false;
                        this.show.delete = true;
                        break
                }
            },
            async view(item) {
                try {
                    this.tituloModal = 'ver informacion';
                    this.datos = [
                        { titulo: 'Nombre', valor: item.vnombre  },
                        { titulo: 'Modelo', valor: 'Pendiente'  },
                        { titulo: 'Cliclo', valor: item.iciclo },
                        { titulo: 'Meses', valor: item.imeses    },
                    ];

                    this.plan.comentarios = item.txtcomentarios;
                    this.show.view = true;
                    this.show.info = true;
                    this.show.delete = false;
                }
                catch (error) {
                    console.log(error);
                }
            },
            async deletePlan() {
                try {
                    const { message } = await services.mantounidades().deletePlan(this.plan.id);
                    this.loadPlanesTable();
                    this.showSuccess(message);
                } catch (error) {
                    console.log(error);
                    const message = 'Error al activar/desactivar actividad.';
                    this.showError({ message, error });
                }

                this.show.view = false;
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