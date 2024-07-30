export default [
    {
        path: '/modules',
        name: 'modules',
        component: () => import(/* webpackChunkName: "persons" */ '@/pages/admin/modules/ModulesPage.vue'),
        meta: {
            layout: 'default',
            code: 'mdl'
        }
    },
    {
        path: '/modules/new',
        name: 'modules-new',
        component: () => import(/* webpackChunkName: "events-edit" */ '@/pages/admin/modules/EditModulePage.vue'),
        meta: {
            layout: 'default',
            code: 'nus',
            parentCode: 'mdl'
        }
    },
    {
        path: '/modules/:id/edit',
        name: 'modules-edit',
        component: () => import(/* webpackChunkName: "events-edit" */ '@/pages/admin/modules/EditModulePage.vue'),
        meta: {
            layout: 'default',
            code: 'tus',
            parentCode: 'mdl'
        }
    }
]
