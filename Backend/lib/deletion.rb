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
    players.each do |player| 
      Ohm.redis.call "DEL", player_key[player.id][:planets]
      Ohm.redis.call "DEL", player_key[player.id][:fleets]
      player.game_id = nil
      player.delete
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

end