<template>
<v-container fluid>
    <v-row justify="center">
        <!-- Ejemplo de vista consumiendo desde api: {{ data }} -->
        <v-col cols="12" class="pa-0">
            <companies-filters />
        </v-col>
        <v-col cols="12" class="pa-0 mt-2">
            <companies-datatable />
        </v-col>
    </v-row>
</v-container>
</template>

<script>
// import services from '@/services';  
import CompaniesFilters from "@/pages/admin/companies/components/CompaniesFilters.vue";
import CompaniesDatatable from "@/pages/admin/companies/components/CompaniesDatatable.vue";
export default {
    name: 'CompaniesPage',
    components: {
        CompaniesFilters,
        CompaniesDatatable,
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
