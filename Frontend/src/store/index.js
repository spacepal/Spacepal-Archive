import Vuex from 'vuex'
import Vue from 'vue'
import ActionCabel from '../common/ActionCabel'
import { DEFAULT_BACKEND, API_POSTFIX, WS_POSTFIX } from '../common/constants.js'
/* modules */
import events from './modules/events'
import fleets from './modules/fleets'
import game from './modules/game'
import members from './modules/members'
import planets from './modules/planets'
import profile from './modules/profile'
import tasks from './modules/tasks'
import bookmarks from './modules/bookmarks'
import panels from './modules/panels'
import settings from './modules/settings'

Vue.use(Vuex)

const STORAGE_GAME_ID = 'game_id'
const STORAGE_BACKEND = 'backend'
const STORAGE_QUICKSTART = 'quickstart'
const STORAGE_LOCALE = 'locale'

var gID = localStorage.getItem(STORAGE_GAME_ID)

const state = {
  cable: new Map(),
  gameID: (gID !== undefined ? parseInt(gID) : undefined),
  sync: {
    endTurn: false, // is used for animation of turn number
    game: false,
    fleets: false,
    members: false,
    planets: false,
    profile: false,
    events: false,
    endTurnClear: false,
    autotasks: false // complete
  },
  afterReload: true,
  endTurnLock: true,
  backendServer: localStorage.getItem(STORAGE_BACKEND) || DEFAULT_BACKEND, // @todo Move to settings
  quickStart: localStorage.getItem(STORAGE_QUICKSTART),
  savedLocale: localStorage.getItem(STORAGE_LOCALE)
}

const mutations = {
  SET_BACKEND_SERVER (state, host) {
    state.backendServer = host
  },
  RESET_BACKEND_SERVER (state) {
    state.backendServer = DEFAULT_BACKEND
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
  ENABLE_CABLE (state, wsServer) {
    let cable = new ActionCabel(state.gameID, wsServer)
    state.cable.set(state.gameID, cable)
  },
  DISABLE_CABLE (state) {
    state.cable.clear()
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
  },
  SET_QUICK_START (state, quickStart) {
    state.quickStart = quickStart
  },
  SAVE_LOCALE (state, locale) {
    state.savedLocale = locale
  },
  RESET_AFTER_RELOAD (state) {
    state.afterReload = false
  }
}

const actions = {
  saveLocale ({ commit }, locale) {
    localStorage.setItem(STORAGE_LOCALE, locale)
    commit('SAVE_LOCALE', locale)
  },
  resetBackendServer ({ commit }, host) {
    localStorage.removeItem(STORAGE_BACKEND)
    commit('RESET_BACKEND_SERVER')
  },
  setBackendServer ({ commit }, host) {
    localStorage.setItem(STORAGE_BACKEND, host)
    commit('SET_BACKEND_SERVER', host)
  },
  lock ({ commit, dispatch }) {
    commit('END_TURN_LOCK')
    dispatch('syncUnset', 'profile')
  },
  unlock ({ commit }) {
    commit('END_TURN_UNLOCK')
  },
  enableCable ({ state, commit, dispatch, getters }) {
    dispatch('reset')
    commit('ENABLE_CABLE', getters.backendWS)
    return state.cable.get(state.gameID).isOk
  },
  disableCable ({ state, commit }) {
    state.cable.forEach(cable => {
      cable.close()
    })
    commit('DISABLE_CABLE')
  },
  reset ({ commit, dispatch }) { // turn_ended from ActionCable
    dispatch('lock') // it does not matter
    commit('SYNC_RESET')
  },
  syncUnset ({ commit }, syncType) {
    commit('SYNC_UNSET', syncType)
  },
  syncSet ({ state, commit, dispatch, getters }, syncType) {
    commit('SYNC_SET', syncType)
    if (syncType === 'endTurn') {
      commit('RESET_AFTER_RELOAD')
    }
    if (state.endTurnLock &&
      state.sync.game &&
      state.sync.profile &&
      state.sync.planets &&
      getters['game/isGame'] &&
      !getters['profile'].isEndTurn &&
      !getters['profile'].isGameOver) {
      dispatch('unlock')
      dispatch('tasks/setSaved')
    }
    if (state.sync.endTurn && !state.sync.endTurnClear) {
      dispatch('syncSet', 'endTurnClear')
      dispatch('events/clear')
      dispatch('tasks/clear')
    }
    if (!state.sync.autotasks &&
      !state.endTurnLock && !state.afterReload) {
      dispatch('tasks/doAutoTasks')
    }
  },
  clear ({ dispatch }) {
    dispatch('reset')
    dispatch('bookmarks/clear')
    dispatch('events/clear')
    dispatch('fleets/clear')
    dispatch('game/reset')
    dispatch('clearMembers')
    dispatch('clearPlanets')
    dispatch('clearProfile')
    dispatch('tasks/clear')
    dispatch('tasks/clearAutoTasks')
  },
  logout ({ commit, dispatch, state }) {
    dispatch('disableCable')
    let gID = state.gameID
    dispatch('clear')
    localStorage.removeItem(STORAGE_GAME_ID)
    commit('LOGOUT')
    return dispatch('game/logout', gID)
  },
  login ({ commit, getters, dispatch }, gameID) {
    dispatch('clear')
    localStorage.setItem(STORAGE_GAME_ID, gameID)
    commit('LOGIN', { gameID })
    commit('ENABLE_CABLE', getters.backendWS)
  },
  shuffleMap ({ state, getters, dispatch }) {
    if (!state.sync.profile || !state.sync.game ||
      !getters['isCreator'] || !getters['game/isRoom']) {
      return false
    }
    dispatch('syncUnset', 'planets')
    state.cable.get(state.gameID).shuffleMap()
  },
  setQuickStart ({ commit }, quickStart) {
    localStorage.setItem(STORAGE_QUICKSTART, quickStart)
    commit('SET_QUICK_START', quickStart)
  }
}

const getters = {
  quickStart: state => {
    return state.quickStart !== 'false'
  },
  backendAPI: (state) => 'http://' + state.backendServer + API_POSTFIX,
  backendWS: (state) => 'ws://' + state.backendServer + WS_POSTFIX,
  isPlayer: (state) => !!state.gameID,
  sync: (state) => state.sync,
  isLocked: (state) => state.endTurnLock,
  savedLocale: (state) => state.savedLocale
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
    tasks,
    bookmarks,
    panels,
    settings
  },
  strict: true
})
