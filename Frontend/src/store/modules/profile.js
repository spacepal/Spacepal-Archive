import Vue from 'vue'

const INTIAIL_PROFILE = {
  id: null,
  username: null,
  isCreator: null,
  isEndTurn: true,
  isGameOver: null
}

const state = {
  profile: INTIAIL_PROFILE
}

const mutations = {
  SET_PROFILE (state, profile) {
    Object.keys(profile).forEach(key => {
      Vue.set(state.profile, key, profile[key])
    })
  }
}

const actions = {
  setProfile ({ commit, dispatch }, profile) {
    commit('SET_PROFILE', profile)
    dispatch('syncSet', 'profile', { root: true })
  }
}

const getters = {
  profile (state) {
    return state.profile
  },
  isCreator (state) {
    return state.profile.isCreator || false
  },
  isWinner (state, _, __, rootGetters) {
    let m = rootGetters['member'](state.profile.id)
    return m !== undefined && !m.isGameOver
  }
}

export default {
  state,
  mutations,
  getters,
  actions
}
