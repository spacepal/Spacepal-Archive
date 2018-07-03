class Creation
  
  def self.create_game username, gamename, map, players_limit, players_count, pin_code, flags 
    g = Game.new
    g.name = gamename
    g.width = map[:width]
    g.heihgt = map[:height]
    g.players_limit = players_limit
    g.players_count = players_count
    g.pin_code = flag[:has_pin_code] ? pin_code : nil
    g.buffs = flag[:buffs]
    g.production_after_capture = flag[:production_after_capture]
    g.pirates = flag[:pirates]
    g.accumulative = flag[:accumulative]
    if !g.valid?
      return { game: g.errors.messages }
    end
    g.save
    cells = Array.new
    g.height.times do |h|
      g.width.times do |w|
        cell = Cells.new
        cell.coord_x = w + 1
        cell.coord_y = h + 1
        cell.save
        cells << cell.clone
      end
    end
    g.cells << cells
    if g.cells.count != g.width * g.height
      p "WRONG NUMBER OF CELL"
    end
    
  end

end