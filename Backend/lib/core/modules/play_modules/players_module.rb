module PlayerModule

  def execute_players
    Game[@game_id].not_loosing_players.each do |player|
      if player.planets.count > 0
        player.continue
      else
        unless player.fleets > 0
          player.end_game
        end
      end
    end
  end

end