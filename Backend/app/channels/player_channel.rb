class PlayerChannel < ApplicationCable::Channel
 
  def subscribed
    player = Player[current_player.id]
    game_id = player.game.id
    stream_from ("players:" + player.id.to_s)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
