import Vue from 'vue'
import Router from 'vue-router'
import Games from '@/pages/Games.vue'
import CreateGame from '@/pages/CreateGame.vue'
import Game from '@/pages/Game.vue'
import Room from '@/pages/Room.vue'
import Test from '@/components/Test.vue'
import store from '@/store'

Vue.use(Router)

function genBeforeEnter (isForPlayer, failPage) {
  return (_, __, next) => {
    if (isForPlayer ^ store.getters['isPlayer']) {
      next({ name: failPage })
    } else {
      next()
    }
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
      beforeEnter: genBeforeEnter(false, 'Room')
    },
    {
      path: '/create',
      name: 'CreateGame',
      component: CreateGame,
      beforeEnter: genBeforeEnter(false, 'Room')
    },
    {
      path: '/play',
      name: 'Game',
      component: Game,
      beforeEnter: genBeforeEnter(true, 'Games')
    },
    {
      path: '/room',
      name: 'Room',
      component: Room,
      beforeEnter: genBeforeEnter(true, 'Games')
    },
    {
      path: '/test',
      name: 'Test',
      component: Test
    }
  ]
})
