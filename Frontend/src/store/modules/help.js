import Vue from 'vue'

const STORAGE_DONE = 'help_done'

// descr auto translated
const state = {
  done: JSON.parse(localStorage.getItem(STORAGE_DONE)) || {},
  stages: {
    'GamesList': [
      {
        descr: () => {
          return [
            'Welcome!',
            'Spacepal is a web-version of Konquest strategy game.',
            'The goal of the game is to expand your power across the universe.'
          ]
        },
        el: _ => undefined
      },
      {
        descr: () => [
          'This is a list of rooms, that are created by other players.',
          'You can join one, but rush to nothing...'
        ],
        el: ($refs) => $refs.gamesList.$el,
        pos: 'top'
      },
      {
        descr: () => [
          'Create your first game for familiarity with SpacePal.',
          'For this click New button or Dice for the game with random parameters'],
        el: ($refs) => $refs.buttonsCreation
      }
    ],
    'CreateGame': [
      {
        descr: () => {
          return [
            'This is form for game creation'
          ]
        },
        el: _ => undefined
      },
      {
        descr: () => {
          return [
            'It\'s good to set map width > height.'
          ]
        },
        el: $refs => $refs.mapSize,
        pos: 'top'
      },
      {
        descr: () => {
          return [
            'pac-help',
            'accum-help',
            'pirates-help',
            'buffs-help'
          ]
        },
        el: $refs => $refs.switches,
        pos: 'top'
      },
      {
        descr: () => {
          return [
            'Set a pincode so that other players can not join.'
          ]
        },
        el: $refs => $refs.pin,
        pos: 'top'
      }
    ]
  }
}

const mutations = {
  DONE (state, name) {
    Vue.set(state.done, name, 'true')
    localStorage.setItem(STORAGE_DONE, JSON.stringify(state.done))
  }
}

const actions = {
  done ({ commit }, name) {
    commit('DONE', name)
  }
}

const getters = {
  stages: (state) => state.stages,
  done: state => {
    return (name) => state.done[name] === 'true'
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  getters,
  actions
}
