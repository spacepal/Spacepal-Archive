import { GAME_CHANNEL, PLAYER_CHANNEL, WS_SERVER } from './constants.js'
import ActionCable from 'actioncable'
import store from '@/store'

const END_TURN_ACTION = 'end_turn'
const SHUFFLE_ACTION = 'shuffle'
const START_ACTION = 'start_game'

export default class ActionCabel {
  constructor (gameID) {
    let self = this
    this._cable = ActionCable.createConsumer(WS_SERVER)
    this._okPromise = new Promise((resolve, reject) => {
      self._okResolvePromise = resolve
      self._okRejectPromise = reject
      self._gameRoom = this._cable.subscriptions.create({
        channel: GAME_CHANNEL,
        room: `games:${gameID}`
      },
      {
        connected: this.onConnected.bind(self),
        received: this.onReceived.bind(self),
        disconnected: this.onDisconnected.bind(self)
      })
    })
  }
  onConnected () {
    console.info('Action cable: connnected')
  }
  onDisconnected () {
    console.info('Action cable: disconnected')
    if (typeof this._okResolvePromise === 'function') {
      this._okRejectPromise(false)
    }
  }
  onReceived (data) {
    console.info(`Action cable: data recieved`)
    console.info(data)
    if (data.type === 'error' && typeof this._okRejectPromise === 'function') {
      this._okRejectPromise(false)
      this._okRejectPromise = undefined
    } else if (typeof this._okResolvePromise === 'function') {
      this._okResolvePromise(true)
      this._okResolvePromise = undefined
    }
    if (data.type === 'players') {
      store.dispatch('setMembers', data.data.players)
    } else if (data.type === 'game') {
      store.dispatch('game/setInfo', data.data)
    } else if (data.type === 'profile') {
      this._cable.subscriptions.create({
        channel: PLAYER_CHANNEL,
        room: `players:${data.data.id}`
      },
      {
        connected: this.onConnected.bind(this),
        received: this.onReceived.bind(this),
        disconnected: this.onDisconnected.bind(this)
      })
      store.dispatch('setProfile', data.data)
    } else if (data.type === 'fleets') {
      store.dispatch('fleets/set', data.data.fleets)
    } else if (data.type === 'planets') {
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
  shuffleMap () {
    this._gameRoom.perform(SHUFFLE_ACTION)
  }
  endTurn (fleets) {
    this._gameRoom.perform(END_TURN_ACTION, { fleets })
  }
  start (fleets) {
    this._gameRoom.perform(START_ACTION, { fleets })
  }
}
