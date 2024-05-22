export default [
    // MÓDULO PERSONAS
    {
        path: '/persons',
        name: 'persons',
        component: () => import(/* webpackChunkName: "events-edit" */ '@/components/common/CurpVerification.vue'),
        // component: () => import(/* webpackChunkName: "debsons" */ '@/pages/inspections/works/IndexWorkPage.vue'),
        meta: {
            layout: 'default',
            code: 'pel',
            // parentCode: 'ins'
        }
    }
]
