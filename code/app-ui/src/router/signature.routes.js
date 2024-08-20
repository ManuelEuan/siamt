export default [
    {
        path: '/firms/dashboard',
        name: 'Firmas - Dashboard',
        component: () => import(/* webpackChunkName: "blank" */ '@/pages/signature/Dashboard.vue'),
        meta: {
            layout: 'default',
            code: 'fit'
        }
    },
    {
        path: '/firms/firms',
        name: 'Firmas - Firmas',
        component: () => import(/* webpackChunkName: "blank" */ '@/pages/signature/Firms.vue'),
        meta: {
            layout: 'default',
            code: 'fif'
        }
    },
    {
        path: '/firms/templates',
        name: 'Firmas - Plantillas',
        component: () => import(/* webpackChunkName: "blank" */ '@/pages/signature/Templates.vue'),
        meta: {
            layout: 'default',
            code: 'fip'
        }
    },
]
