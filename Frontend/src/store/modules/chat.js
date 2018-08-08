import Vue from 'vue'

const state = {
  messages: [],
  unread: false
}

const mutations = {
  SET_MESSAGES (state, messages) {
    Vue.set(state, 'messages', messages)
  },
  ADD_MESSAGE (state, message) {
    state.messages.push(message)
  },
  UNREAD (state, val) {
    state.unread = val
  }
}

const actions = {
  set ({ commit, dispatch }, messages) {
    commit('SET_MESSAGES', messages)
  },
  add ({ commit }, message) {
    commit('UNREAD', true)
    commit('SET_MESSAGE', message)
  },
  setRead ({ commit }) {
    commit('UNREAD', false)
  },
  send ({ rootState }, message) {
    rootState.cable.get(rootState.gameID).sendMessage(message)
  }
}

const getters = {
  messages: (state) => state.messages,
  unread: (state) => state.unread
}

export default {
  namespaced: true,
  state,
  mutations,
  getters,
  actions
}
