require_relative 'modules/broadcast_module.rb'
require_relative 'modules/end_turn_module.rb'
require_relative 'modules/game_module.rb'

#общий класс
class Core

  include BroadcastModule
  include EndTurnModule
  include GameModule

end