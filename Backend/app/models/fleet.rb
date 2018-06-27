class Fleet < RedisOrm::Base

  belongs_to :game
  belongs_to :player
  belongs_to :cell, :as => :current_cell
  belongs_to :cell, :as => :target_cell

  property :id, Integer
  property :kill_perc, Float
  property :status, Integer
  property :ships, Integer

end