class Fleet < RedisOrm::Base

  DEFAULT_STATUS = "deffensive"

  belongs_to :game
  belongs_to :player
  belongs_to :cell, :as => :current_cell
  belongs_to :cell, :as => :target_cell

  property :id, Integer
  property :kill_perc, Float
  property :status, String
  property :ships, Integer
  property :way, String

  validates :kill_perc, presence: true, numericality: { less_than: 1, greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w(aggressive deffensive avoiding)}
  validates :ships, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def make_aggressive
    self.status = "aggressive"
  end 
  def make_deffensive
    self.status = "deffensive"
  end
  def make_avoiding
    self.status = "avoiding"
  end

end