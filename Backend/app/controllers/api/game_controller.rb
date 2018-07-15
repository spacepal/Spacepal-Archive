class Api::GameController < ApplicationController

  def index
    arr = Game.get_all :offset => params[:offset], :limit => params[:limit]
    render :json => { games: arr, :count => $redis.zcard("game:ids") }
  end

  def create
    request.remote_ip.to_s.color("yellow").out
    data = self.game_params
    player = Creation.create_player data[:username]
    if !player.errors.empty?
      render :json => { errors: player.errors.messages.flatten }
      return
    end
    flags = {}
    flags[:has_pin_code] = data[:flags][:hasPinCode]
    flags[:buffs] = data[:flags][:buffs]
    flags[:production_after_capture] = data[:flags][:productionAfterCapture]
    flags[:pirates] = data[:flags][:pirates]
    flags[:accumulative] = data[:flags][:accumulative]
    game = Creation.create_game player, data[:gamename],
      data[:map], data[:playersLimit], data[:planetsCount],
      data[:pinCode], flags
    if game.errors.empty?
      Creation.create_cells game
      Creation.create_planets game
      cookies.encrypted[:player_id] = player.id
      cookies.encrypted[:game_id] = game.id
      render :json => { errors: nil, gameID: game.id }
      return
    else
      render :json => { errors: game.errors.messages.flatten }
      return
    end
  end

  def join
    game_id = params[:id].to_i
    data = self.game_params
    game = Game[game_id]
    if !game
      render :json => { errors: ["can't find game with id " + game.id.to_s] }
    end
    if game.is_room?
      if game.pin_code
        if data[:pinCode] != game.pin_code
          render :json => { errors: ["the pin code is wrong"] }
          return
        end
      end
      player = game.add_player data[:username]
      if player
        cookies.encrypted[:player_id] = player.id
        cookies.encrypted[:game_id] = game.id
        render :json => { errors: nil }
        return
      else
        render :json => { errors: game.errors.messages.flatten }
        return
      end
    else
      render :json => { errors: ["the game was started"]}
      return
    end
  end

  def leave
    game = Game[cookies.encrypted[:game_id]]
    if game
      game = game.remove_player cookies.encrypted[:player_id]
      core = Core.new
      cookies.delete :game_id
      cookies.delete :player_id
      if game
        core.broadcast_players ("games:" + game.id.to_s), game.id
      end
      render :json => { errors: [ nil ]}
    else
      render :json => { errors: [ "Game\##{cookies.encrypted[:game_id]} does not exist" ]}
    end
  end

  def game_params
    params.require(:data).permit!
  end

end
