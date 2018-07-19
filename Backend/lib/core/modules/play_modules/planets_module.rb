module PlanetModule

  def execute_planets
    game = Game[@game_id] 
    if game.accumulative
      game.planets.each do |planet|
        product_ships planet, game.production_after_capture
        planet.gain_experience
      end
    else
      game.planets.each do |planet|
        product_ships planet, game.production_after_capture
      end
    end
  end

  def product_ships planet, production_after_capture = false
    unless !production_after_capture and planet.experience == -1
      planet.product_ships
    end
  end

  def gain_players_planet_exp
    game = Game[@game_id] 
    game.planets.each do |planet|
      if plane.player
        planet.gain_experience
      end
    end
  end 

end