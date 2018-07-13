import { GAME_CHANNEL, WS_SERVER } from './constants.js'
import ActionCable from 'actioncable'
import store from '@/store'

const END_TURN_ACTION = 'end_turn'

export default class ActionCabel {
  constructor (gameID) {
    this._okPromise = new Promise((resolve, reject) => {
      this._okResolvePromise = resolve
      this._okRejectPromise = reject
      this._cable = ActionCable.createConsumer(WS_SERVER)
      this._cable.subscriptions.create({
        channel: GAME_CHANNEL,
        room: `games:${gameID}`
      },
      {
        connected: this.onConnected.bind(this),
        received: this.onReceived.bind(this),
        disconnected: this.onDisconnected.bind(this)
      })
    })
  }
  onConnected () {
    console.info('Action cable: connected')
  }
  onDisconnected () {
    console.info('Action cable: disconnected')
    this._okRejectPromise(false)
  }
  onReceived (data) {
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
      this._cable.subscriptions.create({
        channel: GAME_CHANNEL,
        room: `players:${data.id}`
      },
      {
        connected: this.onConnected,
        received: this.onReceived,
        disconnected: this.onDisconnected
      })
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
  }
  get isOk () {
    return this._okPromise
  }
  endTurn (fleets) {
    this._cable.perform(END_TURN_ACTION, { fleets })
  }
}
