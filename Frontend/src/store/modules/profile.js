import storage from '@/common/storage/index.js'

const storageGameID = 'game_id'
const storageUsername = 'username'

const state = {
  username: storage.getItem(storageUsername),
  gameID: storage.getItem(storageGameID)
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
    ApiService.deleteLogin(getters.username, getters.token)
    localStorage.removeItem(storageUsername)
    localStorage.removeItem(storageGameID)
    commit('LOGOUT')
  },
  login ({ commit }, { username, gameID }) {
    storage.setItem(storageUsername, username)
    storage.setItem(storageGameID, resp.body.data.token)
  }
}

const getters = {
  isPlaying: state => {
    return !!state.username && !!state.gameID
  }
}

export default {
  state,
  mutations,
  getters,
  actions
}
