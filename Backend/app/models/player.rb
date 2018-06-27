class Player < RedisOrm::Base

  has_many :planets
  has_many :fleets
  belongs_to :game

  property :id, Integer
  property :name, String
  property :has_ships_or_planets, RedisOrm::Boolean
  property :color_id, Integer
  property :is_ai, RedisOrm::Boolean
  property :ai_type, Integer

end