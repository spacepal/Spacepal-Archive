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
    @notifications = Hash.new
    Game[@game_id]&.players&.each do |player|
      @notifications[player.id] = Array.new
    end
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
    "end_turn".bg(:green).color(:black).out
    self.start_playing
    self.gain_players_planet_exp
    self.clear_notifications
    self.broadcast_on_start_game
    self.bot_make_step
  end

  def end_turn fleets = []
    "end_turn".bg(:green).color(:black).out
    player = Player[@player_id]
    unless player.end_turn?
      game = player.game
      self.player_ends_turn fleets
      p "fkmjifjlfkjsnoijdkfnlsrjtiu"
      if self.everybody_ends_turn?
        p "vspoienvoekmvs;eoivnspioer"
        self.game_end_turn
      else 
        self.broadcast_on_player_ends_turn
        self.broadcast_player
      end
    end
  end

  def game_end_turn
    "game_end_turn".bg(:green).color(:black).out
    game = Game[@game_id]
    self.make_step
    if game.over?
      self.broadcast_on_end_game
    else
      self.broadcast_on_everybody_ends_turn
      self.bot_make_step
    end
  end

  def bot_make_turn fleets
    "bot_end_turn".bg(:green).color(:black).out
    self.save_bot_fleets fleets
    self.bot_end_turn
    if self.everybody_ends_turn?
        self.game_end_turn
    else 
      self.broadcast_players
    end
  end

  def send_asked_data
    if Game[@game_id].room?
      self.broadcast_the_rest_of_data_in_room
    else
      self.broadcast_the_rest_of_data_on_play
    end
  end

  def check_game_on_leaving
    game = Game[@game_id]
    self.act_on_leaving
    if game.over?
      self.broadcast_on_end_game
    else
      #self.broadcast_on_everybody_ends_turn
    end
  end

end
