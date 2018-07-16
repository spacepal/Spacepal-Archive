require_relative 'modules/broadcast_module.rb'
require_relative 'modules/player_activities_module.rb'
require_relative 'modules/game_module.rb'

#общий класс
class Core

  include BroadcastModule
  include PlayerActivitiesModule
  include GameModule

end