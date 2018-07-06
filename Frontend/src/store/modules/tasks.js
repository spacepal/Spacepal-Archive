/* pending fleets */

import Vue from 'vue'

const state = {
  tasks: {},
  shipsDecreasing: {},
  autoTasks: {},
  lastTaskID: 0
}

const mutations = {
  CLEAR (state) {
    state.tasks = {}
  },
  ADD_TASK ({ tasks, lastTaskID }, task) {
    Vue.set(tasks, lastTaskID, task)
  },
  ADD_AUTO_TASK ({ autoTasks, lastTaskID }, autoTask) {
    Vue.set(autoTasks, lastTaskID, autoTask)
  },
  DECREASE_SHIPS ({ shipsDecreasing }, { planetID, count }) {
    let decreasing = shipsDecreasing[planetID] || 0
    Vue.set(state.shipsDecreasing, planetID, decreasing + count)
  },
  REMOVE_TASK (state, taskID) {
    Vue.delete(state.tasks, taskID)
  },
  REMOVE_AUTO_TASK (state, taskID) {
    Vue.delete(state.autoTasks, taskID)
  },
  INCREASE_ID (state) {
    state.lastTaskID++
  }
}

const actions = {
  doAutoTasks ({ state, rootGetters, dispatch }) {
    if (rootGetters.isLocked) {
      console.warn('tasks.doAutoTasks: isLocked')
      return
    }
    for (let taskID in state.autoTasks) {
      let task = state.autoTasks[taskID]
      let planet = rootGetters.planet(task.from)
      if (!planet || !rootGetters.isMemberPlanetOwner(task.from)) {
        dispatch('del', taskID)
        continue
      }
      task.isAutoTask = false
      dispatch('add', task)
    }
    dispatch('syncSet', 'autotasks', { root: true })
  },
  del ({ state, commit }, taskID) {
    if (state.autoTasks[taskID]) {
      commit('REMOVE_AUTO_TASK', taskID)
    } else if (state.tasks[taskID]) {
      commit('REMOVE_TASK', taskID)
    } else {
      console.warn('tasks.del: invalid taskID')
    }
  },
  add ({ getters, rootGetters, commit }, { from, to, count, isAutoTask }) {
    let planet = rootGetters.planet(from)
    if (!planet) {
      console.warn('tasks.add: planet not found')
      return
    }
    if (!rootGetters.isMemberPlanetOwner(from)) {
      console.warn('tasks.add: the member is not owner of planet')
      return
    }
    if (isAutoTask) {
      commit('ADD_AUTO_TASK', { from, to, count })
      commit('INCREASE_ID')
      return
    }
    if (rootGetters.isLocked) {
      console.warn('tasks.add: isLocked')
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
  clear ({ commit, dispatch }) {
    commit('CLEAR')
    dispatch('syncSet', 'tasks', { root: true })
  }
}

const getters = {
  all ({ tasks }) {
    return tasks
  },
  autoTasks ({ autoTasks }) {
    return autoTasks
  },
  availableShips ({ shipsDecreasing }, _, __, { planetByID, isMemberPlanetOwner }) {
    return (planetID) => {
      let p = planetByID(planetID)
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
