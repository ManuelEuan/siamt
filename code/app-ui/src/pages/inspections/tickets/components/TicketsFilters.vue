<template>
    <v-card flat>
        <v-toolbar>
            <v-toolbar-title>Boletas</v-toolbar-title>
            <v-spacer></v-spacer>
            <!-- <v-tooltip v-if="permissions.includes('crit')" top>
                <template v-slot:activator="{ on, attrs }">
                    <v-btn color="primary" class="me-1" @click="newWork" v-bind="attrs" v-on="on">
                        <v-icon> mdi-face-man-profile </v-icon>
                    </v-btn>
                </template>
<span>Agregar trabajo</span>
</v-tooltip> -->
            <!-- <v-tooltip v-if="permissions.includes('crit')" top>
                <template v-slot:activator="{ on, attrs }">
                    <v-btn color="primary" class="me-1" @click="dialogDownload = true" v-bind="attrs" v-on="on">
                        <v-icon> mdi-download </v-icon>
                    </v-btn>
                </template>
                <span>Descargar boletas</span>
            </v-tooltip> -->
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
                                    <v-text-field v-model="filters.nombre_empleado" label="Nombre empleado"
                                        hide-details="auto" clearable dense outlined></v-text-field>
                                </v-col>
                                <v-col cols="12" md="6">
                                    <v-text-field v-model="filters.nombre_infractor" label="Nombre infractor"
                                        hide-details="auto" clearable dense outlined></v-text-field>
                                </v-col>
                                <v-col cols="12" md="6">
                                    <v-select v-model="filters.active" label="Activo" :items="items.active"
                                        item-text="text" item-value="value" hide-details clearable outlined dense>
                                        <template v-slot:prepend-inner>
                                            <div class="d-flex align-center" style="height: 25px;">
                                                <v-icon v-if="filters.active === 't'" size="medium" color="green">
                                                    mdi-check
                                                </v-icon>
                                                <v-icon v-else-if="filters.active === 'f'" size="medium" color="red">
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
                                <v-divider></v-divider>
                                <v-col cols="12" md="12">
                                    Para descargar datos puede seleccionar alguna opción de su preferencia, se aplicarán
                                    los filtros
                                    marcados en esta ventana
                                </v-col>
                                <v-col v-for="option in optionDownload" :key="option.id" cols="12" md="4">
                                    <v-list dense @click="selectOption(option)">
                                        <v-list-item style="cursor: pointer !important;">
                                            <v-list-item-icon>
                                                <v-icon :color="selectedOption === option ? 'primary' : ''">{{
                                                    option.icon
                                                }}</v-icon>
                                            </v-list-item-icon>
                                            <v-list-item-title>{{ option.name }}</v-list-item-title>
                                        </v-list-item>
                                    </v-list>
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
                            <v-btn color="info" text @click="downloadTickets()">
                                Descargar
                            </v-btn>
                            <v-btn color="primary" text @click="applyFilters()">
                                Aplicar
                            </v-btn>
                        </v-card-actions>
                    </v-card>
                </v-dialog>
            </v-badge>
        </v-toolbar>
        <!-- DIALOGDOWNLOAD -->
        <!-- <generic-dialog :dialogVisible="dialogDownload" dialogTitle="Descarga"
            @update:dialogVisible="dialogDownload = $event" @confirm="downloadTickets()">
            <template v-slot:default>
                Seleccione las carácterísticas para su Descarga
                <v-row dense>
                    <v-col v-for="option in optionDownload" :key="option.id" cols="12" md="4">
                        <v-list dense @click="selectOption(option)">
                            <v-list-item style="cursor: pointer !important;">
                                <v-list-item-icon>
                                    <v-icon :color="selectedOption === option ? 'primary' : ''">{{ option.icon
                                        }}</v-icon>
                                </v-list-item-icon>
                                <v-list-item-title>{{ option.name }}</v-list-item-title>
                            </v-list-item>
                        </v-list>
                    </v-col>
                    <v-divider></v-divider>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="downloads.nombre_empleado" label="Nombre empleado" hide-details="auto"
                            clearable dense outlined></v-text-field>
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="downloads.nombre_infractor" label="Nombre infractor" hide-details="auto"
                            clearable dense outlined></v-text-field>
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-select v-model="downloads.active" label="Activo" :items="items.active" item-text="text"
                            item-value="value" hide-details clearable outlined dense>
                            <template v-slot:prepend-inner>
                                <div class="d-flex align-center" style="height: 25px;">
                                    <v-icon v-if="filters.active === 't'" size="medium" color="green">
                                        mdi-check
                                    </v-icon>
                                    <v-icon v-else-if="filters.active === 'f'" size="medium" color="red">
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
            </template>
        </generic-dialog> -->
    </v-card>
