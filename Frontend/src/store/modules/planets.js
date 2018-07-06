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
  setPlanets ({ commit, dispatch }, planets) {
    commit('CLEAR_PLANETS')
    commit('SET_PLANETS', planets)
    dispatch('syncSet', 'planets', { root: true })
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
  },
  isMemberPlanetOwner (state) {
    return (memberID) => {
      return state.planets[memberID] === memberID
    }
  }
}

export default {
  state,
  mutations,
  getters,
  actions
}
