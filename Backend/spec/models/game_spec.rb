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
    game.width = 15
    game.height = 10
    game.planets_count = 50
    game.players_limit = 8
    game.accumulative = true
    game.buffs = true
    game.pirates = true
    game.production_after_capture = true
    expect(game).to be_valid
  end
  it "add player when one" do
    player = Creation.create_player "Jack"
    game = Creation.create_game(
      player , "game_1", 
      { width: 5, height: 5 },
      3, 5, "1234", { has_pin_code: false,
      buffs: false, production_after_capture: false,
      pirates: false, accumulative: false })
    game.add_player "John"
    expect(game.players.count).to eq(2)
    Deletion.delete_game game
  end
  it "remove player when more than one" do
    player = Creation.create_player "Jack"
    game = Creation.create_game(
      player , "game_1", 
      { width: 5, height: 5 },
      3, 5, "1234", { has_pin_code: false,
      buffs: false, production_after_capture: false,
      pirates: false, accumulative: false })
    game.add_player "Mike"
    game.remove_player player.id
    player.delete
    player = nil
    game_id = game.id
    game = nil
    game = Game[game_id]
    expect(game.players.count).to eq(1)
    expect(game.players.first.is_admin).to be true
    Deletion.delete_game game
  end
  it "shuffles map" do
    
  end
  it "gets capitals to players" do 
    player = Creation.create_player "Jack"
    game = Creation.create_game(
      player , "game_1", 
      { width: 5, height: 5 },
      3, 5, "1234", { has_pin_code: false,
      buffs: false, production_after_capture: false,
      pirates: false, accumulative: false })
    Creation.create_cells game
    Creation.create_planets game
    game.add_player "Mike"
    game.get_planets_to_players
    expect(!game.players.first.planets.empty?).to be true
  end
end