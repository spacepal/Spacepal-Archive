import Vue from 'vue'

const state = {
  planetsByCellID: {},
  planetsByID: {}
}

const mutations = {
  SET_PLANETS (state, planets) {
    planets.forEach(p => {
      Vue.set(state.planetsByCellID, p.cellID, p)
      Vue.set(state.planetsByID, p.id, p)
    })
  },
  CLEAR_PLANETS (state) {
    state.planetsByCellID = {}
    state.planetsByID = {}
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
      return state.planetsByCellID[cellID]
    }
  },
  planetByID (state) {
    return (planetID) => {
      return state.planetsByID[planetID]
    }
  },
  planets (state) {
    return state.planetsByID
  },
  isMemberPlanetOwner (state, _, __, rootGetters) {
    return (planetID) => {
      return state.planetsByID[planetID].ownerID === rootGetters.profile.id
    }
  }
}

export default {
  state,
  mutations,
  getters,
  actions
}
