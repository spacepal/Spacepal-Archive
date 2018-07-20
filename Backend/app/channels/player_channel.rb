class PlayerChannel < ApplicationCable::Channel
 
  def subscribed
    stream_from ("players:#{current_player_id}")
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
