import Vuex from 'vuex'
import Vue from 'vue'
import profile from './modules/profile'
import game from './modules/game'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    profile,
    game
  },
  strict: true
})
