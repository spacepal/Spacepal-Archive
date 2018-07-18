class Deletion

  def self.delete_game game
    player_key = Nest.new("player")
    game_key = Nest.new("game")
    planets = game.planets.to_a
    cells = game.cells.to_a
    players = game.players.to_a
    if cells
      cells.each do |cell| 
        cell.planet_id = nil
        cell.delete
      end 
    end
    if players
      players.each do |player|
        fleets = player.fleets
        if fleets
          fleets.each do |fleet| 
            p "1"
            fleet.player_id = nil
            p "2"
            fleet.save
            p "3"
            fleet.delete
          end
        end
        Ohm.redis.call "DEL", player_key[player.id][:planets]
        Ohm.redis.call "DEL", player_key[player.id][:fleets]
        player.game_id = nil
        player.delete
      end
    end
    if planets
      planets.each do |planet| 
        planet.cell_id = nil
        planet.player_id = nil
        planet.game_id = nil
        planet.delete
      end
    end
    Ohm.redis.call "DEL", game_key[game.id]["planets"]
    Ohm.redis.call "DEL", game_key[game.id]["players"]
    Ohm.redis.call "DEL", game_key[game.id]["cells"]
    game.delete
    true
  end

  def self.delete_planets game
    planets = game.planets.to_a
    if planets
      planets.each do |planet| 
        planet.cell_id = nil
        planet.player_id = nil
        planet.game_id = nil
        planet.delete
      end
    end
  end

  def self.delete_cells game
    cells = game.cells.to_a
    if cells
      cells.each do |cell| 
        cell.planet_id = nil
        cell.delete
      end 
    end
  end

end