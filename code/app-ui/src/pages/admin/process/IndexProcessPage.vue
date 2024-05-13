<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <process-filters />
            </v-col>
            <!-- <v-col cols="12" class="pa-0 mt-2">
                <process-datatable />
            </v-col> -->
        </v-row>
    </v-container>
</template>

<script>
// import services from '@/services';  
import ProcessFilters from "@/pages/admin/process/components/ProcessFilters.vue";
// import ProcessDatatable from "@/pages/inspections/process/components/ProcessDatatable.vue";
export default {
    name: 'ProcessPage',
    components: {
        ProcessFilters,
        // ProcessDatatable
    },
    data() {
        return {
            data: ''
        }
    },

}
</script>

<style lang="scss" scoped></style>