/* Game events */

import Vue from 'vue'

const state = {
  events: {}
}

const mutations = {
  SET_EVENTS (state, events) {
    events.forEach(e => {
      Vue.set(state.events, e.id, e)
    })
  },
  CLEAR_EVENTS (state) {
    state.events = {}
  }
}

const actions = {
  setEvents ({ commit, dispatch }, events) {
    commit('CLEAR_EVENTS')
    commit('SET_EVENTS', events)
    dispatch('syncSet', 'events', { root: true })
  }
}

const getters = {
  events (state) {
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
