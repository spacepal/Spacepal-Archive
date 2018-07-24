require_relative 'play_modules/pirates_module.rb'
require_relative 'play_modules/fleets_module.rb'
require_relative 'play_modules/planets_module.rb'
require_relative 'play_modules/players_module.rb'
require_relative 'play_modules/game_module.rb'

module Playable

  include PirateModule
  include FleetModule
  include PlanetModule
  include PlayerModule
  include GameModule

  def make_step
    "make_step".bg(:yellow).color(:black).out
    execute_pirates
    p "ms1"
    execute_fleets
    p "ms2"
    execute_planets
    p "ms3"
    execute_players
    p "ms4"
    execute_game
    p "ms5"
  end

end