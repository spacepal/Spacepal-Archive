import Service from '../../common/Service.js'

const STATE_UNKNOWN = 0
const STATE_ROOM = 1
const STATE_GAME = 2
const STATE_END = 3

const state = {
  info: {
    state: STATE_UNKNOWN,
    turnNumber: 0
  }
}

const mutations = {
  SET_GAME_INFO (state, gameInfo) {
    state.info = gameInfo
  }
}

const actions = {
  setInfo ({ commit, dispatch }, gameInfo) {
    commit('SET_GAME_INFO', gameInfo)
    dispatch('syncSet', 'game', { root: true })
  },
  join ({ dispatch }, { gameID, pinCode, username }) {
    return Service.game.join(gameID, pinCode, username).then((resp) => {
      if (resp.data.errors) {
        throw new Error(resp.data.errors.join('; '))
      }
      dispatch('login', gameID, { root: true })
      return gameID
    })
  },
  create ({ dispatch }, data) {
    return Service.game.create(data).then((resp) => {
      if (resp.data.errors) {
        throw new Error(resp.data.errors.join('; '))
      }
      dispatch('login', resp.data.gameID, { root: true })
      return resp.data.gameID
    })
  },
  endTurn ({ dispatch, rootState, rootGetters }) {
    let fleets = rootGetters['tasks/all']
    dispatch('tasks/clear', null, { root: true })
    dispatch('resetSync', null, { root: true })
    rootState.cable.get(rootState.gameID).endTurn(fleets)
  }
}

const getters = {
  isRoom: (state, _, __, rootGetters) => {
    return rootGetters.isPlayer && state.info.state === STATE_ROOM
  },
  isGame: (state, _, __, rootGetters) => {
    return rootGetters.isPlayer && state.info.state === STATE_GAME
  },
  isOver: (state, _, __, rootGetters) => {
    return rootGetters.isPlayer && state.info.state === STATE_END
  },
  isUnknown: (state, _, __, rootGetters) => {
    return rootGetters.isPlayer && state.info.state === STATE_UNKNOWN
  },
  info: (state) => state.info
}

export default {
  namespaced: true,
  state,
  mutations,
  getters,
  actions
}
