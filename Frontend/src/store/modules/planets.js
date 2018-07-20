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
    Object.values(state.planetsByID).forEach(p => {
      Vue.delete(state.planetsByCellID, p.cellID)
      Vue.delete(state.planetsByID, p.id)
    })
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
  // returns the best planet for current player
  theBestPlanet ({ planetsByID }, _, __, rootGetters) {
    let id = rootGetters.profile.id
    if (!id) {
      return undefined
    }
    let memberPlanets = []
    for (let planetID in planetsByID) {
      let p = planetsByID[planetID]
      if (p.ownerID === id) {
        memberPlanets.push(p)
      }
    }
    let calcPower = (p) => p.killPerc * p.production
    return memberPlanets.sort((b, a) => calcPower(a) - calcPower(b))[0]
  },
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
