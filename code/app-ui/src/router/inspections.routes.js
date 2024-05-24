export default [
    // MOÓDULO PADRE INSPECCIONES
    {
        path: '',
        name: '',
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
        path: '/inspections/inspectors/new',
        name: 'inspectors-new',
        component: () => import(/* webpackChunkName: "events-edit" */ '@/pages/inspections/inspectors/EditInspectorPage.vue'),
        meta: {
            layout: 'default',
            code: 'iin',
            parentCode: 'ins'
        }
    }, 
    {
        path: '/inspections/inspectors/:id/edit',
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
        path: '/inspections/workloads',
        name: 'workloads',
        component: () => import(/* webpackChunkName: "debsons" */ '@/pages/inspections/workloads/IndexWorkloadPage.vue'),
        meta: {
            layout: 'default',
            code: 'ica',
            // parentCode: 'ins'
        }
    },
    {
        path: '/inspections/workloads/new',
        name: 'workloads-new',
        component: () => import(/* webpackChunkName: "events-edit" */ '@/pages/inspections/workloads/EditWorkloadPage.vue'),
        meta: {
            layout: 'default',
            code: 'iin',
            parentCode: 'ica'
        }
    }, 
    // MÓDULO EXTRA
    {
        path: '/inspections/works',
        name: 'works',
        component: () => import(/* webpackChunkName: "debsons" */ '@/pages/inspections/works/IndexWorkPage.vue'),
        meta: {
            layout: 'default',
            code: 'itr',
            // parentCode: 'ins'
        }
    },
    {
        path: '/inspections/works/new',
        name: 'works-new',
        component: () => import(/* webpackChunkName: "events-edit" */ '@/pages/inspections/works/EditWorkPage.vue'),
        meta: {
            layout: 'default',
            code: 'iin',
            parentCode: 'ica'
        }
    }, 
    

]
