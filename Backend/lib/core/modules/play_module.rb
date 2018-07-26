require_relative 'play_modules/pirates_module.rb'
require_relative 'play_modules/fleets_module.rb'
require_relative 'play_modules/planets_module.rb'
require_relative 'play_modules/players_module.rb'
require_relative 'play_modules/game_module.rb'
require_relative 'play_modules/notifications_module.rb'

module Playable

  include PirateModule
  include FleetModule
  include PlanetModule
  include PlayerModule
  include GameModule
  include NotificationModule

  def make_step
    "   play: make_step".bg(:cyan).color(:black).out
    self.execute_pirates
    self.execute_fleets
    self.execute_planets
    self.execute_players
    self.execute_game
    self.execute_notifications
    "   play: make_step: end".bg(:cyan).color(:black).out
    "@notifications: #{@notifications}".out
  end

end