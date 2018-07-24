module FleetModule

  def execute_fleets
    "       fleet: execute_fleets".bg(:magenta).color(:black).out
    Game[@game_id].players.each do |player|
      player.fleets.each do |fleet|
        self.fleet_start fleet
      end
    end
    Game[@game_id].players.each do |player|
      player.fleets.each do |fleet|
        self.fleet_move fleet
        self.fleet_reach fleet
      end
    end
  end

  def fleet_start fleet
    p "fleet start #{fleet}"
    unless fleet.started?
      planet_from = Planet[fleet.planet_from_id]
      planet_from.fleet_took_off fleet
      fleet.start
    end
  end

  def fleet_move fleet
    if fleet.steps_left > 0
      fleet.move
    end
  end

  def fleet_reach fleet
    if fleet.steps_left == 0
      planet = Planet[fleet.planet_to_id]
      if fleet.player == planet.player
        planet.took_fleet fleet
      else
        planet.defend_against_fleet fleet
      end
    end
  end

end