/* Planet bookmarks */

import Vue from 'vue'
import { MIN_BOOKMARK_SLOT, MAX_BOOKMARK_SLOT } from '../../common/constants.js'

const STORAGE_BOOKMARKS = 'bookmarks'

const state = {
  bookmarks: JSON.parse(sessionStorage.getItem(STORAGE_BOOKMARKS)) || {}
}

const mutations = {
  SET_BOOKMARK (state, { slot, planetID }) {
    Vue.set(state.bookmarks, slot, planetID)
  },
  DEL_BOOKMARK (state, slot) {
    Vue.delete(state.bookmarks, slot)
  }
}

const actions = {
  setSlot ({ commit }, { slot, planetID }) {
    if (slot >= MIN_BOOKMARK_SLOT &&
      slot <= MAX_BOOKMARK_SLOT &&
      Math.floor(slot) === Math.ceil(slot)) {
      commit('SET_BOOKMARK', { slot, planetID })
      sessionStorage.setItem(STORAGE_BOOKMARKS,
        JSON.stringify(state.bookmarks))
      return true
    }
    return false
  },
  resetSlot ({ commit }, slot) {
    commit('DEL_BOOKMARK', slot)
    sessionStorage.setItem(STORAGE_BOOKMARKS,
      JSON.stringify(state.bookmarks))
  }
}

const getters = {
  count (state) {
    let count = 0
    Object.values(state.bookmarks).forEach(planetID => {
      if (planetID) {
        count++
      }
    })
    return count
  },
  all (state, _, __, rootGetters) {
    let slots = {}
    for (let i = MIN_BOOKMARK_SLOT; i <= MAX_BOOKMARK_SLOT; ++i) {
      let pID = state.bookmarks[i]
      let p
      if (pID) {
        p = rootGetters.planetByID(pID)
      }
      slots[i] = p
    }
    return slots
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  getters,
  actions
}
