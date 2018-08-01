/* fleets in space */

import Vue from 'vue'
import { START_MAX_SHIPS_COUNT } from '../../common/constants.js'

const state = {
  fleets: {},
  maxShipsCount: START_MAX_SHIPS_COUNT
}

const mutations = {
  SET_FLEETS (state, fleets) {
    state.maxShipsCount = START_MAX_SHIPS_COUNT
    fleets.forEach(f => {
      Vue.set(state.fleets, f.id, f)
      state.maxShipsCount = Math.max(state.maxShipsCount, f.count)
    })
  },
  CLEAR_FLEETS (state) {
    Object.keys(state.fleets).forEach(key => {
      Vue.delete(state.fleets, key)
    })
  }
}

const actions = {
  set ({ commit, dispatch }, fleets) {
    commit('CLEAR_FLEETS')
    commit('SET_FLEETS', fleets)
    dispatch('syncSet', 'fleets', { root: true })
  },
  clear ({ commit }) {
    commit('CLEAR_FLEETS')
  }
}

const getters = {
  all (state) {
    return state.fleets
  },
  maxShipsCount: (state) => state.maxShipsCount
}

export default {
  namespaced: true,
  state,
  mutations,
  getters,
  actions
}
