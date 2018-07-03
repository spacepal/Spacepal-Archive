const STORAGE_GAME_ID = 'game_id'
const STORAGE_USERNAME = 'username'

const state = {
  username: localStorage.getItem(STORAGE_USERNAME),
  gameID: localStorage.getItem(STORAGE_GAME_ID)
}

const mutations = {
  LOGIN (state, { username, gameID }) {
    state.username = username
    state.gameID = gameID
  },
  LOGOUT (state) {
    state.username = null
    state.gameID = null
  }
}

const actions = {
  logout ({ commit, getters }) {
    localStorage.removeItem(STORAGE_USERNAME)
    localStorage.removeItem(STORAGE_GAME_ID)
    commit('LOGOUT')
  },
  login ({ commit }, { username, gameID }) {
    localStorage.setItem(STORAGE_USERNAME, username)
    localStorage.setItem(STORAGE_GAME_ID, gameID)
    commit('LOGIN', { username, gameID })
  }
}

const getters = {
  isPlayer: (state, getters) => {
    return !!state.username && !!state.gameID
  }
}

export default {
  state,
  mutations,
  getters,
  actions
}
