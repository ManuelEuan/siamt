export default [
    {
        path: '/process',
        name: 'process',
        component: () => import(/* webpackChunkName: "debsons" */ '@/pages/admin/process/ProcessPage.vue'),
        meta: {
            layout: 'default',
            code: 'pro',
            // parentCode: 'ins'
        }
    },
    

]
