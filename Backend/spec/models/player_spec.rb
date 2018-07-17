require "rails_helper"

RSpec.describe Player, type: :model do

  it "saves with valid props" do
    player = Player.new
    player.is_admin = true
    player.name = "1"
    player.is_end_turn = false
    player.is_game_over = false
    player.color_id = Player::DEFAULT_COLOR
    player.is_ai = false
    expect(player.valid?).to be true
  end
  it "valid func 'has_fleets_or_planets' having fleets" do
    player = Player.new
    player.is_admin = true
    player.name = "1"
    player.color_id = Player::DEFAULT_COLOR
    player.is_ai = false
    player.is_end_turn = false
    player.is_game_over = false
    player.save
    fleet = Fleet.new
    fleet.kill_perc = 0.4
    #fleet.status = Fleet::DEFAULT_STATUS
    fleet.ships = 10
    fleet.planet_from_id = 4
    fleet.planet_to_id = 2
    fleet.steps_left = 2
    fleet.player = player
    fleet.save
    player.save
    check = player.has_fleets_or_planets
    fleet.delete
    player.delete
    expect(check).to be true
  end
  it "validate ai_type when is_ai true" do
    player = Player.new 
    player.is_ai = true
    player.valid?
    expect(player.errors.messages[:ai_type].include? "must been defined when if is ai").to be true
  end
end