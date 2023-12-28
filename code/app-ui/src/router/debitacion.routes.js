export default [
    {
        path: '/debitacion',
        name: 'debitacion',
        component: () => import(/* webpackChunkName: "persons" */ '@/pages/debitaciones/IndexPage.vue'),
        meta: {
            layout: 'default',
            code: 'deb'
        }
    }
]
