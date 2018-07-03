class Creation
  
  def self.create_game(player, gamename, map, 
        players_limit, planets_count, pin_code, 
        flags) 
    res = {}
    g = Game.new
    g.name = gamename
    g.width = map[:width]
    g.height = map[:height]
    g.players_limit = players_limit
    g.planets_count = planets_count
    g.pin_code = flags[:has_pin_code] ? pin_code : nil
    g.buffs = flags[:buffs]
    g.production_after_capture = flags[:production_after_capture]
    g.pirates = flags[:pirates]
    g.accumulative = flags[:accumulative]
    if g.save
      player.game = g
      player.is_admin = true
      return g
    else 
      return nil
    end
  end

  def self.create_cells game
    cells = Array.new
    game.height.times do |h|
      game.width.times do |w|
        cell = Cell.new
        cell.coord_x = w + 1
        cell.coord_y = h + 1
        cell.save
        cells << cell.clone
      end
    end
    game.cells << cells
    game.save
    game.cells.first.set_all_neighbors
    if game.cells.count != game.width * game.height
      return false
    else
      cells
    end
  end

  def self.create_player name, is_ai: false, ai_type: nil 
    player = Player.new
    player.name = name
    player.is_admin = false
    player.color_id = Player::DEFAULT_COLOR
    player.is_ai = is_ai
    player.ai_type = ai_type
    if player.save
      player
    else 
      p player.errors.messages
      false
    end
  end

  def self.create_planet cell, buff: nil, player: nil
    planet = Planet.new
    if  player
      planet.make_players_planet
      planet.buff = buff
      if planet.save
        cell.planet << planet
        player.planets << planet
        planet
      end
    else
      planet.set_properties
      planet.buff = buff
      if planet.save
        cell.planet << planet
        planet
      end
    end
    false
  end

  def self.create_fleet

  end

end