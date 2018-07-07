require 'ohm'
require '/home/nickml/development/Spacepal/Backend/lib/common.rb'
require 'active_record'

class Event < Ohm::Model

  include ActiveModel::Validations

  validates :name, length: { in: 0..20 }, allow_nil: true

  attribute :name, lambda { |x| x.to_i } 
  collection :participants, :Person
  set :events, :Event

  

  index :name

  def name
    self.attributes[:name]
  end

  def update hash
    obj = Event.new hash
    if obj.valid?
      super hash
      true
    else
      false
    end
  end

  def self.create hash
    obj = Event.new hash
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

class Person < Ohm::Model
  include ActiveModel::Validations

  attribute :name
  reference :event, :Event

  def update hash
    obj = Person.new hash
    if obj.valid?
      super hash
      true
    else
      false
    end
  end

  def self.create hash
    obj = Person.new hash
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
