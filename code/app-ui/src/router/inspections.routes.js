export default [
    {
        path: '/dropdown',
        name: 'dropdown',
        // component: () => import(/* webpackChunkName: "debsons" */ '@/pages/inspections/inspectors/IndexInspectorPage.vue'),
        meta: {
            layout: 'default',
            code: 'ins'
        }
    },
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
            code: 'nus',
            parentCode: 'iin'
        }
    }, 
    {
        path: '/inspectors/workloads',
        name: 'workloads',
        component: () => import(/* webpackChunkName: "debsons" */ '@/pages/inspections/workloads/IndexWorkLoadPage.vue'),
        meta: {
            layout: 'default',
            code: 'ica',
            // parentCode: 'ins'
        }
    },
    {
        path: '/demos/inspectorsfge',
        name: 'demosgewgname',
        component: () => import(/* webpackChunkName: "debsons" */ '@/pages/inspections/inspectors/IndexInspectorPage.vue'),
        meta: {
            layout: 'default',
            code: 'ipu',
            parentCode: 'ins'
        }
    },
    {
        path: '/demos/inspectoregwes',
        name: 'demogweegrgsname',
        component: () => import(/* webpackChunkName: "debsons" */ '@/pages/inspections/inspectors/IndexInspectorPage.vue'),
        meta: {
            layout: 'default',
            code: 'iti',
            parentCode: 'ins'
        }
    },
    {
        path: '/demos/inspetjtrjctors',
        name: 'demosnjtejtame',
        component: () => import(/* webpackChunkName: "debsons" */ '@/pages/inspections/inspectors/IndexInspectorPage.vue'),
        meta: {
            layout: 'default',
            code: 'itu',
            parentCode: 'ins'
        }
    }
]
