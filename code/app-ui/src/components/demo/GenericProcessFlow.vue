<template>
    <div  style="width: 100%">
        <generic-process-flow :request=request @process-flow="handleProcessFlow"></generic-process-flow>
    </div>
</template>

<script>
import GenericProcessFlow from '@/components/common/GenericProcessFlow.vue';
export default {
    name: 'IndexWork',
    components: {
        GenericProcessFlow,
    },
    data() {
        return {
            request: { //DEMO
                type: 'Inspector', // dinamyc Type
                idOfType: 3, // dinamyc id
                idOfSubStage: 1, //iidsubStage
                idOfNextSubStage: 0, //iidsubStage
                finalizeProcess: false,
            },
        }
    },
    methods: {
        // RETORNO DE COMPONENTE GENÉRICO PROCESS FLOW (AUTOMÁTICO)
        handleProcessFlow(foundSubStage, infoSubStage, processSubStage, hasFlowAfter) {
            console.log('Retornando desde GENERIC PROCESS FLOW ')
            if (foundSubStage) {
                this.SubStage = {
                    info: infoSubStage,
                    process: processSubStage,
                    hasFlowAfter: hasFlowAfter,
                }
                console.log(this.SubStage)
            } else {
                alert('No se encontró registro de la sub etapa')
            }
        },
    }
}
</script>
<style lang="scss" scoped></style>
