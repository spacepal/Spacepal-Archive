import { GAME_CHANNEL } from './constants.js'
import ActionCable from 'actioncable'
import store from '@/store'

const END_TURN_ACTION = 'end_turn'

export default class ActionCabel {
  constructor (gameID) {
    this._okPromise = new Promise((resolve, reject) => {
      this._okResolvePromise = resolve
      this._okRejectPromise = resolve
    })
    this._cable = ActionCable.createConsumer()
    this._cable.subscriptions.create({
      channel: GAME_CHANNEL,
      room: `GAME:${gameID}`
    },
    {
      connected: () => {
        console.info('Action cable: connected')
      },
      received: data => {
        console.info(`Action cable: data recieved`)
        console.info(data)
        if (data.type === 'error') {
          this._okRejectPromise(false)
        } else {
          this._okResolvePromise(true)
        }
        if (data.type === 'players') {
          store.dispatch('setMembers', data.data.players)
        } else if (data.type === 'game') {
          store.dispatch('game/setInfo', data.data)
        } else if (data.type === 'profile') {
          store.dispatch('setProfile', data.data)
        } else if (data.type === 'fleets') {
          store.dispatch('fleets/set', data.data.fleets)
        } else if (data.type === 'fleets') {
          store.dispatch('setPlanets', data.data.planets)
        } else if (data.type === 'turn_ended') {
          store.dispatch('reset')
        } else {
          console.warn(`ActionCable.js: Unknown type`)
        }
      },
      disconnected: () => {
        console.info('Action cable: disconnected')
        this._okRejectPromise(false)
      }
    })
  }
  get isOk () {
    return this._okPromise
  }
  endTurn (fleets) {
    this._cable.perform(END_TURN_ACTION, { fleets })
  }
}
