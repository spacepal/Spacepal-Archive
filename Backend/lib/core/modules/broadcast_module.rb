module Broadcastable

  END_TURN_TYPE = :turn_ended
  GAME_TYPE = :game
  PLAYER_TYPE = :profile
  PLAYERS_TYPE = :players
  FLEETS_TYPE = :fleets
  PLANETS_TYPE = :planets
  NOTIFICATION_TYPE = :notifications

  def broadcast_on_subscribe
    self.broadcast_all_common_data
    self.broadcast_private_data
  end

  def broadcast_on_start_game
    self.broadcast_all_common_data
    self.broadcast_player_to_everybody
  end

  def broadcast_on_player_ends_turn
    self.broadcast_player
    self.broadcast_players
  end

  def broadcast_on_everybody_ends_turn
    self.broadcast_end_turn
  end

  def broadcast_the_rest_of_data
    self.broadcast_all_data_to_player
  end

  def broadcast_on_end_game
    self.broadcast_game
    self.broadcast_players
  end

  def broadcast_all_common_data 
    self.broadcast_game
    self.broadcast_players
    self.broadcast_planets
  end

  def broadcast_all_data_to_player 
    self.broadcast_game_to_player 
    self.broadcast_players_to_player 
    self.broadcast_planets_to_player 
    self.broadcast_player
    self.broadcast_fleets
  end

  def broadcast_private_data
    self.broadcast_player
    self.broadcast_fleets
  end

  def broadcast_player_to_everybody
    Game[@game_id].players.each do |player|
      self.broadcast_player player.id
    end
  end

  def broadcast_private_data_to_everybody
    Game[@game_id].players.each do |player|
      self.broadcast_player player.id
      self.broadcast_fleets player.id
    end
  end

  def broadcast_end_turn
    ActionCable.server.broadcast("games:#{@game_id}", { "type" => "turn_ended" })
  end

  def transmitted_player
    player = Player[@player_id]
    player.is_end_turn
    _hash = {
      id: @player_id.to_i,
      username: player.name,
      isCreator: (player.is_admin or false),
      isEndTurn: (player.is_end_turn or false),
      isGameOver: (player.is_game_over or false)
    }
    return { type: PLAYER_TYPE, data: _hash }
  end

  def game
    game = Game[@game_id]
    _hash = {
      id: @game_id.to_i,
      name: game.name,
      creator: game.get_creator.name,
      pinCode: game.pin_code,
      mapWidth: game.width,
      mapHeight: game.height,
      planets: game.planets_count,
      playersLimit: game.players_limit,
      buffs: (game.buffs or false),
      pirates: (game.pirates or false),
      accumulative: (game.accumulative or false),
      productionAfterCapture: (game.production_after_capture or false),
      turnNumber: game.step,
      state: game.get_state # STATE_ROOM = 1; STATE_GAME = 2; STATE_END = 3
    }
    return { type: GAME_TYPE, data: _hash }
  end

  def broadcast_game
    ActionCable.server.broadcast("games:#{@game_id}", self.game)
  end  

  def broadcast_game_to_player
    ActionCable.server.broadcast("players:#{@player_id}", self.game)
  end  

  def broadcast_player player_id = @player_id
    player = Player[player_id]
    "from broadcast_player player_name = #{player.name}"
    _hash = {
      id: player_id.to_i,
      color: player.color_id.to_i,
      username: player.name,
      isCreator: (player.is_admin or false),
      isEndTurn: (player.is_end_turn or false),
      isGameOver: (player.is_game_over or false),
      isArtificialIntelligence: (player.is_ai or false)
    }
    ActionCable.server.broadcast("players:#{player_id}", { type: PLAYER_TYPE, data: _hash })
  end

  def players
    players = Game[@game_id].players
    arr = players&.map do |player| 
      planets = player.planets.to_a
      fleets = (player.fleets.to_a.map { |fleet| fleet if fleet.started == true }).compact
      {
        id: player.id.to_i,
        color: player.color_id.to_i,
        username: player.name,
        isCreator: (player.is_admin or false),
        isArtificialIntelligence: (player.is_ai or false),
        artificialIntelligenceType:  player.ai_name,
        isEndTurn: (player.is_end_turn or false),
        isGameOver: (player.is_game_over or false),
        currentProduction: planets.to_a.pluck_arr(:production).sum +
                            planets.to_a.pluck_arr(:experience).sum,
        currentFleetSize: fleets.to_a.pluck_arr(:ships).sum + 
                            planets.to_a.pluck_arr(:ships).sum,
        currentPlanetsCount: planets.count
      }
    end
    return { type: PLAYERS_TYPE, data: { PLAYERS_TYPE => arr }}
  end

  def broadcast_players
    ActionCable.server.broadcast("games:#{@game_id}", self.players)
  end

  def broadcast_players_to_player
    ActionCable.server.broadcast("players:#{@player_id}", self.players)
  end

  def broadcast_fleets player_id = @player_id 
    player = Player[player_id]
    fleets = player.fleets
    arr = fleets&.map do |fleet|
      {
        from: fleet.planet_from_id.to_i, # planetID
        to: fleet.planet_to_id.to_i, # planetID
        count: fleet.ships.to_i,
        stepsLeft: fleet.steps_left.to_i
      }
    end
    ActionCable.server.broadcast("players:#{player_id}", { type: FLEETS_TYPE, data: { FLEETS_TYPE => arr }})
  end

  def planets
    planets = Game[@game_id].planets
    arr = planets&.map do |planet|
      {
        id: planet.id.to_i,
        ownerID: (planet.player_id or -1).to_i, # player ID
        cellID: planet.cell.relative_id.to_i, # 1 ... width * height
        production: (planet.get_whole_production).to_i,
        killPerc: planet.kill_perc.to_f,
        ships: planet.ships.to_i,
        isCapital: (planet.is_capital or false)
      }
    end
    return { type: PLANETS_TYPE, data: { PLANETS_TYPE => arr }}
  end

  def broadcast_planets
    ActionCable.server.broadcast("games:#{@game_id}", self.planets )
  end

  def broadcast_planets_to_player
    ActionCable.server.broadcast("players:#{@player_id}", self.planets )
  end

end
