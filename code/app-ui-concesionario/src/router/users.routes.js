export default [
    {
        path: '/users',
        name: 'users',
        component: () => import(/* webpackChunkName: "persons" */ '@/pages/admin/users/UsersPage.vue'),
        meta: {
            layout: 'default',
            code: 'usr'
        }
    }, {
        path: '/users/new',
        name: 'users-new',
        component: () => import(/* webpackChunkName: "events-edit" */ '@/pages/admin/users/EditUserPage.vue'),
        meta: {
            layout: 'default',
            code: 'nus',
            parentCode: 'usr'
        }
    }, {
        path: '/users/:id/edit',
        name: 'users-edit',
        component: () => import(/* webpackChunkName: "events-edit" */ '@/pages/admin/users/EditUserPage.vue'),
        meta: {
            layout: 'default',
            code: 'tus',
            parentCode: 'usr'
        }
    }, {
        path: '/users/:id/profile',
        name: 'users-profile',
        component: () => import(/* webpackChunkName: "persons-profile" */ '@/pages/admin/users/UserProfilePage.vue'),
        meta: {
            layout: 'default',
            code: 'pus',
            parentCode: 'usr'
        }
    }
]
