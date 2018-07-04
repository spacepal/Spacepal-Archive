import { GAME_CHANNEL } from './constants.js'
import ActionCable from 'actioncable'
// import store from '@/store'

const END_TURN_ACTION = 'end_turn'

export default class ActionCabel {
  constructor (gameID) {
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
      },
      disconnected: () => {
        console.info('Action cable: disconnected')
      }
    })
  }
  endTurn (fleets) {
    this._cable.perform(END_TURN_ACTION, { fleets })
  }
}
