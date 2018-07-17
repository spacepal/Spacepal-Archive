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
        cell.coord_x = w + 1
        cell.coord_y = h + 1
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
    "CREATION: create fleets"
    array_fleets_hash.each do |fleet_hash|
      p 'www'
      (Creation.create_fleet(player,fleet_hash)).to_s.color(:yellow).out
    end
  end
#{"fleets"=>[{"from"=>287, "to"=>289, "count"=>3}, 
#{"from"=>287, "to"=>312, "count"=>3}], "action"=>"end_turn"}
  def self.create_fleet player, fleet_hash
    p fleet_hash
    fleet = Fleet.new
    p "1"
    fleet.planet_from_id = fleet_hash["from"]
    p "2"
    fleet.planet_to_id = fleet_hash["to"]
    p "3"
    fleet.ships = fleet_hash["count"]
    p "4"
    fleet.kill_perc = Planet[fleet.planet_to_id] ?
      Planet[fleet.planet_to_id].kill_perc :
      nil
    p "5"
    fleet.steps_left = Creation.calculate_steps_left(
        fleet.planet_from_id, fleet.planet_to_id)
    p "6"
    fleet.player = player ? player : Player[fleet_hash["player"]]
    p "7"
    if fleet.save
      p "8.1"
      fleet
    else
      p "8.2"
      nil
    end
  end

  def self.calculate_steps_left planet_from_id, planet_to_id
    #todo
    5
  end

end