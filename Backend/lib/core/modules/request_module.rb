require "uri"
require "net/http"

module RequestModule

  def get_bot_names
    response_string = Net::HTTP.get(URI.parse('http://192.168.31.230:3131/ai/names'), nil)
    response = JSON.parse response_string
    response["all"]
  end

  def post_info_to_bot

  end

end