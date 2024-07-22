<template>
<v-container fluid>
    <v-row justify="center">
        <!-- Ejemplo de vista consumiendo desde api: {{ data }} -->
        <v-col cols="12" class="pa-0">
            <workloads-filters />
        </v-col>
        <v-col cols="12" class="pa-0 mt-2">
            datatable workload
            <!-- <workloads-datatable /> -->
        </v-col>
    </v-row>
</v-container>
</template>

<script>
// import services from '@/services';  
import WorkloadsFilters from "@/pages/inspections/workloads/components/WorkloadsFilters.vue";
// import WorkloadsDatatable from "@/pages/inspections/workloads/components/WorkloadsDatatable.vue";
export default {
    name: 'InspectorsPage',
    components: {
        WorkloadsFilters,
        // WorkloadsDatatable
    },
    data() {
        return {
            data: ''
        }
    },
//     async mounted(){
//         this.data = await services.inspections().getInspectors();

//   }
}
</script>

<style lang="scss" scoped>

</style>
