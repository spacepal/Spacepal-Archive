import Vue from 'vue'
import { DEFAULT_BACKEND } from '../../common/constants'

const STORAGE_PREFIX = 'pref_'

const DEFAULT_VALUES = { // only Boolean, Number, String !
  menuIsVisible: true,
  fullRender: false,
  backendServer: DEFAULT_BACKEND,
  autoEvent: true,
  autoGameInfo: true,
  turnAnim: true
}

function getAdoptedKey (key) {
  return STORAGE_PREFIX + key.toLowerCase()
}

const state = {
  settings: Object.keys(DEFAULT_VALUES).reduce((accum, key) => {
    let savedVal = localStorage.getItem(getAdoptedKey(key))
    let defVal = DEFAULT_VALUES[key]
    if (savedVal === null) {
      accum[key] = defVal
    } else {
      if (typeof defVal === 'number') {
        accum[key] = parseInt(savedVal)
      } else if (typeof defVal === 'boolean') {
        accum[key] = savedVal === 'true'
      } else {
        accum[key] = savedVal
      }
    }
    return accum
  }, {})
}

const mutations = {
  SET_VALUE (state, { key, value }) {
    Vue.set(state.settings, key, value)
  }
}

const actions = {
  set ({ commit }, params) {
    localStorage.setItem(getAdoptedKey(params.key), params.value)
    commit('SET_VALUE', params)
  },
  toggleMenuVisibility ({ state, dispatch }) {
    dispatch('set', {
      key: 'menuIsVisible',
      value: !state.settings.menuIsVisible
    })
  },
  reset ({ dispatch }) {
    Object.keys(DEFAULT_VALUES).forEach(key => {
      dispatch('set', { key, value: DEFAULT_VALUES[key] })
    })
  }
}

const getters = {
  menuIsVisible (state) {
    return state.settings.menuIsVisible
  },
  fullRender (state) {
    return state.settings.fullRender
  },
  backendServer (state) {
    return state.settings.backendServer
  },
  autoEvent (state) {
    return state.settings.autoEvent
  },
  autoGameInfo (state) {
    return state.settings.autoGameInfo
  },
  turnAnim (state) {
    return state.settings.turnAnim
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  getters,
  actions
}
