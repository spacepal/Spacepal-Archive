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
    "   play: make_step".bg(:cyan).color(:black).out
    execute_pirates
    execute_fleets
    execute_planets
    execute_players
    execute_game
    "   play: make_step: end".bg(:cyan).color(:black).out
  end

end