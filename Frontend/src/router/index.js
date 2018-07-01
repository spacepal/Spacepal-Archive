import Vue from 'vue'
import Router from 'vue-router'
import Games from '@/pages/Games.vue'
import CreateGame from '@/pages/CreateGame.vue'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Games',
      component: Games
    },
    {
      path: '/create',
      name: 'CreateGame',
      component: CreateGame
    }
  ]
})
