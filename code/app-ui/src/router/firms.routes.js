export default [
    {
        path: '/firms',
        name: 'firms',
        component: () => import(/* webpackChunkName: "blank" */ '@/pages/admin/firms/Dashboard.vue'),
        meta: {
            layout: 'default',
            code: 'fir',
            // parentCode: 'ins'
        }
    },
    {
        path: '/firms/dashboard',
        name: 'Firmas - Dashboard',
        component: () => import(/* webpackChunkName: "blank" */ '@/pages/admin/firms/Dashboard.vue'),
        meta: {
            layout: 'default',
            code: 'fit',
            parentCode: 'fir'
        }
    },
    {
        path: '/firms/firms',
        name: 'Firmas - Firmas',
        component: () => import(/* webpackChunkName: "blank" */ '@/pages/admin/firms/Firms.vue'),
        meta: {
            layout: 'default',
            code: 'fif',
            parentCode: 'fir'
        }
    },
    {
        path: '/firms/templates',
        name: 'Firmas - Plantillas',
        component: () => import(/* webpackChunkName: "blank" */ '@/pages/admin/firms/Templates.vue'),
        meta: {
            layout: 'default',
            code: 'fip',
            parentCode: 'fir'
        }
    },
]
