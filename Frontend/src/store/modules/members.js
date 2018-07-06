import Vue from 'vue'

const state = {
  members: {}
}

const mutations = {
  SET_MEMBERS (state, members) {
    members.forEach(m => {
      Vue.set(state.members, m.id, m)
    })
  },
  CLEAR_MEMBERS (state) {
    state.members = {}
  }
}

const actions = {
  setMembers ({ commit, dispatch }, members) {
    commit('CLEAR_MEMBERS')
    commit('SET_MEMBERS', members)
    dispatch('syncSet', 'members', { root: true })
  }
}

const getters = {
  member (state) {
    return (memberID) => {
      return state.members[memberID]
    }
  },
  members (state) {
    return state.members
  }
}

export default {
  state,
  mutations,
  getters,
  actions
}
