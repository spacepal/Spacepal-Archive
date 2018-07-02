require "rails_helper"

RSpec.describe Planet, type: :model do
  it "saves with valid props" do
    planet = Planet.new
    planet.set_properties
    expect(planet).to be_valid
  end
  it "not saves with invalid props" do
    planet = Planet.new
    planet.kill_perc = 0
    planet.production = 0
    planet.buff = 0
    expect(planet).to_not be_valid
  end
end