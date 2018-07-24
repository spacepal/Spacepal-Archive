module PlanetModule

  def execute_planets
    "       planet: execute_planets".bg(:magenta).color(:black).out
    game = Game[@game_id] 
    if game.accumulative
      game.planets.each do |planet|
        product_ships planet, game.production_after_capture?
        planet.gain_experience
      end
    else
      game.planets.each do |planet|
        product_ships planet, game.production_after_capture?
        make_zero_experience planet
      end
    end
  end

  def product_ships planet, production_after_capture = false
    if !production_after_capture and planet.experience == -1
      planet.gain_experience
    else
      planet.product_ships
    end
  end

  def make_zero_experience planet
    planet.experience = 0
  end

  def gain_players_planet_exp
    game = Game[@game_id] 
    if game.accumulative
      game.planets.each do |planet|
        if planet.player
          planet.gain_experience
        end
      end
    end
  end 

end