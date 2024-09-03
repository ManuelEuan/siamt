export default [
    {
        path: '/profiles',
        name: 'profiles',
        component: () => import(/* webpackChunkName: "persons" */ '@/pages/admin/profiles/ProfilesPage.vue'),
        meta: {
            layout: 'default',
            code: 'per'
        }
    }, {
        path: '/profiles/new',
        name: 'profiles-new',
        component: () => import(/* webpackChunkName: "events-edit" */ '@/pages/admin/profiles/EditProfilePage.vue'),
        meta: {
            layout: 'default',
            code: 'nus',
            parentCode: 'per'
        }
    }, {
        path: '/profiles/:id/edit',
        name: 'profiles-edit',
        component: () => import(/* webpackChunkName: "events-edit" */ '@/pages/admin/profiles/EditProfilePage.vue'),
        meta: {
            layout: 'default',
            code: 'tus',
            parentCode: 'per'
        }
    }
]
