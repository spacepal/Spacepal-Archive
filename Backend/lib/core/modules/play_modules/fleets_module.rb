module FleetModule

  def execute_fleets
    "       fleet: execute_fleets".bg(:magenta).color(:black).out
    Game[@game_id].players.each do |player|
      p "ef1"
      player.fleets.each do |fleet|
        p "ef2"
        self.fleet_start fleet
        p "ef3"
      end
      p "ef4"
    end
    p "ef5"
    Game[@game_id].players.each do |player|
      p "ef6"
      player.fleets.each do |fleet|
        p "ef7"
        self.fleet_move fleet
        p "ef8"
        self.fleet_reach fleet
        p "ef9"
      end
      p "ef10"
    end
    p "ef11"
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
      p "fr1"
      planet = Planet[fleet.planet_to_id]
      p "fr2"
      p "planet: #{planet}, planet.player_id: #{planet.player_id}"
      planet_player_id = planet.player_id.clone
      fleet_player_id = fleet.player_id.clone
      "planet_player_id: #{planet_player_id}".out
      "fleet_player_id: #{fleet_player_id}".out
      p "fr3"
      if fleet.player == planet.player
        p "fr4"
        planet.took_fleet fleet
        p "fr5"
        self.add_notification type: 3, player_id1: fleet_player_id, _object_id: planet.id
        p "fr6"
      else
        p "fr7"
        result = planet.defend_against_fleet fleet
        p "result: #{result} (before nots)"
        case result
        when "planet"
          self.add_notification type: 5, player_id1: fleet_player_id, _object_id: planet.id, player_id2: planet_player_id 
        when "fleet"
          self.add_notification type: 4, player_id1: fleet_player_id, _object_id: planet.id, player_id2: planet_player_id 
        end
      end
    end
  end

end