class PlayerChannel < ApplicationCable::Channel
 
  def subscribed
    stream_from ("players:" + current_player_id.to_s)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
