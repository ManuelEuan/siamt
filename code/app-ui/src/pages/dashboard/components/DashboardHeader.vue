<template>
    <v-card flat>
        <v-toolbar>
            <v-toolbar-title class="text--secondary">Dashboard</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-select
                v-model="document"
                label="Seleccione un documento"
                :items="collections.documents"
                item-text="nombre"
                item-value="id"
                name="document"
                hide-details="auto"
                style="max-width: 250px;"
                return-object
                clearable
                @change="changeDocument"
            ></v-select>

            <v-badge
                v-if="documentwithfilters"
                overlap
                :content="numberOfActiveFilters"
                :value="numberOfActiveFilters"
                class="ms-2"
            >
                <v-dialog
                    v-model="filterDialog"
                    max-width="460px"
                >
                    <template v-slot:activator="{ on, attrs }">
                        <v-btn
                            fab
                            color="secondary"
                            v-bind="attrs" v-on="on"
                            small
                        >
                            <v-icon>mdi-filter</v-icon>
                        </v-btn>
                    </template>
                    <v-card flat>
                        <v-card-title>
                            Filtros
                        </v-card-title>
                        <v-card-text>
                            <v-container class="pb-0">
                                <v-row justify="center">
                                    <v-col cols="12" justify="center" class="pa-0">
                                        <v-dialog
                                            v-model="modalFechaInicio"
                                            ref="dialogInicio"
                                            :return-value.sync="filters.initDate"
                                            persistent width="290px"
                                        >
                                            <template v-slot:activator="{ on, attrs }">
                                                <v-text-field
                                                    v-model="filters.initDate"
                                                    label="Fecha inicial"
                                                    prepend-icon="mdi-calendar"
                                                    readonly
                                                    v-bind="attrs"
                                                    v-on="on"
                                                    clearable
                                                ></v-text-field>
                                            </template>
                                            <v-date-picker
                                                v-model="filters.initDate"
                                                scrollable
                                                :max="filters.endDate"
                                            >
                                                <v-spacer></v-spacer>
                                                <v-btn text color="primary" @click="modalFechaInicio = false">
                                                    Cancelar
                                                </v-btn>
                                                <v-btn text color="primary"
                                                    @click="$refs.dialogInicio.save(filters.initDate)">
                                                    Aceptar
                                                </v-btn>
                                            </v-date-picker>
                                        </v-dialog>
                                    </v-col>
                                    <v-col cols="12" justify="center" class="pa-0">
                                        <v-dialog
                                            ref="dialogFinal"
                                            v-model="modalFechaFinal"
                                            :return-value.sync="filters.endDate"
                                            persistent width="290px"
                                        >
                                            <template v-slot:activator="{ on, attrs }">
                                                <v-text-field
                                                    v-model="filters.endDate"
                                                    label="Fecha final"
                                                    prepend-icon="mdi-calendar"
                                                    readonly
                                                    v-bind="attrs"
                                                    v-on="on"
                                                    clearable
                                                ></v-text-field>
                                            </template>
                                            <v-date-picker
                                                v-model="filters.endDate"
                                                scrollable
                                                :min="filters.initDate"
                                            >
                                                <v-spacer></v-spacer>
                                                <v-btn
                                                    text
                                                    color="primary"
                                                    @click="modalFechaFinal = false"
                                                >
                                                    Cancelar
                                                </v-btn>
                                                <v-btn text color="primary"
                                                    @click="$refs.dialogFinal.save(filters.endDate)">
                                                    Aceptar
                                                </v-btn>
                                            </v-date-picker>
                                        </v-dialog>
                                    </v-col>

                                    <v-col cols="12" justify="center" class="pa-0">
                                        <v-autocomplete
                                            v-model="filters.localDistrictId"
                                            :loading="isLoadingLD"
                                            :items="localDistrictList"
                                            :auto-select-first="true"
                                            label="Distrito Local"
                                            item-text="name"
                                            item-value="id"
                                            clearable
                                            placeholder="Buscar Distrito Local"
                                            prepend-icon="mdi-magnify"
                                            @focus="loadLD"
                                            @change="changeLocalDistrict"
                                        ></v-autocomplete>
                                    </v-col>

                                    <v-col cols="12" justify="center" class="pa-0">
                                        <v-autocomplete
                                            v-model="filters.federalDistrictId"
                                            :loading="isLoadingFD"
                                            :items="federalDistrictList"
                                            :auto-select-first="true"
                                            label="Distrito Federal"
                                            item-text="name"
                                            item-value="id"
                                            clearable
                                            placeholder="Buscar Distrito Federal"
                                            prepend-icon="mdi-magnify"
                                            @focus="loadFD"
                                            @change="changeFederalDistrict"
                                        ></v-autocomplete>
                                    </v-col>
                                </v-row>
                            </v-container>
                        </v-card-text>
                        <v-card-actions>
                            <v-spacer></v-spacer>
                            <v-btn color="warning" text @click="cleanFilters">
                                Borrar filtros
                            </v-btn>
                            <v-btn color="danger" text @click="filterDialog = false">
                                Cancelar
                            </v-btn>
                            <v-btn color="primary" text @click="applyFilters()">
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
export default {
    props: {
        collections: Object,
        documentwithfilters: Boolean
    },
    data() {
        return {
            numberOfActiveFilters: 0,
            modalFechaInicio: false,
            modalFechaFinal: false,
            localDistrictList: [],
            federalDistrictList: [],
            filters: {
                initDate: '',
                endDate: '',
                localDistrictId: null,
                federalDistrictId: null,
            },
            isLoadingLD: false,
            isLoadingFD: false,
            filterDialog: false,
            haveFilters: false,
            theCollections: {},
            document: {}
        }
    },
    methods: {
        changeDocument() {
            this.$emit('changedocument', this.document);
        },
        async loadLD() {
            try {
                this.isLoadingLD = true;

                const load = !this.localDistrictList || this.localDistrictList.length === 0;
                if(load) {
                    this.localDistrictList = await services.app().fetchLocalDistrictList();
                }
            } catch (error) {
                this.$rswal.toastError('Lo sentimos, tenemos problemas al intentar cargar los distritos locales.');
            } finally {
                this.isLoadingLD = false;
            }
        },
        async loadFD() {
            try {
                this.isLoadingFD = true;

                const load = !this.federalDistrictList || this.federalDistrictList.length === 0;
                if(load) {
                    this.federalDistrictList = await services.app().fetchFederalDistrictList();
                }
            } catch (error) {
                this.$rswal.toastError('Lo sentimos, tenemos problemas al intentar cargar los distritos federales.');
            } finally {
                this.isLoadingFD = false;
            }
        },
        changeLocalDistrict(ld) {
            if (ld) { this.filters.federalDistrictId = null; }
        },
        changeFederalDistrict(fd) {
            if (fd) { this.filters.localDistrictId = null; }
        },
        applyFilters() {
            this.numberOfActiveFilters = 0;
            // BUG en las dos líneas de abajo
            // this.filters.initDate != null ? this.numberOfActiveFilters++ : null;
            // this.filters.endDate != null ? this.numberOfActiveFilters++ : null;

            if (this.filters.initDate) { this.numberOfActiveFilters++; }
            if (this.filters.endDate) { this.numberOfActiveFilters++; }
            if (this.filters.localDistrictId) { this.numberOfActiveFilters++; }
            if (this.filters.federalDistrictId) { this.numberOfActiveFilters++; }

            this.$emit('applyfilters', this.filters);
            this.filterDialog = false;
        },
        cleanFilters() {
            this.filters.initDate = null;
            this.filters.endDate = null;
            this.filters.localDistrictId = null;
            this.filters.federalDistrictId = null;
            this.$emit('applyfilters', this.filters);
            this.numberOfActiveFilters = 0;
            this.filterDialog = false;
        },
    }
}
</script>
<style></style>