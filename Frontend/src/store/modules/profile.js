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
    state.profile = profile
  },
  RESET_PROFILE (state) {
    state.profile = INTIAIL_PROFILE
  }
}

const actions = {
  resetProfile ({ commit }) {
    commit('RESET_PROFILE')
  },
  setProfile ({ commit, dispatch }, profile) {
    commit('SET_PROFILE', profile)
    commit('RESET_PROFILE')
    dispatch('syncSet', 'profile', { root: true })
  }
}

const getters = {
  profile (state) {
    return state.profile
  }
}

export default {
  state,
  mutations,
  getters,
  actions
}
