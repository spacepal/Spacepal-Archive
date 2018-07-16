require_relative 'modules/broadcast_module.rb'
require_relative 'modules/act_module.rb'
require_relative 'modules/play_module.rb'

#общий класс
class Core

  include Broadcastable
  include Actable
  include Playable

end