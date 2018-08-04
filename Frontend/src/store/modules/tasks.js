/* pending fleets */

import Vue from 'vue'
import { calcDistance } from '../../common/DistanceHelper.js'
import debug from '../../common/Debug.js'

const STORAGE_AUTOTASKS = 'autotasks'
const STORAGE_TASKS = 'tasks'
const STORAGE_TASKS_TURN = 'tasks_turn'

let savedAutoTasks = JSON.parse(sessionStorage.getItem(STORAGE_AUTOTASKS)) || {}

function saveTasks (tasks, turnNumber) {
  sessionStorage.setItem(STORAGE_TASKS_TURN, turnNumber)
  sessionStorage.setItem(STORAGE_TASKS, JSON.stringify(tasks))
}

const state = {
  tasks: { },
  shipsDecreasing: {},
  autoTasks: savedAutoTasks,
  lastTaskID: Object.keys(savedAutoTasks).reduce(
    (last, cur) => Math.max(last, cur), 0) + 1
}

const mutations = {
  CLEAR_TASKS (state) {
    Object.keys(state.tasks).forEach(key => {
      Vue.delete(state.tasks, key)
    })
    Object.keys(state.shipsDecreasing).forEach(key => {
      Vue.delete(state.shipsDecreasing, key)
    })
  },
  CLEAR_AUTO_TASKS (state) {
    Object.keys(state.autoTasks).forEach(key => {
      Vue.delete(state.autoTasks, key)
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
  REMOVE_AUTO_TASK (state, autoTaskID) {
    Vue.delete(state.autoTasks, autoTaskID)
  },
  INCREASE_ID (state) {
    state.lastTaskID++
  }
}

const actions = {
  setSaved ({ dispatch, rootGetters }) {
    let savedTasksTurn = parseInt(sessionStorage.getItem(STORAGE_TASKS_TURN)) || -1
    if (rootGetters['game/info'].turnNumber === savedTasksTurn) {
      let savedTasks = JSON.parse(sessionStorage.getItem(STORAGE_TASKS)) || {}
      Object.values(savedTasks).forEach(task => {
        dispatch('add', {
          from: task.from,
          to: task.to,
          count: task.count,
          isDispatchAutoTask: false,
          isHoldAutoTask: false,
          autoTaskID: task.autoTaskID
        })
      })
    }
  },
  doAutoTasks ({ state, rootGetters, dispatch }) {
    if (rootGetters.isLocked) {
      debug.warn('tasks.doAutoTasks: isLocked')
      return
    }
    for (let taskID in state.autoTasks) {
      dispatch('doAutoTask', taskID)
    }
    dispatch('syncSet', 'autotasks', { root: true })
  },
  doAutoTask ({ state, rootGetters, dispatch, getters }, taskID) {
    let task = state.autoTasks[taskID]
    if (!task) {
      debug.warn('tasks.doAutoTask: task$' + taskID + ' is undefined')
      return
    }
    let planet = rootGetters.planetByID(task.from)
    if (!planet || !rootGetters.isMemberPlanetOwner(task.from)) {
      dispatch('del', taskID)
      return
    }
    let count = 0
    if (task.hold) {
      count = getters.availableShips(task.from) - task.count
    } else if (task.dispatch && getters.availableShips(task.from) > task.count) {
      count = task.count
    }
    if (count > 1) {
      dispatch('add', {
        from: task.from,
        to: task.to,
        count,
        autoTaskID: taskID
      })
    }
  },
  del ({ state, commit, rootGetters, dispatch }, taskID) {
    taskID = parseInt(taskID)
    if (state.autoTasks[taskID]) {
      commit('REMOVE_AUTO_TASK', taskID)
      Object.keys(state.tasks).forEach(tID => {
        let task = state.tasks[tID]
        if (task.autoTaskID === taskID) {
          dispatch('del', tID)
          return true
        }
        return false
      })
      sessionStorage.setItem(STORAGE_AUTOTASKS, JSON.stringify(state.autoTasks))
    } else if (state.tasks[taskID]) {
      let task = state.tasks[taskID]
      commit('REMOVE_TASK', taskID)
      commit('INCREASE_SHIPS', { planetID: task.from, count: task.count })
      saveTasks(state.tasks, rootGetters['game/info'].turnNumber)
    } else {
      debug.warn('tasks.del: invalid taskID')
    }
  },
  add ({ state, getters, rootGetters, commit, dispatch },
    { from, to, count, autoTaskID, isDispatchAutoTask, isHoldAutoTask }) {
    autoTaskID = parseInt(autoTaskID)
    let planet = rootGetters.planetByID(from)
    if (!planet) {
      debug.warn('tasks.add: the planet is not found')
      return
    }
    if (!rootGetters.planetByID(to)) {
      debug.warn('tasks.add: target planet is not found')
      return
    }
    if (!rootGetters.isMemberPlanetOwner(from)) {
      debug.warn('tasks.add: the member is not owner of the planet')
      return
    }
    let stepsLeft = calcDistance(
      rootGetters.planetByID(to).cellID,
      rootGetters.planetByID(from).cellID,
      rootGetters['game/info'].mapWidth
    )
    if (isHoldAutoTask && isDispatchAutoTask) {
      debug.warn('tasks.add: hold and dispatch are set at the same time')
      return
    }
    if (isHoldAutoTask || isDispatchAutoTask) {
      let autoTasks = state.autoTasks
      for (let id in autoTasks) {
        if (autoTasks[id].from === from) {
          dispatch('del', id)
        }
      }
      commit('ADD_AUTO_TASK', {
        from,
        to,
        count,
        stepsLeft,
        hold: isHoldAutoTask,
        dispatch: isDispatchAutoTask
      })
      let taskID = state.lastTaskID
      commit('INCREASE_ID')
      dispatch('doAutoTask', taskID)
      sessionStorage.setItem(STORAGE_AUTOTASKS, JSON.stringify(state.autoTasks))
      return
    }
    if (rootGetters.isLocked) {
      debug.warn('tasks.add: isLocked')
      return
    }
    if (getters.availableShips(from) < count) {
      debug.warn('tasks.add: lack of ships')
      return
    }
    commit('DECREASE_SHIPS', { planetID: from, count })
    commit('ADD_TASK', { from, to, count, stepsLeft, autoTaskID })
    commit('INCREASE_ID')
    saveTasks(state.tasks, rootGetters['game/info'].turnNumber)
  },
  clear ({ commit }) {
    sessionStorage.removeItem(STORAGE_TASKS)
    commit('CLEAR_TASKS')
  },
  clearAutoTasks ({ commit }) {
    sessionStorage.removeItem(STORAGE_AUTOTASKS)
    commit('CLEAR_AUTO_TASKS')
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
