class Deletion

  def self.delete_game game
    planets = game.planets.all
    cells = game.cells.all
    players = game.players.all
    if cells
      cells.each do |cell| 
        cell.planet = nil
        cell.destroy
      end 
    end
    players.each do |player| 
      player.game = nil
      player.planets = []
      player.destroy
    end
    if planets
      planets.each do |planet| 
        planet.cell = nil
        planet.player = nil
        planet.game = nil
        planet.destroy
      end
    end
    game.planets = []
    game.players = []
    game.cells = []
    game.destroy
  end

  def self.de obj #destroy if exist
    if obj
      obj.destroy
    else
      nil
    end
  end

  def self.cm obj, meth #call method if obj exist 
    if obj
      obj.send meth.to_sym
    else
      nil
    end
  end

end