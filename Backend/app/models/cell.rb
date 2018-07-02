class Cell < RedisOrm::Base

  has_one :planet
  has_many :fleets
  has_many :cells, :as => :neihgbors

  belongs_to :game
  
  property :id, Integer
  property :coord_x, Integer
  property :coord_y, Integer

  validates :coord_x, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 64, greater_than_or_equal_to: 1}
  validates :coord_y, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 64, greater_than_or_equal_to: 1}
  validates_associated :fleets
  validates_associated :cells

end