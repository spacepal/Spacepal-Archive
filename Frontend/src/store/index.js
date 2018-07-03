import Vuex from 'vuex'
import Vue from 'vue'
import profile from './modules/profile'
import game from './modules/game'
import planets from './modules/planets'
import members from './modules/members'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    profile,
    game,
    planets,
    members
  },
  strict: true
})
