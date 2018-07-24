module GameModule

  def execute_game
    "       game: execute_game".bg(:magenta).color(:black).out
    game = Game[@game_id]
    if game.not_loosing_players_count < 2
      game.over
    else
      "game: before continue (step: #{game.step})".color(:yellow).out
      game.continue
      "game: after continue (step: #{game.step})".color(:yellow).out
    end
  end

end