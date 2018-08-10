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
    p "fleet reach"
    if fleet.steps_left == 0
      planet = Planet[fleet.planet_to_id]
      planet_player_id = planet.player_id.clone
      fleet_player_id = fleet.player_id.clone
      fleet_ = fleet.clone
      if fleet.player == planet.player
        planet.took_fleet fleet
        unless Player[fleet_player_id]&.ai?
          self.add_notification type: 3, player_id1: fleet_player_id, fleet_data: make_hash_land(fleet_)
        end
      else
        result = planet.defend_against_fleet fleet
        case result
        when "planet"
          unless Player[fleet_player_id]&.ai? or Player[planet_player_id]&.ai?
            self.add_notification type: 5, player_id1: fleet_player_id, _object_id: planet.id, player_id2: planet_player_id 
          end
        when "fleet"
          unless Player[fleet_player_id]&.ai? or Player[planet_player_id]&.ai?
            self.add_notification type: 4, player_id1: fleet_player_id, _object_id: planet.id, player_id2: planet_player_id 
          end
        end
      end
    end
  end

  def make_hash_land fleet
    {
      "from" => fleet.planet_from_id,
      "to" => fleet.planet_to_id,
      "count" => fleet.ships,
      "stepsLeft" => fleet.steps_left
    }
  end

end