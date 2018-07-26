module PlayerModule

  def execute_players
    "       player: execute_players".bg(:magenta).color(:black).out
    Game[@game_id].not_loosing_players.each do |player|
      if player.planets.count > 0
        "player #{player.id}: (#{player.name}) -> #{player.attributes}".color(:orange).out
        player.continue
        "player #{player.id}: (#{player.name}) -> #{player.attributes}".color(:yellow).out
      else
        unless player.fleets.count > 0
          player.end_game
          self.add_notification type: 6, player_id1: player.id
        end
      end
    end
  end

end