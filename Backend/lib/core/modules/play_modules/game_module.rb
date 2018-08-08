module GameModule

  def execute_game
    "       game: execute_game".bg(:magenta).color(:black).out
    game = Game[@game_id]
    if game.not_loosing_players_count < 2 or game.not_loose_not_bot_players_count == 0
      game.over
    else
      game.continue
    end
  end

end