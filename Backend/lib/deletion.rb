class Deletion

  def self.delete_game game
    planets = game.planets.all
    cells = game.cells.all
    players = game.players.all
    if planets
      planets.count.to_s.color(:red).out
      planets.to_s.color(:yellow).out
      Deletion.de(Deletion.cm(planets.first, :game))
      Deletion.de(Deletion.cm planets.first, :cell)
      Deletion.de(Deletion.cm planets.first, :owner)
      Deletion.de(planets.first)
      planets.each do |planet| 
        Deletion.de(Deletion.cm planet, :cell)
        Deletion.de(Deletion.cm planet, :owner)
        Deletion.de planet 
      end
      game.planets.all.to_s.color(:green).out
    end
    if cells
      Deletion.de(Deletion.cm cells.first, :game)
      cells.each { |cell| Deletion.de cell }
    end
    if players
      Deletion.de(Deletion.cm players.first, :game)
      players.each { |player| Deletion.de player }
    end
    Deletion.de game
  end

  def self.de obj #destroy if exist
    if obj
      obj.destroy
    end
  end

  def self.cm obj, meth #call method if obj exist 
    if obj
      obj.send meth.to_sym
    end
    nil
  end

end