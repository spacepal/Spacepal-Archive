class Fleet < Ohm::Model
  
  include ActiveModel::Validations

  DEFAULT_STATUS = "deffensive"

  reference :game, :Game
  reference :player, :Player


  attribute :kill_perc, lambda { |x| x.to_f }
  attribute :status
  attribute :ships, lambda { |x| x.to_i }
  attribute :step_from
  attribute :cell_from_id
  list :way, :Cell

  validates :kill_perc, presence: true, numericality: { less_than: 1, greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w(aggressive deffensive avoiding)}
  validates :ships, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :cell_from_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :step_from, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

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

  def make_aggressive
    self.status = "aggressive"
  end 
  def make_deffensive
    self.status = "deffensive"
  end
  def make_avoiding
    self.status = "avoiding"
  end

end