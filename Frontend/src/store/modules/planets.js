import Vue from 'vue'

const state = {
  planets: {}
}

const mutations = {
  SET_PLANETS (state, planets) {
    planets.forEach(p => {
      Vue.set(state.planets, p.cellID, p)
    })
  },
  CLEAR_PLANETS (state) {
    state.planets = {}
  }
}

const actions = {
  setPlanets ({ commit }, planets) {
    commit('CLEAR_PLANETS')
    commit('SET_PLANETS', planets)
  }
}

const getters = {
  planet (state) {
    return (cellID) => {
      return state.planets[cellID]
    }
  },
  planets (state) {
    return state.planets
  }
}

export default {
  state,
  mutations,
  getters,
  actions
}
