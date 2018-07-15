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
  }
}

export default {
  state,
  mutations,
  getters,
  actions
}
