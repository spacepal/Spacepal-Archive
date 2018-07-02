require "rails_helper"

RSpec.describe Game, type: :model do
  it "cells enaugh for planets" do
    game = Game.new 
    game.width = 3
    game.height = 3
    game.planets_count = game.width * game.height + 1 
    game.valid?
    expect(game.errors[:base].include? "not enaugh cells for planets").to be true
  end
  it "cells enaugh for players" do
    game = Game.new 
    game.width = 3
    game.height = 3
    game.players_limit = game.width * game.height + 1 
    game.valid?
    expect(game.errors[:base].include? "not enaugh cells for players").to be true
  end
  it "planets enaugh for players" do
    game = Game.new 
    game.planets_count = 10
    game.players_limit = game.planets_count + 1 
    game.valid?
    expect(game.errors[:base].include? "not enaugh planets for players").to be true
  end
  it "is valid with valid attributes" do
    game = Game.new
    game.name = "game"
    game.width = 10
    game.height = 10
    game.planets_count = 50
    game.players_limit = 8
    game.accumulative = true
    game.buffs = true
    game.pirates = true
    game.production_after_capture = true
    expect(game).to be_valid
  end
  it "adding planet to model" do
    planet = Planet.new
    game = Game.new
    game.name = "game"
    game.width = 10
    game.height = 10
    game.planets_count = 50
    game.players_limit = 8
    game.accumulative = true
    game.buffs = true
    game.pirates = true
    game.production_after_capture = true
    game.save
    game.planets << planet
    game.save
    expect(game.planets.count).to eq 1
  end
end