class GameChannel < ApplicationCable::Channel

  def subscribed
    game = Player[current_player.id].game
    core = Core.new
    stream_from ("games:" + game.id.to_s)
    transmit core.transmitted_player(current_player.id)
    core.broadcast_all_data ("games:" + game.id.to_s), game.id, current_player.id
    # stream_from "some_channel"
  end

  #cheats

  def start_game
    player = current_player 
    game = Player[player.id].game
    core = Core.new
    core.start_game game.id
    core.broadcast_all_data ("games:" + game.id.to_s), game.id, player.id
  end

  def shuffle
    game = Player[current_player.id].game
    core = Core.new
    core.shuffle_map game.id
    core.broadcast_planets ("games:" + game.id.to_s), game.id
  end

  def end_turn
    #TB.new Player[current_player.id].game.id
    #на входе json корабли и игрок_id
    #в либе пишу broadcast
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
