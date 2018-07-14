class Planet < Ohm::Model
  
  include ActiveModel::Validations

  DEFAULT_PRODUCTION = 10
  NEUTRAL_PLAYER = -1

  reference :game, :Game
  reference :player, :Player
  reference :cell, :Cell

  attribute :buff
  attribute :kill_perc , lambda { |x| x.to_f }
  attribute :production, lambda { |x| x.to_i }
  attribute :ships, lambda { |x| x.to_i }
  attribute :is_capital, lambda { |x| x.to_bool }

  validates :is_capital, inclusion: { in: [true, false] }
  validates :buff, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :kill_perc, presence: true, numericality: { less_than: 1, greater_than: 0 }
  validates :production, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :ships, presence: true, numericality: { only_integer: true }

  def set_properties
    self.set_production
    self.set_kill_percent
    self.set_ships
    self.get_properties
    self.player_id = NEUTRAL_PLAYER
    self.is_capital = false
    self
  end

  def set_production prod = 0
    if prod > 3 and prod < 16
      self.production = prod
    else
      norm = Rubystats::NormalDistribution.new(9, 1.3)
      n = norm.rng
      n = n <= 9 ? n * 0.88 : n * 1.1
      self.production = n
    end
  end

  def set_kill_percent perc = 0
    if perc > 0.3 and perc < 0.9
      self.kill_perc = perc
    else
      norm = Rubystats::NormalDistribution.new(0.14, 0.02)
      n = norm.rng * 4
      n = n <= 0.55 ? n * 0.85 : n * 1.1
      self.kill_perc = n.round(2)
    end
  end

  def set_ships ships = nil
    if ships and ships >= 0
      self.ships = ships
    else 
      self.ships = 10
    end
  end

  def make_players_planet 
    self.set_production 10
    self.set_kill_percent 0.4
    self.set_ships
    self.is_capital = true
  end

  def get_properties
    props = {}
    props[:id] = self.id
    props[:kill_perc] = self.kill_perc
    props[:production] = self.production
    props[:ships] = self.ships
    props
  end

    def update hash
    obj = Planet.new hash
    if obj.valid?
      super hash
      true
    else
      false
    end
  end

  def self.create hash
    obj = Planet.new hash
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

end