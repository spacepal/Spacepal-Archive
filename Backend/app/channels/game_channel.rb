class GameChannel < ApplicationCable::Channel

  def subscribed
    game_id = Player[current_player_id].game_id
    core = Core.new game_id, current_player_id
    stream_from ("games:" + game_id.to_s)
    transmit core.transmitted_player
    core.broadcast_on_subscribe
    # stream_from "some_channel"
  end

  #cheats

  def start_game
    core = Core.new Player[current_player_id].game_id, current_player_id
    core.start_game
  end

  def shuffle
    core = Core.new Player[current_player_id].game_id, current_player_id
    core.shuffle
  end

  def end_turn data
    core = Core.new Player[current_player_id].game_id, current_player_id
    core.end_turn data["fleets"]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
