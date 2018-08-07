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
          'This is the list of rooms, that are created by other players.',
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
    ],
    'Room': [
      {
        descr: () => {
          return [
            'This is the room. Players are waiting for start here.'
          ]
        },
        el: _ => undefined
      },
      {
        descr: () => {
          return [
            'room-map-help-1',
            'room-map-help-2',
            'room-map-help-3'
          ]
        },
        el: $refs => $refs.map.$el
      },
      {
        descr: () => {
          return [
            'room-planet-help-1',
            'room-planet-help-2',
            'room-planet-help-3',
            'room-planet-help-4'
          ]
        },
        el: $refs => $refs.map.$el
      },
      {
        descr: ({ isCreator }) => {
          return [
            'room-members-help-1',
            isCreator ? 'room-members-help-creator-2' : 'room-members-help-2',
            'room-members-help-3',
            'room-members-help-4'
          ]
        },
        el: $refs => $refs.members.$el,
        pos: 'top'
      },
      {
        descr: ({ isCreator }) => {
          if (isCreator) {
            return [
              'room-actions-help-creator-1',
              'room-actions-help-creator-2',
              'room-actions-help-creator-3'
            ]
          }
          return [
            'room-actions-help'
          ]
        },
        el: $refs => $refs.actions.$el,
        pos: 'top'
      }
    ],
    'Game': [
      {
        descr: () => {
          return [
            'game-help-1',
            'game-help-2',
            'game-help-3'
          ]
        },
        el: _ => undefined
      },
      {
        descr: ({ accum, pirates }) => {
          return [
            accum ? 'game-help-accum-4' : 'game-help-noaccum-4',
            pirates ? 'game-help-pirates-5' : 'game-help-nopirates-5',
            'game-help-6'
          ]
        },
        el: _ => undefined
      },
      {
        descr: () => {
          return [
            'game-help-map-1',
            'game-help-map-2'
          ]
        },
        el: $refs => $refs.map.$el
      },
      {
        descr: () => {
          return [
            'game-help-7',
            'game-help-8',
            'game-help-9',
            'game-help-10'
          ]
        },
        el: _ => undefined
      },
      {
        descr: () => {
          return [
            'game-help-11',
            'game-help-12',
            'game-help-13'
          ]
        },
        el: _ => undefined
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
