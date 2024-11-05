<template>

<v-card
    flat
>
    <v-card-title>
        Filtros
    </v-card-title>
    <v-card-text>
        <v-container class="pb-0">
        <v-row justify = "center">
            <v-col cols = "12" sm = "6" justify = "center" class="pa-0">
                <v-dialog
                    ref="dialogInicio"
                    v-model="modalFechaInicio"
                    :return-value.sync="filters.initDate"
                    persistent
                    width="290px"
                >
                    <template v-slot:activator="{ on, attrs }">
                    <v-text-field
                        v-model="filters.initDate"
                        label="Clic para seleccionar fecha inicial"
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
                    :max = "filters.endDate"
                    >
                    <v-spacer></v-spacer>
                    <v-btn
                        text
                        color="primary"
                        @click="modalFechaInicio = false"
                    >
                        Cancelar
                    </v-btn>
                    <v-btn
                        text
                        color="primary"
                        @click="$refs.dialogInicio.save(filters.initDate)"
                    >
                        Aceptar
                    </v-btn>
                    </v-date-picker>
                </v-dialog>
            </v-col>
            <v-col cols = "12" sm = "6" justify = "center" class="pa-0">
                <v-dialog
                    ref="dialogFinal"
                    v-model="modalFechaFinal"
                    :return-value.sync="filters.endDate"
                    persistent
                    width="290px"
                >
                    <template v-slot:activator="{ on, attrs }">
                    <v-text-field
                        v-model="filters.endDate"
                        label="Clic para seleccionar fecha final"
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
                    :min = "filters.initDate"
                    >
                    <v-spacer></v-spacer>
                    <v-btn
                        text
                        color="primary"
                        @click="modalFechaFinal = false"
                    >
                        Cancelar
                    </v-btn>
                    <v-btn
                        text
                        color="primary"
                        @click="$refs.dialogFinal.save(filters.endDate)"
                    >
                        Aceptar
                    </v-btn>
                    </v-date-picker>
                </v-dialog>
            </v-col>
            <v-col cols = "12" justify = "center" class="pa-0 pt-2">
                <v-btn color="primary"
                    @click="applyFilters()"
                >
                    Aplicar
                </v-btn>
            </v-col>
        </v-row>
    </v-container>
    </v-card-text>
</v-card>



   
</template>
<script>
export default {
    data() {
        return {
            modalFechaInicio : false,
            modalFechaFinal : false,
            filters : {
                initDate : "",
                endDate : ""
            }
        }
    },
    methods: {
        applyFilters() {
            console.log(this.filters);
            this.$emit('applyfilters',this.filters);
        }
    },
}
</script>
<style>
    
</style>