</template>

<script>
// import GenericDialog from '@/components/common/GenericDialog.vue';
import services from '@/services';
import { mapActions, mapState } from 'vuex';
// import { mapActions } from 'vuex';

export default {
    name: "TicketsFilters",
    components: {
        // GenericDialog,
    },
    data() {
        return {
            sortBy: ['nombre_infractor'],//nombre
            sortDesc: [false],
            optionDownload: [
                { id: 1, name: 'Descargar Excel', type: 'xlsx', icon: 'mdi-file-excel-box' },
                { id: 2, name: 'Descargar PDF', type: 'pdf', icon: 'mdi-file-pdf-box' },
                { id: 3, name: 'Descargar Word', type: 'word', icon: 'mdi-file-word-box' }
            ],
            selectedOption: null,
            dialogDownload: false,
            dialog: false,
            permissions: [],
            filters: {
                active: '',
                nombre_infractor: '',
                nombre_empleado: '',
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
        ...mapState('app', ['ticketsFilters']),
        activeFilters() {
            return Object
                .values(this.ticketsFilters)
                .filter(v => v && (typeof (v) === 'string' ? v.trim() : v.length))
                .length;
        }
    },
    methods: {
        selectOption(option) {
            this.selectedOption = option;
        },
        ...mapActions('app', ['getTickets', 'showError']),
        cleanFilters() {
            this.filters = { active: '', nombre_empleado: '', nombre_infractor: '' };
        },
        applyFilters() {
            const filters = this.filters;
            this.getTickets({ filters });
            this.dialog = false;
        },
        async downloadTickets() {
            const filters = this.filters;
            filters.type = this.selectedOption.type
            console.log('vamosss')
            console.log(filters)
            // let hola = await services.inspections().downloadTickets({'filters': filters, 'sortBy': this.sortBy, 'sortDesc': this.sortDesc})
            let hola = await services.inspections().downloadTickets({'filters': filters, 'sortBy': this.sortBy, 'sortDesc': this.sortDesc})
            console.log('hola')
            console.log(hola)
            // var linkSource = 'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,'+ hola.file ;
            //     var downloadLink = document.createElement("a");
            //     var fileName = hola.filename;

            //     downloadLink.href = linkSource;
            //     downloadLink.download = fileName;
            //     downloadLink.click();
            let downloadLink = document.createElement("a");
            downloadLink.href = hola.ruta;
            downloadLink.download = hola.filename;
            downloadLink.click();
            this.dialog = false;
        },
        closeFilters() {
            this.filters = { ...this.ticketsFilters };
            this.dialog = false;
        },
        // async downloadTickets() {
        //     try {
        //         console.log('entre download')
        //         console.log(this.downloads)
        //         this.downloads.type = this.selectedOption.type
        //         const response = await services.inspections().downloadTickets({'download' : this.downloads});
        //         console.log(response)
        //     } catch (error) {
        //         const message = 'Error al cargar opciones de filtrado.';
        //         this.showError({ message, error });
        //     }
        // }
        // newWork() {
        //     this.$router.push("/tickets/new");
        // },
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
        const { itr } = await services.security().getPermissions();
        if (itr) this.permissions = itr;
        console.log(this.permissions)
    },
};
</script>