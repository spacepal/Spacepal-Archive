import Vue from 'vue'

const INTIAIL_PROFILE = {
  id: null,
  username: '',
  isCreator: false,
  isEndTurn: false,
  isGameOver: false,
  color: 'neutral',
  isArtificialIntelligence: false
}

const state = {
  profile: Object.assign({}, INTIAIL_PROFILE)
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
  },
  clearProfile ({ commit }) {
    commit('SET_PROFILE', INTIAIL_PROFILE)
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
  },
  isPlayerlost (state) {
    return state.profile.isGameOver
  }
}

export default {
  state,
  mutations,
  getters,
  actions
}
