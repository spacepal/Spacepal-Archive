import Vue from 'vue'
import Faker from 'faker'

let members = [198, 199]
let messages = []
for (let i = 0; i < 100; i++) {
  messages.push({
    playerID: members[i % members.length],
    text: Faker.hacker.phrase()
  })
}

const state = {
  messages: messages,
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
  set ({ commit, dispatch }, events) {
    commit('SET_EVENTS', events)
    dispatch('syncSet', 'events', { root: true })
  },
  add ({ commit }, message) {
    commit('UNREAD', true)
    commit('SET_MESSAGE', message)
  },
  setRead ({ commit }) {
    commit('UNREAD', false)
  },
  send (_, message) {
    console.log('@todo sending ', message)
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
