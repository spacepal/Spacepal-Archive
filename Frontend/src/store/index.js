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
  },
  endTurnLock: true
}

const mutations = {
  SYNC_RESET (state) {
    for (let s in state.sync) {
      state.sync[s] = false
    }
  },
  SYNC_SET (state, syncType) {
    state.sync[syncType] = true
  },
  ENABLE_CABLE (state) {
    let cable = new ActionCabel(state.gameID)
    state.cable.set(state.gameID, cable)
  },
  LOGIN (state, gameID) {
    state.gameID = gameID
  },
  LOGOUT (state) {
    state.gameID = null
  },
  END_TURN_LOCK (state) {
    state.endTurnLock = true
  },
  END_TURN_UNLOCK (state) {
    state.endTurnLock = false
  }
}

const actions = {
  lock ({ commit }) {
    commit('END_TURN_LOCK')
  },
  unlock ({ commit }) {
    commit('END_TURN_UNLOCK')
  },
  enableCable ({ state, commit, dispatch }) {
    dispatch('reset')
    commit('ENABLE_CABLE')
    return state.cable.get(state.gameID).isOk
  },
  reset ({ commit, dispatch }) { // turn_ended from ActionCable
    dispatch('lock') // it does not matter
    dispatch('tasks/clear')
    commit('SYNC_RESET')
  },
  syncSet ({ state, commit, dispatch, getters }, syncType) {
    if (state.endTurnLock &&
      state.sync.tasks &&
      state.sync.profile &&
      state.sync.members &&
      state.sync.planets &&
      !getters['profile'].isEndTurn &&
      !getters['profile'].isGameOver) {
      dispatch('unlock')
    }
    if (!state.sync.autotasks &&
      !state.endTurnLock &&
      state.sync.tasks) {
      dispatch('tasks/doAutoTasks')
    }
    commit('SYNC_SET', syncType)
  },
  logout ({ commit, dispatch }) {
    dispatch('reset')
    localStorage.removeItem(STORAGE_GAME_ID)
    commit('LOGOUT')
    return dispatch('game/logout')
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
  },
  sync: (state) => state.sync,
  isLocked: (state) => state.endTurnLock
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
