/* pending fleets */

import Vue from 'vue'
import { calcDistance } from '../../common/DistanceHelper.js'

const state = {
  tasks: {},
  shipsDecreasing: {},
  autoTasks: {},
  lastTaskID: 0
}

const mutations = {
  CLEAR (state) {
    Object.keys(state.tasks).forEach(key => {
      Vue.delete(state.tasks, key)
    })
    Object.keys(state.shipsDecreasing).forEach(key => {
      Vue.delete(state.shipsDecreasing, key)
    })
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
  INCREASE_SHIPS ({ shipsDecreasing }, { planetID, count }) {
    let decreasing = shipsDecreasing[planetID] || 0
    Vue.set(state.shipsDecreasing, planetID, decreasing - count)
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
  doAutoTasks ({ state, rootGetters, dispatch, getters }) {
    if (rootGetters.isLocked) {
      console.warn('tasks.doAutoTasks: isLocked')
      return
    }
    for (let taskID in state.autoTasks) {
      let task = state.autoTasks[taskID]
      let planet = rootGetters.planetByID(task.from)
      if (!planet || !rootGetters.isMemberPlanetOwner(task.from)) {
        dispatch('del', taskID)
        continue
      }
      task.isAutoTask = false
      let count = getters.availableShips(task.from) - task.count
      if (count > 1) {
        dispatch('add', {
          from: task.from,
          to: task.to,
          count: count
        })
      }
    }
    dispatch('syncSet', 'autotasks', { root: true })
  },
  del ({ state, commit }, taskID) {
    if (state.autoTasks[taskID]) {
      commit('REMOVE_AUTO_TASK', taskID)
    } else if (state.tasks[taskID]) {
      let task = state.tasks[taskID]
      commit('REMOVE_TASK', taskID)
      commit('INCREASE_SHIPS', { planetID: task.from, count: task.count })
    } else {
      console.warn('tasks.del: invalid taskID')
    }
  },
  add ({ state, getters, rootGetters, commit, dispatch },
    { from, to, count, isAutoTask }) {
    let planet = rootGetters.planetByID(from)
    if (!planet) {
      console.warn('tasks.add: the planet is not found')
      return
    }
    if (!rootGetters.planetByID(to)) {
      console.warn('tasks.add: target planet is not found')
      return
    }
    if (!rootGetters.isMemberPlanetOwner(from)) {
      console.warn('tasks.add: the member is not owner of the planet')
      return
    }
    let stepsLeft = calcDistance(
      rootGetters.planetByID(to).cellID,
      rootGetters.planetByID(from).cellID,
      rootGetters['game/info'].mapWidth
    )
    if (isAutoTask) {
      let autoTasks = state.autoTasks
      for (let id in autoTasks) {
        if (autoTasks[id].from === from) {
          dispatch('del', id)
        }
      }
      commit('ADD_AUTO_TASK', { from, to, count, stepsLeft })
      commit('INCREASE_ID')
      count = getters.availableShips(from) - count
      if (count < 1) {
        return
      }
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
    commit('ADD_TASK', { from, to, count, stepsLeft })
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
      return Math.max(0, p.ships - dec)
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
