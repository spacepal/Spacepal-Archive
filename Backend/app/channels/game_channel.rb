class GameChannel < ApplicationCable::Channel

  def subscribed
    game = Player[current_player.id].game
    core = Core.new
    stream_from ("games:" + game.id.to_s)
    transmit core.transmitted_player(current_player.id)
    core.broadcast_all_data game.id, current_player.id
    # stream_from "some_channel"
  end

  #cheats

  def start_game
    player = current_player 
    game = Player[player.id].game
    core = Core.new
    core.start_game game.id
    core.broadcast_all_data game.id, player.id
  end

  def shuffle
    game = Player[current_player.id].game
    core = Core.new
    core.shuffle_map game.id
    core.broadcast_planets game.id
  end

  def end_turn data
    player = current_player 
    game = Player[player.id].game
    core = Core.new
    core.end_turn current_player, data["fleets"]
    core.broadcast_player player.id
    core.broadcast_players game.id
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
