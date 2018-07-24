module PlayerModule

  def execute_players
    p "execute_players".bg(:yellow).color(:black).out
    Game[@game_id].not_loosing_players.each do |player|
      p "ep1"
      if player.planets.count > 0
        p "ep2"
        player.continue
        p "ep3"
      else
        p "ep4"
        unless player.fleets.count > 0
          p "ep5"
          player.end_game
          p "ep6"
        end
        p "ep7"
      end
      p "ep8"
    end
    p "ep9"
  end

end