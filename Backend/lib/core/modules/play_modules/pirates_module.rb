module PirateModule

# 1 - 100
  @@PIRATES_ATTACK_PLANET_POSSIBILITY = 10
  @@PIRATES_ATTACK_PLANET_MAX_DAMAGE = 40
  @@PIRATES_ATTACK_FLEET_POSSIBILITY = 10
  @@PIRATES_ATTACK_FLEET_MAX_DAMAGE = 5

  def execute_pirates
    "       pirate: execute_pirates".bg(:magenta).color(:black).out
        game = Game[@game_id]
    if game.pirates
      game.players.each do |player|
        player.planets.each do |planet| 
          if pirates_attack_planet?
            planet.ships = (planet.ships * (1 - pirates_attack_planet_damage)).to_i
            planet.save
            self.add_notification type: 1, player_id1: player.id, _object_id: planet.id
          end
        end
        player.fleets.each do |fleet|
          if pirates_attack_fleet?
              fleet_count = fleet.ships.clone
              fleet.ships = (fleet.ships * (1 - pirates_attack_fleet_damage)).to_i
              fleet.save
              self.add_notification(type: 2, player_id1: player.id, fleet_data: (make_hash_pirate(fleet_count, fleet)))
          end
        end
      end
    end
  end

  def make_hash_pirate fleet_count, fleet
    {
      "from" => fleet.planet_from_id,
      "to" => fleet.planet_to_id,
      "count" => fleet_count,
      "stepsLeft" => (fleet.steps_left - 1),
      "damage" => (fleet_count - fleet.ships)
    }
  end

  def pirates_attack_planet?
    if Random.rand(1..100) <= @@PIRATES_ATTACK_PLANET_POSSIBILITY
      true
    else
      false
    end
  end  

  def pirates_attack_fleet?
    if Random.rand(1..100) <= @@PIRATES_ATTACK_FLEET_POSSIBILITY
      true
    else
      false
    end
  end

  def pirates_attack_planet_damage
    Random.rand(1..@@PIRATES_ATTACK_PLANET_MAX_DAMAGE) / 100.0
  end

  def pirates_attack_fleet_damage
    Random.rand(1..@@PIRATES_ATTACK_FLEET_MAX_DAMAGE) / 100.0
  end

end