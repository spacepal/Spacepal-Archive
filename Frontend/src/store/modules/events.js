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
  setevents ({ commit }, events) {
    commit('CLEAR_EVENTS')
    commit('SET_EVENTS', events)
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
