export default [
     // MÓDULO PERSONAS
     {
        path: '/dropdownTwo',
        name: 'dropdownTwo',
        component: () => import(/* webpackChunkName: "debsons" */ '@/pages/inspections/works/IndexWorkPage.vue'),
        meta: {
            layout: 'default',
            code: 'pel',
            // parentCode: 'ins'
        }
    }
]
