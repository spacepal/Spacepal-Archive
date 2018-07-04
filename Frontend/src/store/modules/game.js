const STATE_ROOM = 1
const STATE_GAME = 2
const STATE_END = 3

const state = {
  info: {
    state: 1,
    turnNumber: 0
  }
}

const mutations = {
  SET_GAME_INFO (state, gameInfo) {
    state.info = gameInfo
  }
}

const actions = {
  setInfo ({ commit }, gameInfo) {
    commit('SET_GAME_INFO', gameInfo)
  }
}

const getters = {
  isRoom: (state, _, __, rootGetters) => {
    return rootGetters.isPlayer && state.info.state === STATE_ROOM
  },
  isGame: (state, _, __, rootGetters) => {
    return rootGetters.isPlayer && state.info.state === STATE_GAME
  },
  isEnded: (state, _, __, rootGetters) => {
    return rootGetters.isPlayer && state.info.state === STATE_END
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  getters,
  actions
}
