class GameChannel < ApplicationCable::Channel

  def subscribed
    game = Player[current_player.id].game
    core = Core.new
    stream_from ("games:" + game.id.to_s)
    core.transmit_all_data ("games:" + game.id.to_s), current_player.id
    # stream_from "some_channel"
  end

  #cheats

  def start_game

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
