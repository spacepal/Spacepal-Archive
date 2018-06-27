class Cell < RedisOrm::Base

  has_one :planet
  has_many :fleets
  has_many :cells, :as => :neihgbors

  property :id, Integer
  property :coord_x, Integer
  property :coord_y, Integer

end