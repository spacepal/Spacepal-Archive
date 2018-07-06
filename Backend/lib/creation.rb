class Creation

  def self.create_game(player, gamename, map, 
        players_limit, planets_count, pin_code, 
        flags) 
    res = {}
    g = Game.new
    g.name = gamename
    g.step = Game::IS_ROOM
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
      player.save
      return g
    else 
      return g
    end
  end

  def self.create_player name, is_ai: false, ai_type: nil 
    player = Player.new
    player.name = name
    player.is_admin = false
    player.color_id = Player::DEFAULT_COLOR
    player.is_ai = is_ai
    player.ai_type = ai_type
    player.save
    player
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
    cells.each { |cell| cell.game = game; cell.save }
    game.cells.first.set_all_neighbors
    if game.cells.count != game.width * game.height
      return false
    else
      cells
    end
  end

  def self.create_planets game
    cells_ids = game.cells.ids.map { |id| id.to_i }
    players_ids = game.players.ids.map { |id| id.to_i }
    cells_ids = cells_ids.shuffle.take game.planets_count
    cells_ids.each_with_index do |id, index|
      ("planet: \n index - " + index.to_s).color(:orange).out
      if index < game.players_limit
        planet = Planet.new
        planet.make_players_planet
        planet.cell = game.cells[id]
      else
        planet = Planet.new
        planet.set_properties        
        planet.cell = game.cells[id]
      end
      planet.save
      game.cells[id].planet = planet
      planet.game = game
      planet.save
    end
    game.cells.each { |cell| (cell.coord_x.to_s + ":" + cell.coord_y.to_s).color(:yellow).out }
    ("planets: " + game.planets.count.to_s).color(:orange).out
    ("players: " + game.players.count.to_s).color(:orange).out
    game.planets.each { |planet| (planet.cell.coord_x.to_s + ":" + planet.cell.coord_y.to_s).color(:yellow).out }
    game.planets.to_a
  end

  def self.create_fleet

  end

end