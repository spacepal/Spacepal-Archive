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

  it "validate ai_name when is_ai true" do
    player = Player.new 
    player.is_ai = true
    player.valid?
    expect(player.errors.messages[:ai_name].include? "must been defined when if is ai").to be true
  end
end