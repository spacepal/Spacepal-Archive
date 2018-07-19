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
    player.is_end_turn = false
    player.is_game_over = false
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
        cell.x = w + 1
        cell.y = h + 1
        cell.save
        cells << cell.clone
      end
    end
    cells.each { |cell| cell.game = game; cell.save }
    if game.cells.count == game.width * game.height
      cells
    else
      return false
    end
  end

  def self.create_planets game
    cells_ids = game.cells.ids.map { |id| id.to_i }
    players_ids = game.players.ids.map { |id| id.to_i }
    cells_ids = cells_ids.shuffle.take game.planets_count
    cells_ids.each_with_index do |id, index|
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
    game.planets.to_a
  end

  def self.create_fleets player, array_fleets_hash
    array_fleets_hash.each do |fleet_hash|
      Creation.create_fleet player,fleet_hash
    end
  end
  def self.create_fleet player, fleet_hash
    if Planet[fleet_hash["from"]].ships >= fleet_hash["count"]
      fleet = Fleet.new
      fleet.started = false
      fleet.planet_from_id = fleet_hash["from"]
      fleet.planet_to_id = fleet_hash["to"]
      fleet.ships = fleet_hash["count"]
      planet_from = Planet[fleet.planet_from_id]
      fleet.kill_perc = planet_from ?
        planet_from.kill_perc :
        nil
      fleet.steps_left = self.new.calculate_steps_left(
          fleet.planet_from_id, fleet.planet_to_id)
      fleet.player = player ? player : Player[fleet_hash["player"]]
      if fleet.save
        "created_fleet:#{fleet.id} (#{fleet.player.name}) from:(#{Planet[fleet.planet_from_id].cell.x};#{Planet[fleet.planet_from_id].cell.y}) to:(#{Planet[fleet.planet_to_id].cell.x};#{Planet[fleet.planet_to_id].cell.y}) steps: #{fleet.steps_left}, kill_perc:#{fleet.kill_perc}, ships:#{fleet.ships}".color(:yellow).out
        fleet = nil
        return true
      else
        false
      end
    else
      false
    end
  end

  def calculate_steps_left planet_from_id, planet_to_id
    c1 = Planet[planet_from_id].cell
    c2 = Planet[planet_to_id].cell
    distance(to_cube(c1.x, c1.y), to_cube(c2.x, c2.y))
  end

private

  Cube = Struct.new(:x, :y, :z)

  def to_cube col, row
    x = col
    z = row - (col + col % 2) / 2
    y = -x - z
    return Cube.new(x, y, z)
  end

  def distance c1, c2
    ((c2.x - c1.x).abs + (c2.y - c1.y).abs + (c2.z - c1.z).abs) / 2
  end

end