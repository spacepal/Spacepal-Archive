class PlayerChannel < ApplicationCable::Channel
  def subscribed
    player = Player[current_player.id]
    core = Core.new
    stream_from ("players:" + player.id.to_s)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
