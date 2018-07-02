require "rails_helper"

RSpec.describe Player, type: :model do
  it "saves with valid props" do
    player = Player.new
    player.is_admin = true
    player.name = "1"
    player.color_id = Player::DEFAULT_COLOR
    player.is_ai = false
    expect(player).to be_valid
  end
  it "valid func 'has_fleets_or_planets' having planets" do
    player = Player.new
    player.is_admin = true
    player.name = "1"
    player.color_id = Player::DEFAULT_COLOR
    player.is_ai = false
    player.save
    planet = Planet.new.set_properties
    planet.save
    player.planets << planet
    expect(player.has_fleets_or_planets).to be true
  end
  it "valid func 'has_fleets_or_planets' having fleets" do
    player = Player.new
    player.is_admin = true
    player.name = "1"
    player.color_id = Player::DEFAULT_COLOR
    player.is_ai = false
    player.save
    fleet = Fleet.new
    player.fleets << fleet
    expect(player.has_fleets_or_planets).to be true
  end
end