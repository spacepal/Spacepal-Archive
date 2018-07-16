module Actable

  def start_game game_id
    game = Game[game_id]
    game.get_planets_to_players
    game.set_players_colors
    game.make_planets_not_capitals
    game.start_game
  end

  def shuffle_map game_id 
    game = Game[game_id]
    game.shuffle_map
  end

end