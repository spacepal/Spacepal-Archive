require_relative 'bot_modules/request_module.rb'

module Botable

  include RequestModule

  def create_bot
    game = Game[@game_id]
    names = get_bot_names || ["first_bot", "second_bot"]
    game.add_player_bot names.sample
  end

  def delete_bot player_id
    Game[@game_id].remove_bot player_id
  end

  def bot_make_step
    "   bot: bot_make_step".bg(:orange).color(:black).out
    if Game[@game_id].bots?
      self.post_info_to_bot
    end
  end

  def save_bot_fleets bot_fleets
    "   bot: save_bot_fleets".bg(:orange).color(:black).out
    Creation.create_bot_fleets bot_fleets
  end

  def bot_end_turn
    "   bot: bot_end_turn".bg(:orange).color(:black).out
    Game[@game_id].bots.each { |bot| bot.end_turn }
  end

end