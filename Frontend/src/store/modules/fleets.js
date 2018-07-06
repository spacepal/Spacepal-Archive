/* fleets in space */

import Vue from 'vue'

const state = {
  fleets: {}
}

const mutations = {
  SET_FLEETS (state, fleets) {
    fleets.forEach(f => {
      Vue.set(state.fleets, f.id, f)
    })
  },
  CLEAR_FLEETS (state) {
    state.fleets = {}
  }
}

const actions = {
  setfleets ({ commit, dispatch }, fleets) {
    commit('CLEAR_FLEETS')
    commit('SET_FLEETS', fleets)
    dispatch('syncSet', 'fleets', { root: true })
  }
}

const getters = {
  fleets (state) {
    return state.fleets
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  getters,
  actions
}
