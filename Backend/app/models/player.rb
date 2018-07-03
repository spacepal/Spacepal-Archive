class Player < RedisOrm::Base

  DEFAULT_COLOR = -1
  NEUTRAL_COLOR = 0

  has_many :planets
  has_many :fleets
  belongs_to :game

  property :id, Integer
  property :is_admin, RedisOrm::Boolean 
  property :name, String
  property :color_id, Integer
  property :is_ai, RedisOrm::Boolean
  property :ai_type, Integer

  validates :name, presence: true, length: { in: 1..32 }
  validates :color_id, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: -1 }
  validates :is_admin, inclusion: { in: [true, false] }
  validates :is_ai, inclusion: { in: [true, false] }
  validates :ai_type, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates_associated :planets
  validates_associated :fleets

  def has_fleets_or_planets
    self.planets.count > 0 or self.fleets.count > 0
  end

end