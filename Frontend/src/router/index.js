import Vue from 'vue'
import Router from 'vue-router'
import Games from '@/pages/Games.vue'
import CreateGame from '@/pages/CreateGame.vue'
import Game from '@/pages/Game.vue'
import Room from '@/pages/Room.vue'
import Test from '@/components/Test.vue'
import store from '@/store'

Vue.use(Router)

function beforeEnter (_, __, next) {
  if (store.getters['isPlayer']) {
    if (store.getters['game/isRoom']) {
      next({ name: 'Room' })
    } else if (store.getters['game/isGame']) {
      next({ name: 'Game' })
    }
  } else {
    next()
  }
}

export default new Router({
  routes: [
    {
      path: '*',
      name: 'NotFound',
      redirect: {
        name: 'Games'
      }
    },
    {
      path: '/',
      name: 'Games',
      component: Games,
      beforeEnter
    },
    {
      path: '/create',
      name: 'CreateGame',
      component: CreateGame,
      beforeEnter
    },
    {
      path: '/play',
      name: 'Game',
      component: Game,
      beforeEnter: (_, __, next) => {
        if (!store.getters['game/isGame']) {
          next({ name: 'Room' })
        } else {
          next()
        }
      }
    },
    {
      path: '/room',
      name: 'Room',
      component: Room,
      beforeEnter: (_, __, next) => {
        if (!store.getters['game/isRoom']) {
          next({ name: 'Games' })
        } else {
          next()
        }
      }
    },
    {
      path: '/test',
      name: 'Test',
      component: Test
    }
  ]
})
