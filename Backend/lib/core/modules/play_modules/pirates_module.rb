module PirateModule

# 1 - 100
  @@PIRATES_ATTACK_PLANET_POSIBILITY = 10
  @@PIRATES_ATTACK_PLANET_MAX_DAMAGE = 40
  @@PIRATES_ATTACK_FLEET_POSIBILITY = 30
  @@PIRATES_ATTACK_FLEET_MAX_DAMAGE = 5

  def execute_pirates
    game = Game[@game_id]
    if game.pirates
      game.players.each do |player|
        player.planets.each do |planet| 
          if pirates_attack_planet?
            planet.ships = (planet.ships * (1 - pirates_attack_planet_damage)).to_i
            planet.save
          end
        end
        player.fleets.each do |fleet|
          if pirates_attack_fleet?
            fleet.ships = (fleet.ships * (1 - pirates_attack_fleet_damage)).to_i
            fleet.save
          end
        end
      end
    end
  end

  def pirates_attack_planet?
    if Random.rand(1..100) <= @@PIRATES_ATTACK_PLANET_POSIBILITY
      true
    else
      false
    end
  end  

  def pirates_attack_fleet?
    if Random.rand(1..100) <= @@PIRATES_ATTACK_FLEET_POSIBILITY
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