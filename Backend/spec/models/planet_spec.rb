require "rails_helper"

RSpec.describe Planet, type: :model do
  it "saves with valid props" do
    planet = Planet.new
    planet.set_properties
    valid = planet.valid?
    expect(valid).to be true
  end
  it "not saves with invalid props" do
    planet = Planet.new
    planet.kill_perc = 0
    planet.production = 0
    planet.buff = 0
    valid = planet.valid?
    expect(valid).to be false
  end
  it "makes players planet" do 
    planet = Planet.new
    planet.make_players_planet
    expect(planet.production).to eq 10
    expect(planet.kill_perc).to eq 0.4
    expect(planet.ships).to eq 10
    expect(planet.is_capital).to be true
  end
end