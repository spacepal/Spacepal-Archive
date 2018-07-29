require "uri"
require "net/http"

module RequestModule

HOST_NAME = ENV["SPACEPAL_AISERVICE_LOCAL"] or 'localhost:3131'

  def get_bot_names
    response_string = Net::HTTP.get(URI.parse('http://' + HOST_NAME + '/ai/names'), nil)
    response = JSON.parse response_string
    response["all"]
  end

  def post_info_to_bot
    game = Game[@game_id]
    ai_players = game.bots.map do |bot|
      unless bot.end_turn? or bot.game_over?
      {
        "playerID" => bot.id.to_i,
        "aiName" => bot.ai_name
      }
      end
    end
    ai_players.compact!
    if ai_players.count > 0
      data = {
        "callback" => "http://localhost:3000/api/games/#{game.id}/steps/#{game.step}",
        "aiPlayers" => ai_players,
        "map" => game.map_size,
        "planets" => game.planets_info
      }
      response_string = Net::HTTP.post(URI.parse('http://' + HOST_NAME + '/ai/do'), data.to_json)
      response_string.body.bg(:yellow).color(:black).out
    end
  end

end
