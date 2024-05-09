export default [
    // MÓDULO INSPECCIONES
    {
        path: '/dropdown',
        name: 'dropdown',
        // component: () => import(/* webpackChunkName: "debsons" */ '@/pages/inspections/inspectors/IndexInspectorPage.vue'),
        meta: {
            layout: 'default',
            code: 'ins'
        }
    },
    // MÓDULO INSPECTORES
    {
        path: '/inspections/inspectors',
        name: 'inpsectors',
        component: () => import(/* webpackChunkName: "debsons" */ '@/pages/inspections/inspectors/IndexInspectorPage.vue'),
        meta: {
            layout: 'default',
            code: 'iin',
            parentCode: 'ins'
        }
    },
    {
        path: '/inspectors/new',
        name: 'inspectors-new',
        component: () => import(/* webpackChunkName: "events-edit" */ '@/pages/inspections/inspectors/EditInspectorPage.vue'),
        meta: {
            layout: 'default',
            code: 'iin',
            parentCode: 'ins'
        }
    }, 
    {
        path: '/inspectors/:id/edit',
        name: 'inspectors-edit',
        component: () => import(/* webpackChunkName: "events-edit" */ '@/pages/inspections/inspectors/EditInspectorPage.vue'),
        meta: {
            layout: 'default',
            code: 'iin',
            parentCode: 'ins'
        }
    },

    // MÓDULO CARGAS DE TRABAJO
    {
        path: '/workloads',
        name: 'workloads',
        component: () => import(/* webpackChunkName: "debsons" */ '@/pages/inspections/workloads/IndexWorkloadPage.vue'),
        meta: {
            layout: 'default',
            code: 'ica',
            // parentCode: 'ins'
        }
    },
    {
        path: '/workloads/new',
        name: 'workloads-new',
        component: () => import(/* webpackChunkName: "events-edit" */ '@/pages/inspections/workloads/EditWorkloadPage.vue'),
        meta: {
            layout: 'default',
            code: 'iin',
            parentCode: 'ica'
        }
    }, 
    {
        path: '/process',
        name: 'process',
        component: () => import(/* webpackChunkName: "debsons" */ '@/pages/inspections/works/IndexWorkPage.vue'),
        meta: {
            layout: 'default',
            code: 'pro',
            // parentCode: 'ins'
        }
    },
    // MÓDULO EXTRA
    {
        path: '/works',
        name: 'works',
        component: () => import(/* webpackChunkName: "debsons" */ '@/pages/inspections/works/IndexWorkPage.vue'),
        meta: {
            layout: 'default',
            code: 'itr',
            // parentCode: 'ins'
        }
    },
    {
        path: '/works/new',
        name: 'works-new',
        component: () => import(/* webpackChunkName: "events-edit" */ '@/pages/inspections/works/EditWorkPage.vue'),
        meta: {
            layout: 'default',
            code: 'iin',
            parentCode: 'ica'
        }
    }, 
    {
        path: '/curp-demo',
        name: 'curp-demo',
        component: () => import(/* webpackChunkName: "events-edit" */ '@/components/common/CurpVerification.vue'),
    }, 

]
