require "rails_helper"

RSpec.describe "redis" do
  it "makes everything" do
    $redis.flushall
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

    planet = Planet.new
    planet.set_properties
    planet.save


    player = Player.new
    player.is_admin = true
    player.name = "1"
    player.color_id = Player::DEFAULT_COLOR
    player.is_ai = false
    player.save

    game.planets << planet
    game.players << player
    player.planets << planet

    expect(game.planets.all).to_not be_nil 

  end  
end