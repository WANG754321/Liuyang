import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/Login.vue'
import Register from '../views/Register.vue'
import Home from '../views/Home.vue'
import HouseDetail from '../views/HouseDetail.vue'
import MyHouses from '../views/MyHouses.vue'
import MyOrders from '../views/MyOrders.vue'
import Profile from '../views/Profile.vue'

const routes = [
  { path: '/', redirect: '/home' },
  { path: '/login', component: Login },
  { path: '/register', component: Register },
  { path: '/home', component: Home },
  { path: '/house/:id', component: HouseDetail },
  { 
    path: '/my-houses', 
    component: MyHouses,
    meta: { requiresAuth: true, roles: ['landlord', 'admin'] }
  },
  { 
    path: '/my-orders', 
    component: MyOrders,
    meta: { requiresAuth: true }
  },
  {
    path: '/profile',
    component: Profile,
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const user = JSON.parse(localStorage.getItem('user') || 'null')
  
  if (to.meta.requiresAuth && !user) {
    next({
      path: '/login',
      query: { redirect: to.fullPath }
    })
    return
  }
  
  if (to.meta.roles && user && !to.meta.roles.includes(user.role)) {
    next('/home')
    return
  }
  
  next()
})

export default router
