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

  def end_turn player, array_fleets_hash
    self.save_fleets(player, array_fleets_hash) unless array_fleets_hash.empty? 
  end

  def save_fleets player, array_fleets_hash
    Creation.create_fleets player, array_fleets_hash
  end

end