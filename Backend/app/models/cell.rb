class Cell < RedisOrm::Base

  has_one :planet
  has_many :fleets

  belongs_to :game
  
  property :id, Integer
  property :coord_x, Integer
  property :coord_y, Integer
  property :neighbors, Array

  validates :coord_x, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 64, greater_than_or_equal_to: 1}
  validates :coord_y, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 64, greater_than_or_equal_to: 1}
  validates_associated :fleets
  validates_associated :cells

  def set_all_neighbors
    game = self.game
    first_id = game.cells.first.id - game.cells.count + 1
    first_id.upto game.cells.first.id do |n|
      self.set_neighbors game, n, game.width, game.height,  first_id
    end
  end

  def set_neighbors game, n, w, h, first_id
    cell = game.cells.find n
    cell.neighbors = Array.new
    w = game.width
    cell.neighbors << is_valid(n, (n + w), first_id, game.cells.first.id, w)
    cell.neighbors << is_valid(n, (n - w), first_id, game.cells.first.id, w)
    cell.neighbors << is_valid(n, (n + 1), first_id, game.cells.first.id, w)
    cell.neighbors << is_valid(n, (n - 1), first_id, game.cells.first.id, w)
    odd_even_index = ((n - first_id) % w % 2) == 0 ? -1 : 1
    cell.neighbors << is_valid(n, (n + w * odd_even_index + 1), first_id, game.cells.first.id, w)
    cell.neighbors << is_valid(n, (n + w * odd_even_index - 1), first_id, game.cells.first.id, w)
    cell.neighbors.compact!
    cell.neighbors.uniq!
    cell.neighbors.sort!
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
      next_  
    else
      nil
    end
  end


end