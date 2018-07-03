const STORAGE_GAME_ID = 'game_id'
const STORAGE_USERNAME = 'username'
const STORAGE_IS_CREATOR = 'isCreator'

const state = {
  username: localStorage.getItem(STORAGE_USERNAME),
  gameID: localStorage.getItem(STORAGE_GAME_ID),
  isCreator: localStorage.getItem(STORAGE_IS_CREATOR)
}

const mutations = {
  LOGIN (state, { username, gameID, isCreator }) {
    state.username = username
    state.gameID = gameID
    state.isCreator = isCreator
  },
  LOGOUT (state) {
    state.username = null
    state.gameID = null
    state.isCreator = null
  }
}

const actions = {
  logout ({ commit }) {
    localStorage.removeItem(STORAGE_USERNAME)
    localStorage.removeItem(STORAGE_GAME_ID)
    localStorage.removeItem(STORAGE_IS_CREATOR)
    commit('LOGOUT')
  },
  login ({ commit, dispatch }, { username, gameID, isCreator }) {
    localStorage.setItem(STORAGE_USERNAME, username)
    localStorage.setItem(STORAGE_GAME_ID, gameID)
    localStorage.setItem(STORAGE_IS_CREATOR, isCreator)
    dispatch('game/setInfo', {
      state: 1
    })
    commit('LOGIN', { username, gameID, isCreator })
  }
}

const getters = {
  isPlayer: (state) => {
    return !!state.username && !!state.gameID && !!state.isCreator
  }
}

export default {
  state,
  mutations,
  getters,
  actions
}
