require "rails_helper"

RSpec.describe Creation do

  it "creates player" do 
    player = Creation.create_player "Jack"
    flag = !!player
    player.destroy
    expect(flag).to be true
  end
  it "creates game" do 
    player = Creation.create_player "Jack"
    game = Creation.create_game(
      player , "game_1", 
      { width: 5, height: 5 },
      3, 5, "1234", { has_pin_code: false,
      buffs: false, production_after_capture: false,
      pirates: false, accumulative: false })
    flag = !!game
    Deletion.delete_game game
    expect(flag).to be true
  end
  it "create cells" do
    player = Creation.create_player "Jack"
    game = Creation.create_game(
      player , "game_create_cells", 
      { width: 5, height: 5 },
      3, 5, "1234", { has_pin_code: false,
      buffs: false, production_after_capture: false,
      pirates: false, accumulative: false })
    cells = Creation.create_cells game
    flag = !!cells
    Deletion.delete_game game
    expect(flag).to be true
  end
  it "create planet" do
    player = Creation.create_player "Jack"
    game = Creation.create_game(
      player , "game_create_planets", 
      { width: 5, height: 5 },
      3, 5, "1234", { has_pin_code: false,
      buffs: false, production_after_capture: false,
      pirates: false, accumulative: false })
    cells = Creation.create_cells game
    planets = Creation.create_planets game
    check = planets.count == game.planets_count
    Deletion.delete_game game
    expect(planets.count).to eq(game.planets_count)
  end
end