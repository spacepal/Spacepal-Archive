module BroadcastModule

  END_TURN_TYPE = :turn_ended
  GAME_TYPE = :game
  PLAYER_TYPE = :profile
  PLAYERS_TYPE = :players
  FLEETS_TYPE = :fleets
  PLANETS_TYPE = :planets
  NOTIFICATION_TYPE = :notifications

  def transmit_all_data room, player_id
    ActionCable.server.broadcast(room, self.transmitted_game(player_id))
    ActionCable.server.broadcast(room, self.transmitted_player(player_id))
    ActionCable.server.broadcast(room, self.transmitted_players(player_id))
    ActionCable.server.broadcast(room, self.transmitted_fleets(player_id))
    ActionCable.server.broadcast(room, self.transmitted_planets(player_id))
  end

  def transmit_profile room, player_id
    ActionCable.server.broadcast(room, self.transmitted_player(player_id))

  end

  def transmitted_game player_id
    game = Player[player_id].game
    _hash = {
      id: game.id.to_i,
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

  def transmitted_player player_id
    player = Player[player_id]
    player.is_end_turn
    _hash = {
      id: player_id.to_i,
      username: player.name,
      isCreator: (player.is_admin or false),
      isEndTurn: (player.is_end_turn or false),
      isGameOver: (player.is_game_over or false)
    }
    return { type: PLAYER_TYPE, data: _hash }
  end

  def transmitted_players player_id
    players = Player[player_id].game.players
    arr = players&.map do |player| 
      {
        id: player.id.to_i,
        color: player.color_id,
        username: player.name,
        isArtificialIntelligence: (player.is_ai or false),
        artificialIntelligenceType:  player.ai_type,
        isEndTurn: (player.is_end_turn or false),
        isGameOver: (player.is_game_over or false)
      }
    end
    return { type: PLAYERS_TYPE, data: { PLAYERS_TYPE => arr }}
  end

  def transmitted_fleets player_id
    fleets = Player[player_id].fleets
    arr = fleets&.map do |fleet|
      {
        from: Cell[fleet.cell_from_id].planet.id.to_i, # planetID
        to: fleet.way[-1].planet.id.to_i, # planetID
        count: fleet.ships,
        stepsLeft: fleet.way.count
      }
    end
    return { type: FLEETS_TYPE, data: { FLEETS_TYPE => arr }} 
  end

  def transmitted_planets player_id
    planets = Player[player_id].game.planets
    arr = planets&.map do |planet|
      {
        id: planet.id.to_i,
        ownerID: (planet.player_id or -1), # player ID
        cellID: planet.cell.relative_id, # 1 ... width * height
        production: planet.production,
        killPerc: planet.kill_perc,
        ships: planet.ships,
        isCapital: (planet.is_capital or false)
      }
    end
    return { type: PLANETS_TYPE, data: { PLANETS_TYPE => arr }} 
  end

end