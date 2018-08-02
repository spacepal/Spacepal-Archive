import Vue from 'vue'
import Router from 'vue-router'
import GamesList from '@/pages/GamesList.vue'
import CreateGame from '@/pages/CreateGame.vue'
import Game from '@/pages/Game.vue'
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
        name: 'GamesList'
      }
    },
    {
      path: '/',
      name: 'GamesList',
      component: GamesList,
      beforeEnter: genBeforeEnter(false, 'Game')
    },
    {
      path: '/create',
      name: 'CreateGame',
      component: CreateGame,
      beforeEnter: genBeforeEnter(false, 'Game')
    },
    {
      path: '/play',
      name: 'Game',
      component: Game,
      beforeEnter: genBeforeEnter(true, 'GamesList')
    }
  ]
})
