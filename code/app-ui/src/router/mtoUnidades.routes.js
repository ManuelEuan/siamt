export default [
    {
        path: '/mantenimiento/actividades',
        name: 'Actividades',
        component: () => import(/* webpackChunkName: "actividad" */ '@/pages/admin/mantoUnidades/actividades/IndexPage.vue'),
        meta: {
            layout: 'default',
            code: 'nus',
            parentCode: 'mdl'
        }
    }, {
        path: '/mantenimiento/actividades/new',
        name: 'actividades-new',
        component: () => import(/* webpackChunkName: "actividad-edit" */ '@/pages/admin/mantoUnidades/actividades/CreatePage.vue'),
        meta: {
            layout: 'default',
            code: 'nus',
            parentCode: 'per'
        }
    }, {
        path: '/mantenimiento/actividades/:id/edit',
        name: 'actividades-edit',
        component: () => import(/* webpackChunkName: "actividad-edit" */ '@/pages/admin/mantoUnidades/actividades/CreatePage.vue'),
        meta: {
            layout: 'default',
            code: 'tus',
            parentCode: 'usr'
        }
    },
]
