require_relative 'modules/broadcast_module.rb'
require_relative 'modules/act_module.rb'
require_relative 'modules/play_module.rb'

#общий класс
class Core

  include Broadcastable
  include Actable
  include Playable

  attr_accessor :player_id

  def initialize game_id, player_id
    @game_id = game_id
    @player_id = player_id
  end

  def shuffle
    self.shuffle_map
    self.broadcast_planets
  end

  def start_game
    self.start_playing
    self.gain_players_planet_exp
    self.broadcast_all_data
  end

  def end_turn fleets = []
    player = Player[@player_id]
    game = player.game
    self.player_ends_turn fleets
    if self.everybody_ends_turn?
      make_step
      if game.over?
        self.broadcast_on_end_game
      else
        self.broadcast_on_everybody_ends_turn
      end
    else
      self.broadcast_on_player_ends_turn
    end
  end

  def check_game_on_leaving
    game = Game[@game_id]
    self.execute_game
    if game.over?
      self.broadcast_on_end_game
    else
      self.broadcast_on_everybody_ends_turn
    end
  end

  def broadcast_on_player_ends_turn
    self.broadcast_player
    self.broadcast_players
  end

  def broadcast_on_everybody_ends_turn
    self.broadcast_end_turn
    self.broadcast_all_data
  end

  def broadcast_on_end_game
    self.broadcast_game
    self.broadcast_players
  end

end
