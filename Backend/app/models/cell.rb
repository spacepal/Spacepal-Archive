class Cell < Ohm::Model

  include ActiveModel::Validations

  collection :fleets, :Fleet

  reference :planet, :Planet
  reference :game, :Game
  
  attribute :coord_x, lambda { |x| x.to_i }
  attribute :coord_y, lambda { |x| x.to_i }
  set :neighbors, :Cell

  validates :coord_x, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 64, greater_than_or_equal_to: 1}
  validates :coord_y, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 64, greater_than_or_equal_to: 1}

  def coord_x
    self.attributes[:coord_x].to_i
  end

  def coord_y
    self.attributes[:coord_y].to_i
  end

  def update hash
    obj = Cell.new hash
    if obj.valid?
      super hash
      true
    else
      false
    end
  end

  def self.create hash
    obj = Cell.new hash
    if obj.valid?
      super hash
      true
    else
      false
    end
  end

  def save
    if self.valid?
      super
      true
    else
      false
    end
  end

  def set_all_neighbors
    game = Game[self.game_id]
    game.cells.ids.each do |n|
      self.set_neighbors game, n.to_i, game.width, game.height,  game.cells.ids.first.to_i
    end
  end

  def set_neighbors game, n, w, h, first_id
    key_cell = Nest.new("cell")
    cell = game.cells[n]
    Ohm.redis.call "DEL", key_cell[cell.id]["neighbors"]
    w = game.width
    arr_neigh = []
    arr_neigh << is_valid(n, (n + w), first_id, game.cells.to_a.reverse.first.id.to_i, w)
    arr_neigh << is_valid(n, (n - w), first_id, game.cells.to_a.reverse.first.id.to_i, w)
    arr_neigh << is_valid(n, (n + 1), first_id, game.cells.to_a.reverse.first.id.to_i, w)
    arr_neigh << is_valid(n, (n - 1), first_id, game.cells.to_a.reverse.first.id.to_i, w)
    odd_even_index = ((n - first_id) % w % 2) == 0 ? -1 : 1
    arr_neigh << is_valid(n, (n + w * odd_even_index + 1), first_id, game.cells.first.id.to_i, w)
    arr_neigh << is_valid(n, (n + w * odd_even_index - 1), first_id, game.cells.first.id.to_i, w)
    arr_neigh.compact!
    arr_neigh.uniq!
    arr_neigh.sort! { |el| el.id }
    arr_neigh.each { |el| cell.neighbors << el; cell.save }
    cell.save
    #(n - first_id + 1).to_s.color("green").out
    #(cell.neighbors.map { |m| m - first_id + 1 }).to_s.color("cyan").out      
  end

  def is_valid this, next_, first_id, last_id, w
    calc_offset = lambda { |index| (index - first_id) % w }
    current_offset = calc_offset.call(this)
    next_offset = calc_offset.call(next_)
    #("this = " + (this - first_id + 1).to_s + " next_ = " + (next_ - first_id + 1).to_s + " current_offset = " + current_offset.to_s + " next_offset = " + next_offset.to_s).color("orange").out
    if next_.between?(first_id, last_id) and 
      (current_offset - next_offset).abs < 2
      Cell[next_]  
    else
      nil
    end
  end


end