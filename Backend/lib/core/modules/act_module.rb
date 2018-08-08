module Actable

  def start_playing
    "   act: start_playing".bg(:yellow).color(:black)
    game = Game[@game_id]
    game.get_planets_to_players
    game.set_players_colors
    game.make_planets_not_capitals
    game.start_game
  end

  def shuffle_map
    game = Game[@game_id]
    game.shuffle_map
  end

  def player_ends_turn array_fleets_hash = []
    "   act: player_ends_turn".bg(:yellow).color(:black)
    save_fleets(array_fleets_hash) unless array_fleets_hash.empty? 
    set_player_ends_turn
  end

  def everybody_ends_turn?
    "   act: everybody_ends_turn?".bg(:yellow).color(:black)
    Game[@game_id].everybody_ends_turn?
  end

  def act_on_leaving
    game = Game[@game_id]
    self.execute_game
    if game.not_loose_not_bot_players_count == 0 or game.not_loosing_players_count < 2
      game.over
    end
  end

private

  def save_fleets array_fleets_hash
    Creation.create_fleets @player_id, array_fleets_hash
  end

  def set_player_ends_turn
    Player[@player_id].end_turn
  end

end