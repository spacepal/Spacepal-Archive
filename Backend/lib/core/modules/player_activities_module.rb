module PlayerActivitiesModule

  def start_game game_id
    game = Game[game_id]
    game.get_planets_to_players
    game.start_game
  end

  def shuffle_map game_id 
    game = Game[game_id]
    "START SHUFFLE".ljust(50).color(:yellow).out
    game.shuffle_map
  end

end