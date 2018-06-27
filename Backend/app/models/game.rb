class Game < RedisOrm::Base

  WIDTH = 15
  HEIGHT = 20
  PLANETS_COUNT = 85
  ACCUMULATIVE = true
  BUFFS = true
  PIRATES = true
  PRODUCTION_AFTER_CAPTURE = false

  has_many :fleets
  has_many :planets
  has_many :players

  property :id, Integer
  property :name, String 
  property :pin_code, String
  property :width, Integer 
  property :height, Integer 
  property :planets_count, Integer
  property :accumulative, RedisOrm::Boolean 
  property :buffs, RedisOrm::Boolean 
  property :pirates, RedisOrm::Boolean 
  property :production_after_capture, RedisOrm::Boolean 
  
end