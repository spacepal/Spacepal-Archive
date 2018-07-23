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
  set ({ commit }, { slot, planetID }) {
    if (slot > MIN_BOOKMARK_SLOT &&
      slot < MAX_BOOKMARK_SLOT &&
      Math.floor(slot) === Math.ceil(slot)) {
      commit('SET_BOOKMARK', { slot, planetID })
      sessionStorage.setItem(STORAGE_BOOKMARKS,
        JSON.stringify(state.bookmarks))
      return true
    }
    return false
  },
  reset ({ commit }, { slot }) {
    commit('DEL_BOOKMARK', slot)
    sessionStorage.setItem(STORAGE_BOOKMARKS,
      JSON.stringify(state.bookmarks))
  }
}

const getters = {
  // returns planet for slot or undefined
  bySlot (state, _, __, rootGetters) {
    return (slot) => {
      let pID = state.bookmarks[slot]
      if (pID) {
        return rootGetters.planetByID(pID)
      }
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
