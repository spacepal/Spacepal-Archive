const INTIAIL_PROFILE = {
  username: null,
  isCreator: null,
  memberId: null
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
  setProfile ({ commit, dispatch }, { username, gameID, isCreator }) {
    commit('RESET_PROFILE')
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
