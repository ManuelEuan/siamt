export default [
    {
        path: '/mantenimiento-unidades',
        name: 'mantenimiento-unidades',
        component: () => import(/* webpackChunkName: "persons" */ '@/pages/admin/mantoUnidades/IndexPage.vue'),
        meta: {
            layout: 'default',
            code: 'mto'
        }
    }
]
