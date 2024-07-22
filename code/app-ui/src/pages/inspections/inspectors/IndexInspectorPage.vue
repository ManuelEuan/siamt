<template>
<v-container fluid>
    <v-row justify="center">
        <!-- Ejemplo de vista consumiendo desde api: {{ data }} -->
        <v-col cols="12" class="pa-0">
            <inspectors-filters />
        </v-col>
        <v-col cols="12" class="pa-0 mt-2">
            <inspectors-datatable />
        </v-col>
    </v-row>
</v-container>
</template>

<script>
// import services from '@/services';  
import InspectorsFilters from "@/pages/inspections/inspectors/components/InspectorsFilters.vue";
import InspectorsDatatable from "@/pages/inspections/inspectors/components/InspectorsDatatable.vue";
export default {
    name: 'InspectorsPage',
    components: {
        InspectorsFilters,
        InspectorsDatatable
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
