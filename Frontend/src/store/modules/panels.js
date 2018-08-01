import Vue from 'vue'

const state = {
  groups: { }
}

const mutations = {
  CREATE_GROUP (state, group) {
    Vue.set(state.groups, group, { })
  },
  UNREGISTER_PANEL (state, { group, panel }) {
    Vue.delete(state.groups[group], panel)
    if (Object.keys(state.groups[group]).length === 0) {
      Vue.delete(state.groups, group)
    }
  },
  HIDE_PANEL (state, { group, panel }) {
    Vue.set(state.groups[group], panel, false)
  },
  SHOW_PANEL (state, { group, panel }) {
    Vue.set(state.groups[group], panel, true)
  }
}

const actions = {
  register ({ state, commit }, panelInfo) {
    if (!(panelInfo.group in state.groups)) {
      commit('CREATE_GROUP', panelInfo.group)
    }
    commit('HIDE_PANEL', panelInfo)
  },
  unregister ({ commit }, panelInfo) {
    commit('UNREGISTER_PANEL', panelInfo)
  },
  toggle ({ state, dispatch }, panelInfo) {
    if (state.groups[panelInfo.group][panelInfo.panel]) {
      dispatch('hide', panelInfo)
    } else {
      dispatch('show', panelInfo)
    }
  },
  hide ({ commit }, panelInfo) {
    commit('HIDE_PANEL', panelInfo)
  },
  hideAll ({ commit }, group) {
    let grp = state.groups[group]
    Object.keys(grp).forEach(panel => {
      commit('HIDE_PANEL', { group, panel })
    })
  },
  show ({ state, commit, dispatch }, panelInfo) {
    dispatch('hideAll', panelInfo.group)
    commit('SHOW_PANEL', panelInfo)
  }
}

const getters = {
  groups (state) {
    return state.groups
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  getters,
  actions
}
