require_relative 'modules/broadcast_module.rb'
require_relative 'modules/act_module.rb'
require_relative 'modules/play_module.rb'
require_relative 'modules/bot_module.rb'

#общий класс
class Core

  include Broadcastable
  include Actable
  include Playable
  include Botable

  attr_accessor :player_id

  def initialize game_id, player_id
    @game_id = game_id
    @player_id = player_id
  end

  def shuffle
    self.shuffle_map
    self.broadcast_planets
  end

  def add_bot
    self.create_bot
    self.broadcast_players
  end

  def del_bot player_id
    self.delete_bot player_id
    self.broadcast_players
  end

  def start_game
    self.start_playing
    self.gain_players_planet_exp 
    self.broadcast_on_start_game
    self.bot_make_step
  end

  def end_turn fleets = []
    "end_turn".bg(:yellow).color(:black).out
    player = Player[@player_id]
    p "et1"
    unless player.end_turn?
      p "et2"
      game = player.game
      p "et3"
      self.player_ends_turn fleets
      p "et4"
      if self.everybody_ends_turn?
        p "et5"
        self.make_step #there was without self here ??????????
        p "et6"
        if game.over?
          p "et7"
          self.broadcast_on_end_game
          p "et8"
        else
          p "et9"
          self.broadcast_on_everybody_ends_turn
          p "et10"
          self.bot_make_step
          p "et11"
        end
          p "et12"
      else
        p "et13"
        self.broadcast_on_player_ends_turn
        p "et14"
        self.broadcast_player
        p "et15"
      end
    end
  end

  def bot_make_turn fleets
    self.save_bot_fleets fleets
    self.bot_end_turn
    self.broadcast_players
  end

  def send_asked_data
    self.broadcast_the_rest_of_data
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

end
