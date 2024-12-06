export default [
    {
        path: "/mantenimiento/actividades",
        name: "Actividades",
        component: () => import(/* webpackChunkName: "actividad" */ "@/pages/admin/mantoUnidades/actividades/IndexPage.vue"),
        meta: {
          layout: "default",
          code: "mto_act",
        },
      },
      {
        path: "/mantenimiento/actividades/new",
        name: "actividades-new",
        component: () => import(/* webpackChunkName: "actividad-edit" */ "@/pages/admin/mantoUnidades/actividades/CreatePage.vue"),
        meta: {
          layout: "default",
          code: "nus",
          parentCode: "per",
        },
      },
      {
        path: "/mantenimiento/actividades/:id/edit",
        name: "actividades-edit",
        component: () => import(/* webpackChunkName: "actividad-edit" */ "@/pages/admin/mantoUnidades/actividades/CreatePage.vue"),
        meta: {
          layout: "default",
          code: "tus",
          parentCode: "usr",
        },
      },
      {
        path: "/mantenimiento/preventivos",
        name: "preventivos",
        // component: () => import(/* webpackChunkName: "preventivos" */ "@/pages/admin/mantoUnidades/preventivos/IndexPage.vue"),
        meta: {
          layout: "default",
          code: "mto_pre",
        },
      },
      {
        path: "/mantenimiento/preventivos/new",
        name: "preventivos-new",
        // component: () => import(/* webpackChunkName: "preventivos-edit" */ "@/pages/admin/mantoUnidades/preventivos/CreatePage.vue"),
        meta: {
          layout: "default",
          code: "nus",
          parentCode: "per",
        },
      },
      {
        path: "/mantenimiento/preventivos/:id/edit",
        name: "preventivos-edit",
        // component: () => import(/* webpackChunkName: "preventivos-edit" */ "@/pages/admin/mantoUnidades/preventivos/EditPage.vue"),
        meta: {
          layout: "default",
          code: "tus",
          parentCode: "usr",
        },
      },
      {
        path: "/mantenimiento/correctivos",
        name: "correctivos",
        // component: () => import(/* webpackChunkName: "correctivos" */ "@/pages/admin/mantoUnidades/correctivos/IndexPage.vue"),
        meta: {
          layout: "default",
          code: "mto_cor",
        },
      },
      {
        path: "/mantenimiento/correctivos/new",
        name: "correctivos-new",
        // component: () => import(/* webpackChunkName: "correctivos-edit" */ "@/pages/admin/mantoUnidades/correctivos/CreatePage.vue"),
        meta: {
          layout: "default",
          code: "nus",
          parentCode: "per",
        },
      },
      {
        path: "/mantenimiento/correctivos/:id/edit",
        name: "correctivos-edit",
        // component: () => import(/* webpackChunkName: "correctivos-edit" */ "@/pages/admin/mantoUnidades/correctivos/EditPage.vue"),
        meta: {
          layout: "default",
          code: "tus",
          parentCode: "usr",
        },
      },
      {
        path: "/mantenimiento/incidentes",
        name: "incidentes",
        // component: () => import(/* webpackChunkName: "incidentes" */ "@/pages/admin/mantoUnidades/incidentes/IndexPage.vue"),
        meta: {
          layout: "default",
          code: "mto_rin",
        },
      },
      {
        path: "/mantenimiento/incidentes/new",
        name: "incidentes-new",
        // component: () => import(/* webpackChunkName: "incidentes-edit" */ "@/pages/admin/mantoUnidades/incidentes/CreatePage.vue"),
        meta: {
          layout: "default",
          code: "nus",
          parentCode: "per",
        },
      },
      {
        path: "/mantenimiento/incidentes/:id/edit",
        name: "incidentes-edit",
        // component: () => import(/* webpackChunkName: "incidentes-edit" */ "@/pages/admin/mantoUnidades/incidentes/EditPage.vue"),
        meta: {
          layout: "default",
          code: "tus",
          parentCode: "usr",
        },
      },
      {
        path: "/mantenimiento/planes",
        name: "planes",
        component: () => import(/* webpackChunkName: "planes" */ "@/pages/admin/mantoUnidades/planes/IndexPage.vue"),
        meta: {
          layout: "default",
          code: "mto_pla",
        },
      },
      {
        path: "/mantenimiento/planes/new",
        name: "planes-new",
        component: () => import(/* webpackChunkName: "planes-edit" */ "@/pages/admin/mantoUnidades/planes/CreatePage.vue"),
        meta: {
          layout: "default",
          code: "nus",
          parentCode: "per",
        },
      },
      {
        path: "/mantenimiento/planes/:id/edit",
        name: "planes-edit",
        // component: () => import(/* webpackChunkName: "planes-edit" */ "@/pages/admin/mantoUnidades/planes/EditPage.vue"),
        meta: {
          layout: "default",
          code: "tus",
          parentCode: "usr",
        },
    },
]
