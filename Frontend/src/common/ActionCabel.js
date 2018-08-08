import { GAME_CHANNEL, PLAYER_CHANNEL, CHAT_CHANNEL } from './constants.js'
import debug from './Debug.js'
import ActionCable from 'actioncable'
import store from '@/store'

const END_TURN_ACTION = 'end_turn'
const SHUFFLE_ACTION = 'shuffle'
const START_ACTION = 'start_game'
const ADD_BOT_ACTION = 'add_bot'
const DEL_BOT_ACTION = 'del_bot'
const REQUEST_DATA_ACTION = 'ask_data'
const REQUEST_MESSAGES_ACTION = 'ask_messages'
const SEND_MESSAGE_ACTION = 'send_message'

export default class ActionCabel {
  constructor (gameID, wsServer) {
    let self = this
    this._playerRoom = undefined
    this._cable = ActionCable.createConsumer(wsServer)
    this._okPromise = new Promise((resolve, reject) => {
      self._okResolvePromise = resolve
      self._okRejectPromise = reject
      self._gameRoom = this._cable.subscriptions.create({
        channel: GAME_CHANNEL,
        room: `games:${gameID}`
      },
      {
        connected: () => {
          self.onConnected(`games:${gameID}`)
        },
        received: this.onReceived.bind(self),
        disconnected: this.onDisconnected.bind(self)
      })
      self._chatRoom = this._cable.subscriptions.create({
        channel: CHAT_CHANNEL,
        room: `chats:${gameID}`
      },
      {
        connected: () => {
          self.requestMessages()
          self.onConnected(`chats:${gameID}`)
        },
        received: this.onReceived.bind(self),
        disconnected: this.onDisconnected.bind(self)
      })
    })
  }
  onConnected (room) {
    debug.info('Action cable: connnected: ', room)
  }
  onDisconnected () {
    debug.info('Action cable: disconnected')
    if (typeof this._okResolvePromise === 'function') {
      this._okRejectPromise(false)
    }
  }
  close () {
    if (this._gameRoom) {
      this._gameRoom.unsubscribe()
    }
    if (this._playerRoom) {
      this._playerRoom.unsubscribe()
    }
  }
  onReceived (data) {
    debug.info(`Action cable: data recieved`)
    debug.info(data)
    if (data.type === 'error' && typeof this._okRejectPromise === 'function') {
      this._okRejectPromise(false)
      this._okRejectPromise = undefined
    } else if (typeof this._okResolvePromise === 'function') {
      this._okResolvePromise(true)
      this._okResolvePromise = undefined
    }
    if (data.type === 'room' && this._playerRoom === undefined) {
      this._playerRoom = this._cable.subscriptions.create({
        channel: PLAYER_CHANNEL,
        room: data.data.roomName
      },
      {
        connected: () => {
          this.requestData()
          this.onConnected(data.data.roomName)
        },
        received: this.onReceived.bind(this),
        disconnected: this.onDisconnected.bind(this)
      })
    } else if (data.type === 'players') {
      store.dispatch('setMembers', data.data.players)
    } else if (data.type === 'game') {
      store.dispatch('game/setInfo', data.data)
    } else if (data.type === 'profile') {
      store.dispatch('setProfile', data.data)
    } else if (data.type === 'fleets') {
      store.dispatch('fleets/set', data.data.fleets)
    } else if (data.type === 'planets') {
      store.dispatch('setPlanets', data.data.planets)
    } else if (data.type === 'turn_ended') {
      store.dispatch('reset')
      store.dispatch('syncSet', 'endTurn')
      this.requestData()
    } else if (data.type === 'notifications') {
      store.dispatch('events/set', data.data.notifications)
    } else if (data.type === 'messages') {
      store.dispatch('chat/set', data.data.messages)
    } else if (data.type === 'message') {
      store.dispatch('chat/add', data.data.message)
    } else {
      debug.warn(`ActionCable.js: Unknown type`)
    }
  }
  get isOk () {
    return this._okPromise
  }
  shuffleMap () {
    this._gameRoom.perform(SHUFFLE_ACTION)
  }
  addBot () {
    this._gameRoom.perform(ADD_BOT_ACTION, { })
  }
  delBot (id) {
    this._gameRoom.perform(DEL_BOT_ACTION, { id })
  }
  endTurn (fleets) {
    this._gameRoom.perform(END_TURN_ACTION, { fleets })
  }
  start () {
    this._gameRoom.perform(START_ACTION, { })
  }
  requestData () {
    this._gameRoom.perform(REQUEST_DATA_ACTION, { })
  }
  requestMessages () {
    this._chatRoom.perform(REQUEST_MESSAGES_ACTION, { })
  }
  sendMessage (message) {
    this._chatRoom.perform(SEND_MESSAGE_ACTION, message)
  }
}
