import Vuex from 'vuex'
import Vue from 'vue'
import ActionCabel from '../common/ActionCabel'
/* modules */
import events from './modules/events'
import fleets from './modules/fleets'
import game from './modules/game'
import members from './modules/members'
import planets from './modules/planets'
import profile from './modules/profile'
import tasks from './modules/tasks'

Vue.use(Vuex)

const STORAGE_GAME_ID = 'game_id'

const state = {
  cabel: null,
  gameID: localStorage.getItem(STORAGE_GAME_ID)
}

const mutations = {
  ENABLE_CABLE ({ cabel }) {
    cabel = new ActionCabel(state.gameID)
  },
  LOGIN (state, gameID) {
    state.gameID = gameID
  },
  LOGOUT (state) {
    state.gameID = null
  }
}

const actions = {
  logout ({ commit }) {
    localStorage.removeItem(STORAGE_GAME_ID)
    commit('LOGOUT')
  },
  login ({ commit }, { gameID }) {
    localStorage.setItem(STORAGE_GAME_ID, gameID)
    commit('LOGIN', { gameID })
    commit('ENABLE_CABLE', new ActionCabel(gameID))
  }
}

const getters = {
  isPlayer: (state) => {
    return !!state.gameID
  }
}

export default new Vuex.Store({
  state,
  mutations,
  actions,
  getters,
  modules: {
    events,
    fleets,
    game,
    members,
    planets,
    profile,
    tasks
  },
  strict: true
})
