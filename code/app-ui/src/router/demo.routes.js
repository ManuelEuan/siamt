export default [
    // MOSTRAR ESPECIFICACIONES DE COMPONENTES
    {
        path: '/genericComponentsRequiredProps',
        name: 'genericComponentsRequiredProps',
        component: () => import(/* webpackChunkName: "blank" */ '@/components/demo/Index.vue'),
        meta: {
            layout: 'default',
            code: 'ooo',
            // parentCode: 'ins'
        }
    },
    // MOSTRAR FUNCIONALIDAD DE COMPONENTES GENÉRICOS NO REQUIEREN PROPS (componente directo)
    {
        path: '/curp-demo',
        name: 'curp-demo',
        component: () => import(/* webpackChunkName: "events-edit" */ '@/components/common/CurpVerification.vue'),
    }, 

    // MOSTRAR FUNCIONALIDAD DE COMPONENTES GENÉRICOS NO REQUIEREN PROPS (componente demo con solo datos necesarios para invocación)
    // 
    {
        path: '/generic-process-flow-demo',
        name: 'generic-process-flow-demo',
        component: () => import(/* webpackChunkName: "blank" */ '@/components/demo/GenericProcessFlow.vue'),
        meta: {
            layout: 'default',
            code: 'fip',
            parentCode: 'ooo'
        }
    },
    {
        path: '/generic-form-validation',
        name: 'generic-form-validation',
        component: () => import(/* webpackChunkName: "blank" */ '@/components/demo/DemoGenericFormValidation.vue'),
        meta: {
            layout: 'default',
            code: 'fip',
            parentCode: 'ooo'
        }
    },

]
