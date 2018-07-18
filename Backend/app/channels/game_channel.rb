class GameChannel < ApplicationCable::Channel

  def subscribed
    game = Player[current_player_id].game
    core = Core.new
    stream_from ("games:" + game.id.to_s)
    transmit core.transmitted_player(current_player_id)
    core.broadcast_all_data game.id, current_player_id
    # stream_from "some_channel"
  end

  #cheats

  def start_game
    player = Player[current_player_id] 
    game = Player[player.id].game
    core = Core.new
    core.start_game game.id
    core.broadcast_all_data game.id, player.id
  end

  def shuffle
    game = Player[current_player_id].game
    core = Core.new
    core.shuffle_map game.id
    core.broadcast_planets game.id
  end

  def end_turn data
    player = Player[current_player_id] 
    game = Player[player.id].game
    core = Core.new
    core.end_turn player, data["fleets"]
    core.broadcast_player player.id
    core.broadcast_players game.id
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
