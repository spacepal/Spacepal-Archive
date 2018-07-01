class GameValidator < ActiveModel::Validator
  
  def validate record
    self.piece_of_validations record, lambda { |r|
      r.planets_count <= ( r.width * r.height)
    }, "not enaugh cells for planets", record.planets_count, record.width, record.height
    self.piece_of_validations record, lambda { |r|
      r.players_limit <= ( r.width * r.height)
    }, "not enaugh cells for players", record.players_limit, record.width, record.height
    self.piece_of_validations record, lambda { |r|
      r.players_limit <= ( r.planets_count)
    }, "not enaugh planets for players", record.players_limit, record.planets_count
  end

  def piece_of_validations record, func, error_msg, *args
    if args.any? { |arg| arg.nil? }
      return
    else
      res = func.call record
      if !res
        record.errors[:base] << error_msg
      end
    end
  end

end

class Game < RedisOrm::Base

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
  property :accumulative, RedisOrm::Boolean 
  property :buffs, RedisOrm::Boolean 
  property :pirates, RedisOrm::Boolean 
  property :production_after_capture, RedisOrm::Boolean 

  validates_with GameValidator
  validates :name, presence: true, length: { :in => 1..32 }
  validates :pin_code, format: { with: /(|\d{4})/, message: "only digits allows" }, allow_nil: true
  validates :width, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 64, greater_than_or_equal_to: 2 }
  validates :height, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 64, greater_than_or_equal_to: 2}
  validates :planets_count, presence: true, numericality: { only_integer: true }
  validates :players_limit, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 8, greater_than_or_equal_to: 2  }
  validates :accumulative, inclusion: { in: [true, false] }
  validates :buffs, inclusion: { in: [true, false] }
  validates :pirates, inclusion: { in: [true, false] }
  validates :production_after_capture, inclusion: { in: [true, false] }
  validates_associated :fleets
  validates_associated :planets
  validates_associated :players


  def self.get_all offset_limit #get hash of selected games
    arr = Game.all offset_limit
    arr_hash = []
    el_hash = {}
    arr.each do |game|
      el_hash[:id] = game.id
      el_hash[:creator] = game.get_creator_name
      el_hash[:name] = game.name
      el_hash[:has_pin_code] = game.pin_code != ""
      el_hash[:width] = game.width
      el_hash[:height] = game.height
      el_hash[:planets_count] = game.planets_count
      el_hash[:players_limit] = game.players_limit
      el_hash[:players_count] = game.players.count
      el_hash[:accumulative] = game.accumulative
      el_hash[:buffs] = game.buffs
      el_hash[:pirates] = game.pirates
      el_hash[:production_after_capture] = game.production_after_capture
      arr_hash.push el_hash.clone
    end
    arr_hash
  end

  def enter_player player
    if self.players.count < self.players_limit
      pl = Players.create player
      if pl.id
        self.players << pl
      end
    else
      errors.add :players_limit, "no place for new player"
    end
  end

  def get_creator_name
    "Smile for you"
  end
  
end