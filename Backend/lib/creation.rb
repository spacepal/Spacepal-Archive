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

  def self.create_planets game
    cells_ids = game.cells.all.ids
    players_ids = game.players.all.ids
    cells_ids = cells_ids.shuffle.take game.planets_count
    cells_ids.each_with_index do |id, index|
      if players_ids[index]
        planet = Planet.new
        planet.make_players_planet
        planet.player = game.players.find(players_ids[index]) 
        planet.cell = game.cells.find(id)
      else
        planet = Planet.new
        planet.set_properties        
      end
      planet.save
      game.cells.find(id).planet = planet
      planet.player = game.players.find(players_ids[index])
      game.planets << planet.clone
    end
    game.planets.all
  end

  def self.create_fleet

  end

end