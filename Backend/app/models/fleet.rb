class FleetValidator < ActiveModel::Validator
  
  def validate record
    self.piece_of_validations record, lambda { |r|
      r.planet_from_id != r.planet_to_id
    }, "planet_from can't be the same with planet_to", record.planet_from_id, record.planet_to_id
    self.piece_of_validations record, lambda { |r| 
      !Planet[r.planet_from_id].nil?
    }, "there is no Planet with planet_from_id", record.planet_from_id
    self.piece_of_validations record, lambda { |r| 
      !Planet[r.planet_to_id].nil?
    }, "there is no Planet with planet_to_id", record.planet_to_id
  end

  def piece_of_validations record, func, error_msg, *args
    if args.any? { |arg| arg.nil? }
      return
    else
      res = func.call record
      unless res
        record.errors[:base] << error_msg
      end
    end
  end

end

class Fleet < Ohm::Model
  
  include ActiveModel::Validations

  DEFAULT_STATUS = "deffensive"

  reference :player, :Player

  attribute :kill_perc, lambda { |x| x.to_f }
  #attribute :status
  attribute :ships, lambda { |x| x.to_i }
  attribute :steps_left, lambda { |x| x.to_i }
  attribute :planet_from_id, lambda { |x| x.to_i }
  attribute :planet_to_id, lambda { |x| x.to_i }
  attribute :started #for other players not to see changing in planets

  validates_with FleetValidator
  validates :kill_perc, presence: true, numericality: { less_than: 1, greater_than: 0 }
  #validates :status, presence: true, inclusion: { in: %w(aggressive deffensive avoiding)}
  validates :steps_left, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :ships, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :planet_from_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :planet_to_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :started, inclusion: { in: [true, false,"true", "false"] }, allow_nil: true

  def id
    super.to_i
  end

  def player_id
    self.attributes[:player_id].to_i
  end

  def move steps = 1
    self.steps_left -= steps
    self.save
  end

  def started?
    self.started == true
  end

  def start
    self.started = true
    self.save
  end

  def kill_perc
    self.attributes[:kill_perc].to_f
  end

  def ships
    self.attributes[:ships].to_i
  end

  def update hash
    obj = Fleet.new hash
    if obj.valid?
      super hash
      true
    else
      false
    end
  end

  def self.create hash
    obj = Fleet.new hash
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

#-------------------------- for future ---------------------
=begin
  def make_aggressive
    self.status = "aggressive"
  end 
  def make_deffensive
    self.status = "deffensive"
  end
  def make_avoiding
    self.status = "avoiding"
  end
=end
end