const STORAGE_GAME_INFO = 'game_info'

const STATE_ROOM = 1
const STATE_GAME = 2
const STATE_END = 3

const state = {
  info: JSON.parse(localStorage.getItem(STORAGE_GAME_INFO) || '{}')
}

const mutations = {
  SET_GAME_INFO (gameInfo) {
    state.info = gameInfo
  }
}

const actions = {
  setGameInfo ({ commit }, { gameInfo }) {
    localStorage.setItem(STORAGE_GAME_INFO, JSON.stringify(gameInfo))
    commit('SET_GAME_INFO')
  }
}

const getters = {
  isRoom: (state, getters) => {
    return getters.isPlayer && state.info.state === STATE_ROOM
  },
  isGame: (state, getters) => {
    return getters.isPlayer && state.info.state === STATE_GAME
  },
  isEnded: (state, getters) => {
    return getters.isPlayer && state.info.state === STATE_END
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  getters,
  actions
}
