export default [
    {
        path: '/process',
        name: 'process',
        component: () => import(/* webpackChunkName: "debsons" */ '@/pages/admin/process/IndexProcessPage.vue'),
        meta: {
            layout: 'default',
            code: 'pro',
            // parentCode: 'ins'
        }
    },
    

]
