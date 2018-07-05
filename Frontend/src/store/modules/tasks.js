/* pending fleets */

import Vue from 'vue'

const state = {
  tasks: {},
  shipsDecreasing: {},
  autoTasks: {},
  isLocked: false,
  lastTaskID: 0
}

const mutations = {
  UNLOCK (state) {
    state.isLocked = false
  },
  CLEAR (state) {
    state.fleets = {}
    state.isLocked = true
  },
  ADD_TASK ({ tasks, shipsDecreasing, lastTaskID }, task) {
    Vue.set(tasks, lastTaskID, task)
  },
  DECREASE_SHIPS ({ shipsDecreasing }, { planetID, count }) {
    let decreasing = shipsDecreasing[planetID] || 0
    Vue.set(state.shipsDecreasing, planetID, decreasing + count)
  },
  REMOVE_TASK (state, taskID) {
    Vue.delete(state.tasks, taskID)
  },
  INCREASE_ID (state) {
    state.lastTaskID++
  }
}

const actions = {
  unlock ({ commit }) {
    commit('UNLOCK')
  },
  doAutoTasks ({ commit, state, dispatch }) {
    if (state.isLocked) {
      console.warn('tasks.doAutoTasks: isLocked')
      return
    }
    console.warn('tasks.doAutoTasks: @todo method')
  },
  del ({ state, commit }, taskID) {
    if (!state.tasks[taskID]) {
      console.warn('tasks.del: invalid taskID')
      return
    }
    commit('REMOVE_TASK', taskID)
  },
  add ({ getters, rootGetters, state, commit }, { from, to, count }) {
    if (state.isLocked) {
      console.warn('tasks.add: isLocked')
      return
    }
    let planet = rootGetters.planet(from)
    if (!planet) {
      console.warn('tasks.add: planet not found')
      return
    }
    if (rootGetters.isMemberPlanetOwner(from)) {
      console.warn('tasks.add: the member is not owner of planet')
      return
    }
    if (getters.availableShips(from) < count) {
      console.warn('tasks.add: lack of ships')
      return
    }
    commit('DECREASE_SHIPS', { planetID: from, count })
    commit('ADD_TASK', { from, to, count })
    commit('INCREASE_ID')
  },
  clear ({ commit }) {
    commit('CLEAR')
  }
}

const getters = {
  all ({ tasks }) {
    return tasks
  },
  isLocked ({ isLocked }) {
    return isLocked
  },
  availableShips ({ shipsDecreasing }, _, __, { planet, isMemberPlanetOwner }) {
    return (planetID) => {
      let p = planet(planetID)
      if (!p || !isMemberPlanetOwner(planetID)) {
        return 0
      }
      let dec = shipsDecreasing[planetID] || 0
      return Math.max(0, p.shipsCount - dec)
    }
  },
  shipsDecreasing ({ shipsDecreasing }) {
    return (planetID) => {
      return shipsDecreasing[planetID] || 0
    }
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  getters,
  actions
}
