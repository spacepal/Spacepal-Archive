class GameChannel < ApplicationCable::Channel
    
  GAME_DATA = {
    id: 5,
    name: "String",
    creator: "String",
    pinCode: "String",
    mapWidth: 10,
    mapHeight: 10,
    planets: 95,
    playersLimit: 8,
    buffs: true,
    pirates: false,
    accumulative: false,
    productionAfterCapture: true,
    turnNumber: 55,
    state: 1
  }

  def subscribed
    game = Player[current_player.id].game
    player = Player[current_player.id]
    stream_from ("games:" + game.id.to_s)
    stream_from ("players:" + player.id.to_s)
    transmit type: "game", data: GAME_DATA# а дальше json, который передаётся

    # stream_from "some_channel"
  end

  #cheats

  def end_turn
    #TB.new Player[current_player.id].game.id
    #на входе json корабли и игрок_id
    #в либе пишу broadcast
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
