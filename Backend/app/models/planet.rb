class Planet < Ohm::Model
  
  include ActiveModel::Validations

  DEFAULT_PRODUCTION = 10
  NEUTRAL_PLAYER = -1
  ERROR_OF_LUCK = 0.05
  PLAYERS_PRODUCTION = 10
  PLAYERS_KILL_PERC = 0.5

  reference :game, :Game
  reference :player, :Player
  reference :cell, :Cell

  attribute :buff
  attribute :kill_perc , lambda { |x| x.to_f }
  attribute :production, lambda { |x| x.to_i }
  attribute :ships, lambda { |x| x.to_i }
  attribute :is_capital, lambda { |x| x.to_bool }
  attribute :experience, lambda { |x| x.to_i }

  validates :is_capital, inclusion: { in: [true, false] }, allow_nil: true
  validates :buff, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :kill_perc, presence: true, numericality: { less_than: 1, greater_than: 0 }
  validates :production, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :experience, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: -1 }
  validates :ships, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def set_properties
    self.set_production
    self.set_kill_percent
    self.set_ships
    self.get_properties
    self.player_id = NEUTRAL_PLAYER
    self.is_capital = false
    self.experience = 0
    self
  end

  def make_players_planet 
    self.set_production Planet::PLAYERS_PRODUCTION
    self.set_kill_percent Planet::PLAYERS_KILL_PERC
    self.set_ships
    self.experience = 0
    self.is_capital = true
  end

  def make_neutral_planet
    self.player_id = nil
    self.experience = 0
    self.save
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

  def get_properties
    props = {}
    props[:id] = self.id
    props[:kill_perc] = self.kill_perc
    props[:production] = self.production
    props[:ships] = self.ships
    props
  end

  def fleet_took_off fleet
    unless self.ships < fleet.ships 
      self.ships -= fleet.ships
      self.save
    end
  end  

  def took_fleet fleet
    self.ships += fleet.ships
    self.save
    fleet.player_id = nil
    fleet.delete
    fleet = nil
  end

  def defend_against_fleet fleet
    rand = Random.new
    planet_ships = self.ships
    fleet_ships = fleet.ships
    planet_force = planet_ships * self.kill_perc *
            rand((1 - Planet::ERROR_OF_LUCK)..(1 + Planet::ERROR_OF_LUCK))
    fleet_force = fleet_ships * fleet.kill_perc *
            rand((1 - Planet::ERROR_OF_LUCK)..(1 + Planet::ERROR_OF_LUCK))
    winner_force = (planet_force - fleet_force) *
            rand((1 - Planet::ERROR_OF_LUCK)..(1 + Planet::ERROR_OF_LUCK))
    if winner_force > 0
      self.ships = (winner_force / self.kill_perc).to_i
      self.save
    elsif winner_force == 0
      self.ships = 0
      self.save
    elsif winner_force < 0
      self.change_player fleet.player
      self.ships = (winner_force / fleet.kill_perc).to_i.abs
      self.save
    end
      fleet.player = nil
      fleet.save
      fleet.delete
  end

  def change_player player
    self.player = player
    self.experience = -1
    self.save
  end

  def product_ships
    if self.player
      if self.experience == -1
        self.ships += self.production
      else
        self.ships += self.production + self.experience
      end
    else
      self.ships += 10
    end
    self.save
  end

  def gain_experience exp = 1
      self.experience += exp
      self.save
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