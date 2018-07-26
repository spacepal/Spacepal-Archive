class PlayerValidator < ActiveModel::Validator
  
  def validate record
    if record.is_ai
      unless record.ai_name
        record.errors.add :ai_name, "must been defined when if is ai"
      end
    end
  end

end

class Player < Ohm::Model

  include ActiveModel::Validations

  DEFAULT_COLOR = -10
  NEUTRAL_COLOR = 0

  collection :planets, :Planet
  collection :fleets, :Fleet
  reference :game, :Game
  
  attribute :is_admin, lambda { |x| x.to_bool }
  attribute :name
  attribute :color_id, lambda { |x| x.to_i }
  attribute :is_end_turn, lambda { |x| x.to_bool }
  attribute :is_game_over, lambda { |x| x.to_bool }
  attribute :is_ai, lambda { |x| x.to_bool }
  attribute :ai_name

  index :name

  validates_with PlayerValidator
  validates :name, presence: true, length: { in: 1..32 }
  validates :color_id, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: -10 }
  validates :is_end_turn, inclusion: { in: [true, false] }, allow_nil: true
  validates :is_game_over, inclusion: { in: [true, false] }, allow_nil: true
  validates :is_admin, inclusion: { in: [true, false] }, allow_nil: true
  validates :is_ai, inclusion: { in: [true, false] }, allow_nil: true

  def id
    super.to_i
  end

  def game_id
    self.attributes[:game_id].to_i
  end

  def ai?
    self.is_ai == true
  end

  def end_turn
    self.is_end_turn = true
    self.save
  end

  def continue
    self.is_end_turn = false
    self.save
  end

  def end_game
    self.is_game_over = true
    self.save
  end

  def end_turn? 
    self.is_end_turn
  end

  def game_over?
    self.is_game_over
  end

  def make_admin
    self.is_admin = true
    self.save
  end

  def update hash
    obj = Player.new hash
    if obj.valid?
      super hash
      true
    else
      false
    end
  end

  def self.create hash
    obj = Player.new hash
    if obj.valid?
      super hash
      true
    else
      false
    end
  end

  def save
    if self.valid?
      super
      true
    else
      false
    end
  end

  def surrender 
    planets.each do |planet|
      planet.make_neutral_planet
    end
    self.end_game
    true
  end

end