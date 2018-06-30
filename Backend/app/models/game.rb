class Game < RedisOrm::Base

  before_save :check_players

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
  property :players_limit, Integer
  property :players_count, Integer
  property :accumulative, RedisOrm::Boolean 
  property :buffs, RedisOrm::Boolean 
  property :pirates, RedisOrm::Boolean 
  property :production_after_capture, RedisOrm::Boolean 

  def self.all offset_limit
    arr = super offset_limit
    10.times { |n| p "".rjust 75 }
    p "here".center 75
    p arr
    p "there".center 75
    10.times { |n| p "".rjust 75 }
    arr = arr.pluck :id, :name, :pin_code, :width, :height, 
      :planets_count, :players_limit, :accumulative, :buffs, 
      :pirates, :production_after_capture, "players"

  end
  
end