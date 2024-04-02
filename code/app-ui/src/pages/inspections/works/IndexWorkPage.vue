<template>
<v-container fluid>
    <v-row justify="center">
        <curp-verification ref="curpVerification"></curp-verification>
        <!-- <curp-verification @person-info="handlePersonInfo" ref="curpVerification"></curp-verification> -->
    </v-row>
        <direction-verification></direction-verification>
</v-container>
</template>

<script>
import CurpVerification from '@/components/common/CurpVerification.vue';
import DirectionVerification from '@/components/common/DirectionVerification.vue';

export default {
    name: 'InspectorsPage',
    components: {
        CurpVerification,
        DirectionVerification,

    },
    data() {
        return {
            data: ''
        }
    },
    methods: {
        handlePersonInfo() {
            
        }
    }
//     async mounted(){
//         this.data = await services.inspections().getInspectors();

//   }
}
</script>

<style lang="scss" scoped>

</style>
