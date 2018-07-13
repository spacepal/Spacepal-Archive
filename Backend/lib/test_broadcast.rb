class TB

  def initialize game_id
    ActionCable.server.broadcast(
  "games:#{game_id}",
  body: 'This is a cool chat app.'
)
  end

end