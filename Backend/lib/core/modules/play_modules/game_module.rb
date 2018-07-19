module GameModule

  def execute_game
    game = Game[@game_id]
    if game.not_loosing_players_count < 2
      game.over
    else
      game.continue
    end
  end

end