<template>
<v-container fluid>
    <v-row justify="center">
        <curp-verification @person-info="handlePersonInfo" ref="curpVerification"></curp-verification>
        
        <!-- <v-col cols="12" class="pa-0">
            <works-filters />
        </v-col> -->
    </v-row>
</v-container>
</template>

<script>
// import services from '@/services';  
// import WorksFilters from "@/pages/inspections/works/components/WorksFilters.vue";
// import WorksDatatable from "@/pages/inspections/works/components/WorksDatatable.vue";
import CurpVerification from '@/components/common/CurpVerification.vue';

export default {
    name: 'InspectorsPage',
    components: {
        // WorksFilters,
        // WorksDatatable
        CurpVerification,

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
