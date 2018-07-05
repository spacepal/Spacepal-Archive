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
  cable: new Map(),
  gameID: localStorage.getItem(STORAGE_GAME_ID),
  sync: {
    game: false,
    fleets: false,
    members: false,
    planets: false,
    profile: false,
    tasks: false,
    autotasks: false // complete
  }
}

const mutations = {
  SYNC_RESET (state) {
    for (let s in state.sync) {
      state[s] = false
    }
  },
  SYNC_SET (state, syncType) {
    state.sync[syncType] = true
  },
  ENABLE_CABLE (state) {
    state.cable.set(state.gameID, new ActionCabel(state.gameID))
  },
  LOGIN (state, gameID) {
    state.gameID = gameID
  },
  LOGOUT (state) {
    state.gameID = null
  }
}

const actions = {
  enableCable ({ commit }) {
    commit('ENABLE_CABLE')
  },
  resetSync ({commit}) {
    commit('SYNC_RESET')
  },
  syncSet ({ state, commit, dispatch }, syncType) {
    if (!state.sync.tasks &&
      state.sync.members && state.sync.planets) {
      dispatch('tasks/unlock')
      commit('SYNC_SET', 'tasks')
    }
    if (!state.sync.autotasks &&
      state.sync.tasks) {
      dispatch('tasks/doAutoTasks')
      commit('SYNC_SET', 'autotasks')
    }
    commit('SYNC_SET', syncType)
  },
  logout ({ commit }) {
    localStorage.removeItem(STORAGE_GAME_ID)
    commit('LOGOUT')
  },
  login ({ commit }, gameID) {
    localStorage.setItem(STORAGE_GAME_ID, gameID)
    commit('LOGIN', { gameID })
    commit('ENABLE_CABLE')
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
