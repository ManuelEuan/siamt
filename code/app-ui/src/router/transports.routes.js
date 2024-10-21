export default [
    {
      path: '/transports/companies',
      name: 'companies',
      component: () => import(/* webpackChunkName: "empresas" */ '@/pages/admin/companies/IndexCompanyPage.vue'),
      meta: {
        layout: 'default',
        code: 'iie'
      }
    },
    {
      path: '/transports/companies/new',
      name: 'companies-new',
      component: () => import(/* webpackChunkName: "empresas-new" */ '@/pages/admin/companies/EditCompanyPage.vue'),
      meta: {
        layout: 'default',
        code: 'iie',
        parentCode: 'emp'
      }
    },
    {
      path: '/transports/companies/:id/edit',
      name: 'companies-edit',
      component: () => import(/* webpackChunkName: "empresas-edit" */ '@/pages/admin/companies/EditCompanyPage.vue'),
      meta: {
        layout: 'default',
        code: 'iie',
        parentCode: 'emp'
      }
    }
  ];
  