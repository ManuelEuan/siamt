import Vue from 'vue';
import Router from 'vue-router';

import config from '../configs';

// Routes
import UsersRoutes from "@/router/users.routes";
import DebitacionRoutes from "@/router/debitacion.routes";
import ModulesRoutes from "@/router/modules.routes";
import ProfilesRoutes from "@/router/profiles.routes";
import mtoUnidades from "@/router/mtoUnidades.routes";
import InspectionsRoutes from "@/router/inspections.routes";
import PersonsRoutes from "@/router/persons.routes";
import FirmsRoutes from "@/router/signature.routes";
import ProcessRoutes from "@/router/process.routes";
import DemoRoutes from "@/router/demo.routes";


import services from '@/services';

Vue.use(Router)

export const routes = [{
  path: '/',
  redirect: '/blank'
},{
  path: '/auth/signin',
  name: 'auth-signin',
  component: () => import(/* webpackChunkName: "auth-signin" */ '@/pages/auth/SigninPage.vue'),
  meta: {
    layout: 'auth'
  }
},
{
  path: '/demo',
  name: 'demo',
  component: () => import(/* webpackChunkName: "auth-signin" */ '@/pages/auth/SigninPage.vue'),
  meta: {
    layout: 'auth'
  }
},
{
  path: '/auth/reset-password',
  name: 'reset-password',
  component: () => import(/* webpackChunkName: "auth-signin" */ '@/pages/auth/ResetPage.vue'),
  meta: {
    layout: 'auth'
  }
},
  ...UsersRoutes,
  ...ModulesRoutes,
  ...DebitacionRoutes,
  ...ProfilesRoutes,
  ...mtoUnidades,
  ...InspectionsRoutes,
  ...PersonsRoutes,
  ...FirmsRoutes,
  ...ProcessRoutes,
  ...DemoRoutes,
{
  path: '/blank',
  name: 'blank',
  component: () => import(/* webpackChunkName: "blank" */ '@/pages/BlankPage.vue')
},
{
  path: '*',
  name: 'error',
  component: () => import(/* webpackChunkName: "error" */ '@/pages/error/NotFoundPage.vue'),
  meta: {
    layout: 'error'
  }
}]

const router = new Router({
  mode: 'history',
  base: process.env.BASE_URL || '/',
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) return savedPosition

    return { x: 0, y: 0 }
  },
  routes
})

/**
 * Before each route update
 */
router.beforeEach(async (to, from, next) => {
  // console.log("router.beforeEach-to: ", to);
  // console.log("router.beforeEach-from: ", from);

  if(services.security().isAuthenticated()) {

    const { permission, code, parentCode } = to.meta ?? {};
    if(to.name === 'auth-signin') return next('/');
    
    if (
      (parentCode && permission && !services.security().hasPermission(parentCode, permission)) ||
      (parentCode && !permission && !services.security().hasModule(parentCode)) ||
      (!parentCode && code && !services.security().hasModule(code))
    )
      return next({ name: 'error' });


  } else {
    if(to.name !== 'auth-signin') return next({ name: 'auth-signin'});
  }
  
  next();
})

/**
 * After each route update
 */
 // eslint-disable-next-line
router.afterEach((to, from) => {
  Vue.nextTick(() => { 
    let title = to.meta.title? to.meta.title + ' - ' : '';
    
    document.title = title + config.product.name;
  });
  // console.log("router.afterEach-to: ", to);
  // console.log("router.afterEach-from: ", from);
})

services.security().addEventListener('logout', () => { router.push({ name: 'auth-signin'}); });


export default router
