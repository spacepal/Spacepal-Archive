class GameChannel < ApplicationCable::Channel

  def subscribed
    game = Player[current_player_id].game
    core = Core.new game.id, current_player_id
    stream_from ("games:" + game.id.to_s)
    transmit core.transmitted_player
    core.broadcast_all_data
    # stream_from "some_channel"
  end

  #cheats

  def start_game
    game = Player[current_player_id].game
    core = Core.new game.id, current_player_id
    core.start_game
  end

  def shuffle
    game = Player[current_player_id].game
    core = Core.new game.id, current_player_id
    core.shuffle
  end

  def end_turn data
    game = Player[current_player_id].game
    core = Core.new game.id, current_player_id
    core.end_turn data["fleets"]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
