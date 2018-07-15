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
const STORAGE_MENU_IS_SHOWED = 'menu_is_showed'

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
    events: false,
    autotasks: false // complete
  },
  endTurnLock: true,
  menuIsShowed: localStorage.getItem(STORAGE_MENU_IS_SHOWED) !== 'false'
}

const mutations = {
  SET_MENU_IS_SHOWED (state, isShowed) {
    state.menuIsShowed = isShowed
  },
  SYNC_RESET (state) {
    for (let s in state.sync) {
      state.sync[s] = false
    }
  },
  SYNC_SET (state, syncType) {
    state.sync[syncType] = true
  },
  SYNC_UNSET (state, syncType) {
    state.sync[syncType] = false
  },
  ENABLE_CABLE (state) {
    let cable = new ActionCabel(state.gameID.gameID)
    state.cable.set(state.gameID, cable)
  },
  LOGIN (state, { gameID }) {
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
  toggleMenuVisibility ({ state, commit }) {
    let isShowed = !state.menuIsShowed
    localStorage.setItem(STORAGE_MENU_IS_SHOWED, isShowed)
    commit('SET_MENU_IS_SHOWED', isShowed)
  },
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
    dispatch('events/clear')
    commit('SYNC_RESET')
  },
  syncUnset ({ commit }, syncType) {
    commit('SYNC_UNSET', syncType)
  },
  syncSet ({ state, commit, dispatch, getters }, syncType) {
    if (state.endTurnLock &&
      state.sync.game &&
      state.sync.tasks &&
      state.sync.profile &&
      state.sync.members &&
      state.sync.planets &&
      getters['game/isGame'] &&
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
  logout ({ commit, dispatch, state }) {
    let gID = state.gameID
    dispatch('reset')
    localStorage.removeItem(STORAGE_GAME_ID)
    commit('LOGOUT')
    return dispatch('game/logout', gID)
  },
  login ({ commit }, gameID) {
    localStorage.setItem(STORAGE_GAME_ID, gameID)
    commit('LOGIN', { gameID })
    commit('ENABLE_CABLE')
  },
  shuffleMap ({ state, getters, dispatch }) {
    if (!state.sync.profile || !state.sync.game ||
      !getters['isCreator'] || !getters['game/isRoom']) {
      return false
    }
    dispatch('syncUnset', 'planets')
    state.cable.get(state.gameID).shuffleMap()
  }
}

const getters = {
  isPlayer: (state) => {
    return !!state.gameID
  },
  sync: (state) => state.sync,
  isLocked: (state) => state.endTurnLock,
  menuIsVisible: (state) => state.menuIsShowed
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
