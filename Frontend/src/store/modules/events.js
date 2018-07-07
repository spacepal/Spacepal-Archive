/* Game events */

import Vue from 'vue'

const state = {
  events: []
}

const mutations = {
  SET_EVENTS (state, events) {
    Vue.set(state, 'events', events)
  },
  CLEAR_EVENTS (state) {
    Vue.set(state, 'events', [])
  }
}

const actions = {
  set ({ commit, dispatch }, events) {
    commit('SET_EVENTS', events)
    dispatch('syncSet', 'events', { root: true })
  },
  clear ({ commit }) {
    commit('CLEAR_EVENTS')
  }
}

const getters = {
  all (state) {
    return state.events
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  getters,
  actions
}
