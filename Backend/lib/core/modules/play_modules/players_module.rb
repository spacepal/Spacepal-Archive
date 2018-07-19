module PlayerModule

  def execute_players
    Game[@game_id].not_loosing_players.each do |player|
      if player.has_fleets_or_planets
        player.continue
      else
        player.end_game
      end
    end
  end

end